#!/bin/sh
#
# Checks this repository for the things that break silently — a manifest that
# disagrees with its three siblings, a supersession recorded on one side only,
# a skill no host can discover, a link that stopped resolving. Reports, never
# fixes: every finding is a line of prose for a human or an agent to act on.
#
# Nothing under skills/ invokes this file, and no skill ever will — it is
# maintainer tooling, not product surface (ADR-0008).
#
# Usage:  sh scripts/check.sh          from anywhere in the repository
# Exit:   0 clean, 1 findings
#
# POSIX sh, no dependency. It reads the repository and writes nothing, not even
# a temporary file, so it can be audited in one pass.

set -u

cd "$(dirname "$0")/.." || exit 1

md_files() {
	if [ -d .git ] && command -v git >/dev/null 2>&1; then
		git ls-files '*.md'
	else
		find . -name '*.md' -not -path './.git/*' -not -path './.claude/*' |
			sed 's|^\./||'
	fi
}

# Reads a JSON string field. These four manifests are small and hand-written,
# so they are read textually — sh has no JSON parser, and a dependency would
# defeat the point of a script that needs nothing. Every call site treats an
# empty result as a finding rather than a pass: a check that goes quiet when
# the file shape changes is worse than one that fails.
field() {
	sed -n "s/.*\"$2\"[ ]*:[ ]*\"\([^\"]*\)\".*/\1/p" "$1" | sed -n 1p
}

# The same, inside the plugins array. A marketplace holds its own name and
# description, then the owner's name, then the entry's, so counting occurrences
# from the top of the file reads the wrong one.
entry_field() {
	sed -n '/"plugins"/,$p' "$1" |
		sed -n "s/.*\"$2\"[ ]*:[ ]*\"\([^\"]*\)\".*/\1/p" | sed -n 1p
}

# --- the checks -------------------------------------------------------------
#
# Each one prints a finding per line. A line starting with "note: " is printed
# but not counted — something to keep an eye on, not something wrong.

check_headings() {
	for f in $(md_files); do
		grep '^#\{1,6\} ' "$f" 2>/dev/null | sort | uniq -d |
			sed "s|^|$f  heading appears twice: |"
	done
}

