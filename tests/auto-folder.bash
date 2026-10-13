#!/usr/bin/env bash
set -Eeuo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
script="$script_dir/auto-folder"
tmp_dir=$(mktemp -d)
trap 'rm -rf -- "$tmp_dir"' EXIT

fail() {
	printf 'FAIL: %s\n' "$1" >&2
	exit 1
}

assert_scaffold() {
	local target=$1
	local path
	for path in \
		src tests docs scripts config assets/images assets/data \
		build .github/workflows
	do
		[[ -d "$target/$path" ]] || fail "expected directory $target/$path"
	done
}

help_output=$("$script" --help)
[[ "$help_output" == "Usage: auto-folder [project-directory]" ]] ||
	fail "unexpected help output: $help_output"

(cd -- "$tmp_dir" && "$script" >/dev/null)
assert_scaffold "$tmp_dir"

target="$tmp_dir/nested/project"
"$script" "$target" >/dev/null
assert_scaffold "$target"

printf 'keep\n' > "$target/keep.txt"
"$script" "$target" >/dev/null
[[ -f "$target/keep.txt" ]] || fail "existing files should be preserved"

if "$script" one two >"$tmp_dir/args.out" 2>"$tmp_dir/args.err"; then
	fail "expected extra arguments to be rejected"
else
	status=$?
	[[ "$status" -eq 2 ]] || fail "expected exit status 2 for extra arguments, got $status"
	grep -q '^Usage:' "$tmp_dir/args.err" || fail "expected usage on stderr"
fi

touch "$tmp_dir/not-a-directory"
if "$script" "$tmp_dir/not-a-directory" >"$tmp_dir/file.out" 2>"$tmp_dir/file.err"; then
	fail "expected a file target to be rejected"
else
	status=$?
	[[ "$status" -eq 1 ]] || fail "expected exit status 1 for file target, got $status"
	grep -q 'exists and is not a directory' "$tmp_dir/file.err" ||
		fail "expected a clear error for a file target"
fi

printf 'All auto-folder tests passed.\n'
