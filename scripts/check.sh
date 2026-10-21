#!/bin/sh
#
# Checks this repository for the things that break silently — a manifest that
# disagrees with its three siblings, a supersession recorded on one side only,
# a skill no host can discover, a link that stopped resolving, an ADR about to
# be committed with its review marker still on. Reports, never fixes: every
# finding is a line of prose for a human or an agent to act on.
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

# A copy run from outside the repository would land elsewhere, and the find
# fallback below would then walk whatever directory that is — up to the whole
# disk.
if [ ! -f AGENTS.md ] || [ ! -d skills ]; then
	echo "not in the Ag-PDLC Kit repository: $(pwd) — this script checks the kit only"
	exit 1
fi

# Whether git can answer questions about this tree. The check that needs to
# know whether a record is still a draft says so rather than guessing when it
# cannot: a check that goes quiet is worse than one that admits it is blind.
have_git=no
if [ -d .git ] && command -v git >/dev/null 2>&1; then
	have_git=yes
fi

md_files() {
	if [ "$have_git" = yes ]; then
		git ls-files '*.md'
	else
		find . -name '*.md' -not -path './.git/*' -not -path './.claude/*' |
			sed 's|^\./||'
	fi
}

# Reads a JSON string field: field FILE KEY [plugins]. These four manifests are
# small and hand-written, so they are read textually — sh has no JSON parser,
# and a dependency would defeat the point of a script that needs nothing.
# With "plugins", it reads inside the plugins array: a marketplace holds its
# own name and description, then the owner's name, then the entry's, so the
# first occurrence from the top of the file is the wrong one.
field() {
	if [ "${3:-}" = plugins ]; then sed -n '/"plugins"/,$p' "$1"; else cat "$1"; fi |
		sed -n "s/.*\"$2\"[ ]*:[ ]*\"\([^\"]*\)\".*/\1/p" | sed -n 1p
}

# Compares one field across two manifests: agree FILE1 FILE2 KEY [plugins].
# An empty read is a finding, not a pass: a check that goes quiet when the
# file shape changes is worse than one that fails.
agree() {
	_a=$(field "$1" "$3" "${4:-}")
	_b=$(field "$2" "$3" "${4:-}")
	_k="\"$3\"${4:+ in the plugin entry}"
	if [ -z "$_a" ] || [ -z "$_b" ]; then
		echo "cannot read $_k from $1 and $2 — shape changed, this check is blind"
	elif [ "$_a" != "$_b" ]; then
		echo "$_k disagrees between $1 and $2"
	fi
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

	agree "$_cc_p" "$_gh_p" version
	agree "$_cc_p" "$_gh_p" description
	agree "$_cc_m" "$_gh_m" description
	agree "$_cc_m" "$_gh_m" description plugins

	# One name everywhere, the Claude Code plugin.json as the reference.
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
			_got=$(field "$m" name plugins)
			[ "$_got" = "$_want" ] ||
				echo "$m  plugin entry is named \"$_got\", not \"$_want\""
		done
	fi

	# A key in one marketplace plugin entry and not the other is a note, not a
	# finding: the hosts read different schemas, so an asymmetry may be
	# deliberate. "skills" is not compared, and that is measured rather than
	# assumed — in Anthropic's official marketplace, 3 of 292 plugin entries
	# carry it and all three use it to select subdirectories of a repository
	# that is not itself a plugin. Claude Code discovers components from the
	# plugin root; Copilot declares them in the marketplace entry.
	for k in source category; do
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

		# The AI-assistance notice marks a record nobody has read, and a human
		# strips it as part of the review that precedes the commit (ADR-0013).
		# Uncommitted files only: afterwards the record is immutable, the line
		# is permanent, and reporting it on every run would be crying wolf over
		# something nobody is allowed to fix.
		if grep -q 'Drafted with an AI assistant' "$f"; then
			if [ "$have_git" != yes ]; then
				echo "note: git unavailable, so whether $f is still a draft cannot be established"
			elif [ -z "$(git log --oneline -1 -- "$f" 2>/dev/null)" ]; then
				echo "$f  still carries the AI-assistance notice — read the record and strip the line before the commit makes it permanent"
			fi
		fi

		_sup=$(sed -n \
			's/^| \*\*Supersedes\*\* | \[ADR-\([0-9][0-9]*\)\].*/\1/p' "$f")
		[ -n "$_sup" ] || continue
		# The old side is read in its Status row only: a record may mention the
		# word anywhere else in its text.
		_old=$(echo docs/adr/"$_sup"-*.md)
		if [ ! -e "$_old" ]; then
			echo "$f  supersedes ADR-$_sup, which does not exist"
		elif ! grep -q '^| \*\*Status\*\* | Superseded' "$_old"; then
			echo "$_old  is superseded by $(basename "$f") and does not say so — a supersession is two edits"
		fi
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

notes=$(printf '%s\n' "$out" | grep -c '^note: ')
n=$(printf '%s\n' "$out" | grep -c -v -e '^note: ' -e '^$')

if [ "$n" -eq 0 ]; then
	[ "$notes" -eq 0 ] && echo "clean." || echo "clean, $notes note(s)."
	exit 0
fi

printf '\n%s finding(s).\n' "$n"
exit 1
