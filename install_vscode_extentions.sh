#!/usr/bin/env bash

set -u
set -o pipefail

extensions=(
    "anthropic.claude-code"
    "github.vscode-github-actions"
    "hashicorp.terraform"
    "ms-vscode.makefile-tools"
    "openai.chatgpt"
    "redhat.vscode-yaml"
    "shd101wyy.markdown-preview-enhanced"
    "zainchen.json"
)

if ! command -v code >/dev/null 2>&1; then
  printf 'Error: the VS Code command-line tool "code" was not found in PATH.\n' >&2
  printf 'In VS Code, run "Shell Command: Install '\''code'\'' command in PATH" and try again.\n' >&2
  exit 127
fi

total=${#extensions[@]}
succeeded=()
failed=()

printf 'Installing %d VS Code extension(s), one at a time...\n\n' "$total"

for index in "${!extensions[@]}"; do
  extension=${extensions[$index]}
  current=$((index + 1))

  printf '[%d/%d] Installing %s...\n' "$current" "$total" "$extension"

  if code --install-extension "$extension"; then
    succeeded+=("$extension")
    printf '[%d/%d] SUCCESS: %s\n\n' "$current" "$total" "$extension"
  else
    failed+=("$extension")
    printf '[%d/%d] FAILED: %s (continuing)\n\n' \
      "$current" "$total" "$extension" >&2
  fi
done

printf '%s\n' '----------------------------------------'
printf 'Installation complete: %d succeeded, %d failed.\n' \
  "${#succeeded[@]}" "${#failed[@]}"

if ((${#failed[@]} > 0)); then
  printf '\nFailed extension(s):\n' >&2
  printf '  - %s\n' "${failed[@]}" >&2
  exit 1
fi

exit 0
