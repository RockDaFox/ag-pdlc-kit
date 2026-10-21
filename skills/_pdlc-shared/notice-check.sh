#!/bin/sh
#
# Ag-PDLC Kit — refuses a commit that adds an AI-assistance notice nobody has
# reviewed. The notice ends every document an agent drafts, under the marker
# below; a human removes both as the review. This script makes forgetting that
# review impossible, not skipping it: `git commit --no-verify` still goes
# through.
#
# Usage:
#   sh notice-check.sh [DOCS_ROOT]            by hand: every line not committed
#   sh notice-check.sh --staged DOCS_ROOT     from the hook: the staged lines
#   sh notice-check.sh --install DOCS_ROOT    install the pre-commit hook
#
# DOCS_ROOT defaults to docs. Only lines added under it and in AGENTS.md
# count: a record committed with its notice keeps it, and editing it later is
# not refused. POSIX sh, no dependency beyond git.

set -u

marker='<!-- ai-draft -->'
tag='# ag-pdlc-kit'
mode=manual
case "${1:-}" in
--staged | --install) mode=${1#--} && shift ;;
esac
docs=${1:-docs}

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
	echo "not inside a git repository — nothing checked"
	exit 1
}
cd "$root" || exit 1

if [ "$mode" = install ]; then
	dest="$(git rev-parse --git-common-dir)/ag-pdlc-kit-notice-check.sh"
	hook="$(git rev-parse --git-path hooks)/pre-commit"
	call="ag_pdlc_kit=\"\$(git rev-parse --git-common-dir)/ag-pdlc-kit-notice-check.sh\"; if [ -f \"\$ag_pdlc_kit\" ]; then sh \"\$ag_pdlc_kit\" --staged '$docs' || exit 1; fi $tag"

	# A shebang naming a shell, or none — git then runs the hook with sh, as
	# hook managers that write bare command files rely on.
	first=$( [ -f "$hook" ] && head -n 1 "$hook")
	case "$first" in
	'#!'*sh | '#!'*'sh '*) skip=1 ;;
	'#!'*)
		echo "$hook is not a shell script, so it was left untouched and nothing was written."
		echo "To install by hand, copy $0 to $dest, then have that hook — or the"
		echo "hook manager behind it — run this command and stop the commit when it fails:"
		echo "  sh $dest --staged '$docs'"
		exit 1
		;;
	*) skip=0 ;;
	esac

	cp "$0" "$dest" || exit 1
	echo "wrote $dest"
	if [ ! -f "$hook" ]; then
		mkdir -p "$(dirname "$hook")"
		printf '#!/bin/sh\n%s\n' "$call" >"$hook" && chmod +x "$hook" || exit 1
		echo "wrote $hook"
	elif grep -qF "$tag" "$hook"; then
		echo "$hook already calls the check — nothing added"
	else
		# Right after the shebang, so an exit or exec further down the hook
		# cannot skip it. The trailing dot keeps the file's final newlines.
		new=$({
			[ "$skip" = 1 ] && head -n 1 "$hook"
			printf '%s\n' "$call"
			tail -n +$((skip + 1)) "$hook"
		} && echo .)
		printf '%s' "${new%.}" >"$hook" || exit 1
		echo "added the check to $hook, at its top"
	fi
	echo "A commit adding '$marker' under $docs/ or in AGENTS.md is now refused. 'git commit --no-verify' bypasses it."
	exit 0
fi

# Prints each file where an added line holds the marker.
added() {
	git diff "$@" -U0 --no-color --no-ext-diff -- "$docs" AGENTS.md |
		awk -v m="$marker" '/^\+\+\+ /{f=substr($0, 7); next} /^\+/ && index($0, m){print f}'
}

found=$(
	added --cached
	if [ "$mode" = manual ]; then
		added
		git ls-files --others --exclude-standard -- "$docs" AGENTS.md |
			while IFS= read -r f; do grep -qF "$marker" "$f" && echo "$f"; done
	fi
)

if [ -n "$found" ]; then
	echo "An AI-assistance notice has not been reviewed in:"
	printf '%s\n' "$found" | sort -u | sed 's/^/  /'
	echo "Read each document, then remove its notice and the '$marker' line above it."
	exit 1
fi
[ "$mode" = manual ] && echo "no unreviewed AI notice under $docs/ or in AGENTS.md."
exit 0