# The templates are skipped whole: their links are placeholders meant to
# resolve in the repository the template is written into, not in this one.
check_links() {
	for f in $(md_files); do
		case "$f" in skills/_pdlc-shared/templates/*) continue ;; esac
		_dir=$(dirname "$f")
		for t in $(grep -o '](\([^) ]*\))' "$f" 2>/dev/null |
			sed 's/^](//; s/)$//' | sort -u); do
			case "$t" in
			http* | mailto:* | \#*) continue ;;
			*'{'* | *'<'* | *NNNN*) continue ;;
			esac
			_p=${t%%#*}
			[ -n "$_p" ] || continue
			[ -e "$_dir/$_p" ] || echo "$f  link does not resolve: $t"
		done
	done
}

check_manifests() {
	_cc_p=.claude-plugin/plugin.json
	_gh_p=.github/plugin/plugin.json
	_cc_m=.claude-plugin/marketplace.json
	_gh_m=.github/plugin/marketplace.json

	for m in "$_cc_p" "$_gh_p" "$_cc_m" "$_gh_m"; do
		[ -f "$m" ] || echo "$m  missing"
	done

	_v1=$(field "$_cc_p" version)
	_v2=$(field "$_gh_p" version)
	if [ -z "$_v1" ] || [ -z "$_v2" ]; then
		echo "cannot read \"version\" from both plugin.json — shape changed, this check is blind"
	elif [ "$_v1" != "$_v2" ]; then
		echo "version disagrees: $_cc_p says $_v1, $_gh_p says $_v2"
	fi

	_want=$(field "$_cc_p" name)
	if [ -z "$_want" ]; then
		echo "$_cc_p  cannot read \"name\" — shape changed, this check is blind"
	else
		for m in "$_gh_p" "$_cc_m" "$_gh_m"; do
			_got=$(field "$m" name)
			[ "$_got" = "$_want" ] ||
				echo "$m  name is \"$_got\", $_cc_p says \"$_want\""
		done
		for m in "$_cc_m" "$_gh_m"; do
			_got=$(entry_field "$m" name)
			[ "$_got" = "$_want" ] ||
				echo "$m  plugin entry is named \"$_got\", not \"$_want\""
		done
	fi

	_d1=$(field "$_cc_p" description)
	_d2=$(field "$_gh_p" description)
	if [ -z "$_d1" ] || [ -z "$_d2" ]; then
		echo "cannot read \"description\" from both plugin.json — shape changed, this check is blind"
	elif [ "$_d1" != "$_d2" ]; then
		echo "the two plugin.json describe the product differently"
	fi

	_a=$(field "$_cc_m" description)
	_b=$(field "$_gh_m" description)
	if [ -z "$_a" ] || [ -z "$_b" ]; then
		echo "cannot read \"description\" from both marketplace.json — shape changed, this check is blind"
	elif [ "$_a" != "$_b" ]; then
		echo "the two marketplace.json describe the marketplace differently"
	fi

	_a=$(entry_field "$_cc_m" description)
	_b=$(entry_field "$_gh_m" description)
	if [ -z "$_a" ] || [ -z "$_b" ]; then
		echo "cannot read the plugin entry description from both marketplace.json — shape changed, this check is blind"
	elif [ "$_a" != "$_b" ]; then
		echo "the two marketplace plugin entries describe the plugin differently"
	fi

	# A key in one marketplace plugin entry and not the other is a note: the
	# hosts read different schemas, so the asymmetry may be deliberate. It is
	# printed so that it stays visible instead of being forgotten.
	for k in skills source category; do
		grep -q "\"$k\"" "$_cc_m" && _a=present || _a=absent
		grep -q "\"$k\"" "$_gh_m" && _b=present || _b=absent
		[ "$_a" = "$_b" ] ||
			echo "note: \"$k\" is $_a in $_cc_m and $_b in $_gh_m"
	done
}

check_decision_log() {
	_n=0
	for f in docs/adr/[0-9]*.md; do
		[ -e "$f" ] || break
		_n=$((_n + 1))
		_num=$(basename "$f" | cut -c1-4)
		_exp=$(printf '%04d' "$_n")
		[ "$_num" = "$_exp" ] ||
			echo "docs/adr/  numbering breaks at $_num, $_exp expected — and a number is never reused"
		grep -q '^| \*\*Status\*\* |' "$f" || echo "$f  has no Status row"
		grep -q '^| \*\*Date\*\* |' "$f" || echo "$f  has no Date row"

		_sup=$(sed -n \
			's/^| \*\*Supersedes\*\* | \[ADR-\([0-9][0-9]*\)\].*/\1/p' "$f")
		[ -n "$_sup" ] || continue
		_hit=no
		for p in docs/adr/"$_sup"-*.md; do
			[ -e "$p" ] || continue
			_hit=yes
			grep -q 'Superseded' "$p" ||
				echo "$p  is superseded by $(basename "$f") and does not say so — a supersession is two edits"
		done
		[ "$_hit" = yes ] ||
			echo "$f  supersedes ADR-$_sup, which does not exist"
	done
}

check_skills() {
	for d in skills/*/; do
		case "$d" in skills/_*) continue ;; esac
		_s="${d}SKILL.md"
		if [ ! -f "$_s" ]; then
			echo "$d  has no SKILL.md, so no host discovers it"
			continue
		fi
		head -1 "$_s" | grep -q '^---' ||
			echo "$_s  does not open with frontmatter"
		_nm=$(sed -n 's/^name: *//p' "$_s" | head -1)
		_want=$(basename "$d")
		[ "$_nm" = "$_want" ] ||
			echo "$_s  declares name: $_nm but sits in $_want/"
		grep -q '^description: ' "$_s" ||
			echo "$_s  has no description, so nothing routes to it"
	done
}

# --- report -----------------------------------------------------------------

out=$(
	check_headings
	check_links
	check_manifests
	check_decision_log
	check_skills
)

[ -n "$out" ] && printf '%s\n' "$out"

n=$(printf '%s\n' "$out" | grep -c '^[^ ]' | tr -d ' ')
notes=$(printf '%s\n' "$out" | grep -c '^note: ' | tr -d ' ')
n=$((n - notes))

if [ "$n" -eq 0 ]; then
	[ "$notes" -eq 0 ] && echo "clean." || echo "clean, $notes note(s)."
	exit 0
fi

printf '\n%s finding(s).\n' "$n"
exit 1
