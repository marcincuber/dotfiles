#!/usr/bin/env bash
set -euo pipefail

# Install Homebrew
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "brew already installed, skipping."
fi

# Install oh-my-zsh
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh-my-zsh already installed, skipping."
fi

# Install RVM
if ! command -v rvm &>/dev/null; then
  curl -sSL https://get.rvm.io | bash
else
  echo "rvm already installed, skipping."
fi

# Install NVM (Node Version Manager) — resolves latest release tag from GitHub
# Checked via ~/.nvm directory: nvm is a shell function, not a binary, so command -v won't find it
if [[ ! -d "${HOME}/.nvm" ]]; then
  NVM_VERSION=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest \
    | python3 -c "import sys, json; print(json.load(sys.stdin)['tag_name'])")
  if [[ -z "${NVM_VERSION}" ]]; then
    echo "error: could not resolve latest nvm version from GitHub API" >&2
    exit 1
  fi
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
else
  echo "nvm already installed, skipping."
fi
