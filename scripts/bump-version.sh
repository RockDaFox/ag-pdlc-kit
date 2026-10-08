#!/bin/sh
#
# Bumps the version in both plugin.json manifests together, so a release
# never advances one and forgets the other — the omission scripts/check.sh
# can only notice after the fact.
#
# Usage:  sh scripts/bump-version.sh major|minor|patch|X.Y.Z
# Exit:   0 on success, 1 on a bad argument or a manifest it cannot read
#
# POSIX sh, no dependency, same textual reads as scripts/check.sh: sh has no
# JSON parser and a dependency would defeat the point of a script this small.

set -u

cd "$(dirname "$0")/.." || exit 1

_cc_p=.claude-plugin/plugin.json
_gh_p=.github/plugin/plugin.json
_vibe_p=.vibe/plugin.json

field() {
	sed -n "s/.*\"$2\"[ ]*:[ ]*\"\([^\"]*\)\".*/\1/p" "$1" | sed -n 1p
}

_cur=$(field "$_cc_p" version)
if [ -z "$_cur" ]; then
	echo "cannot read \"version\" from $_cc_p — shape changed, refusing to guess"
	exit 1
fi

case "$_cur" in
[0-9]*.[0-9]*.[0-9]*) ;;
*)
	echo "$_cc_p  version \"$_cur\" is not major.minor.patch, refusing to bump it"
	exit 1
	;;
esac

_major=${_cur%%.*}
_rest=${_cur#*.}
_minor=${_rest%%.*}
_patch=${_rest#*.}

case "${1:-}" in
major)
	_new="$((_major + 1)).0.0"
	;;
minor)
	_new="$_major.$((_minor + 1)).0"
	;;
patch)
	_new="$_major.$_minor.$((_patch + 1))"
	;;
[0-9]*.[0-9]*.[0-9]*)
	_new="$1"
	;;
*)
	echo "usage: sh scripts/bump-version.sh major|minor|patch|X.Y.Z"
	exit 1
	;;
esac

for m in "$_cc_p" "$_gh_p" "$_vibe_p"; do
	[ -f "$m" ] || {
		echo "$m  missing"
		exit 1
	}
	_have=$(field "$m" version)
	[ "$_have" = "$_cur" ] || {
		echo "$m  version is \"$_have\", expected \"$_cur\" — already disagreeing, run scripts/check.sh first"
		exit 1
	}
done

for m in "$_cc_p" "$_gh_p" "$_vibe_p"; do
	sed -i.bak "s/\"version\": \"$_cur\"/\"version\": \"$_new\"/" "$m" && rm -f "$m.bak"
done

echo "$_cur -> $_new in $_cc_p, $_gh_p and $_vibe_p"