#!/usr/bin/env bash
set -euo pipefail

ROOTLESS_BREW=false
ROOTLESS_BREW_PREFIX="/opt/homebrew"
ROOTLESS_BREW_PREFIX_FILE="${XDG_CONFIG_HOME:-${HOME}/.config}/homebrew/rootless-prefix"
INSTALL_ALL=false
INSTALL_BREW=false
INSTALL_NVM=false
INSTALL_RVM=false
INSTALL_OH_MY_ZSH=false
SELECTION_MADE=false

usage() {
  cat <<EOF
Usage: ${0##*/} [OPTIONS]

  -a, --all                  Install Homebrew, Oh My Zsh, RVM, and NVM.
  -n, --nvm                  Install NVM only.
  -r, --rvm                  Install RVM only.
  -z, --oh-my-zsh            Install Oh My Zsh only.
      --rootless-brew [PATH] Install Homebrew without sudo (default: ${ROOTLESS_BREW_PREFIX}).
  -h, --help                 Show this help.

With no options, the script behaves like --all. Options can be combined.
Use --all --rootless-brew [PATH] to install everything with rootless Homebrew.
EOF
}

while (( $# > 0 )); do
  case "$1" in
    -a|--all)
      INSTALL_ALL=true
      SELECTION_MADE=true
      ;;
    -n|--nvm)
      INSTALL_NVM=true
      SELECTION_MADE=true
      ;;
    -r|--rvm)
      INSTALL_RVM=true
      SELECTION_MADE=true
      ;;
    -z|--oh-my-zsh)
      INSTALL_OH_MY_ZSH=true
      SELECTION_MADE=true
      ;;
    --rootless-brew)
      ROOTLESS_BREW=true
      INSTALL_BREW=true
      SELECTION_MADE=true
      if (( $# > 1 )) && [[ "$2" != -* ]]; then
        ROOTLESS_BREW_PREFIX="$2"
        shift
      fi
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ "${ROOTLESS_BREW}" == true ]]; then
  # Strip a trailing slash so path and parent checks behave consistently.
  ROOTLESS_BREW_PREFIX="${ROOTLESS_BREW_PREFIX%/}"

  if [[ -z "${ROOTLESS_BREW_PREFIX}" || "${ROOTLESS_BREW_PREFIX}" != /* ]]; then
    echo "error: the rootless Homebrew install path must be an absolute path" >&2
    exit 2
  elif [[ "${ROOTLESS_BREW_PREFIX}" == "/" ]]; then
    echo "error: / cannot be used as the rootless Homebrew install path" >&2
    exit 2
  fi
fi

if [[ "${SELECTION_MADE}" == false || "${INSTALL_ALL}" == true ]]; then
  INSTALL_BREW=true
  INSTALL_NVM=true
  INSTALL_RVM=true
  INSTALL_OH_MY_ZSH=true
fi

# Install Homebrew
if [[ "${INSTALL_BREW}" == true ]]; then
  if [[ "${ROOTLESS_BREW}" == true ]]; then
    ROOTLESS_BREW_PARENT="${ROOTLESS_BREW_PREFIX%/*}"
    [[ -n "${ROOTLESS_BREW_PARENT}" ]] || ROOTLESS_BREW_PARENT="/"

    if [[ -x "${ROOTLESS_BREW_PREFIX}/bin/brew" ]]; then
      echo "Rootless Homebrew already installed in ${ROOTLESS_BREW_PREFIX}, activating it."
    else
      if ! command -v git &>/dev/null || ! git --version &>/dev/null; then
        echo "error: rootless Homebrew installation requires a working git command" >&2
        exit 1
      elif [[ -e "${ROOTLESS_BREW_PREFIX}" && ! -d "${ROOTLESS_BREW_PREFIX}" ]]; then
        echo "error: ${ROOTLESS_BREW_PREFIX} exists but is not a directory" >&2
        exit 1
      elif [[ -d "${ROOTLESS_BREW_PREFIX}" && -n "$(ls -A "${ROOTLESS_BREW_PREFIX}")" ]]; then
        echo "error: ${ROOTLESS_BREW_PREFIX} is not empty and does not contain a working brew" >&2
        exit 1
      elif [[ -d "${ROOTLESS_BREW_PREFIX}" && ! -w "${ROOTLESS_BREW_PREFIX}" ]]; then
        echo "error: ${ROOTLESS_BREW_PREFIX} is not writable by the current user" >&2
        echo "Have an administrator create it and grant you ownership, then run this script again." >&2
        exit 1
      elif [[ ! -e "${ROOTLESS_BREW_PREFIX}" && ! -d "${ROOTLESS_BREW_PARENT}" ]]; then
        echo "error: ${ROOTLESS_BREW_PARENT} does not exist" >&2
        echo "Create the parent directory before running this script again." >&2
        exit 1
      elif [[ ! -e "${ROOTLESS_BREW_PREFIX}" && ! -w "${ROOTLESS_BREW_PARENT}" ]]; then
        echo "error: ${ROOTLESS_BREW_PARENT} is not writable by the current user" >&2
        echo "Have an administrator create ${ROOTLESS_BREW_PREFIX} and grant you ownership, then run this script again." >&2
        exit 1
      fi

      echo "Installing Homebrew without admin access in ${ROOTLESS_BREW_PREFIX}."
      git clone --depth=1 https://github.com/Homebrew/brew "${ROOTLESS_BREW_PREFIX}"
    fi

    eval "$("${ROOTLESS_BREW_PREFIX}/bin/brew" shellenv)"
    mkdir -p "${ROOTLESS_BREW_PREFIX_FILE%/*}"
    printf '%s\n' "${ROOTLESS_BREW_PREFIX}" > "${ROOTLESS_BREW_PREFIX_FILE}"
    echo "Saved the rootless Homebrew path to ${ROOTLESS_BREW_PREFIX_FILE}."
  elif ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "brew already installed, skipping."
  fi
fi

# Install oh-my-zsh
if [[ "${INSTALL_OH_MY_ZSH}" == true ]]; then
  if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "oh-my-zsh already installed, skipping."
  fi
fi

# Install RVM
if [[ "${INSTALL_RVM}" == true ]]; then
  if [[ ! -s "${HOME}/.rvm/scripts/rvm" ]]; then
    curl -sSL https://get.rvm.io | bash
  else
    echo "rvm already installed, skipping."
  fi
fi

# Install NVM (Node Version Manager) — resolves latest release tag from GitHub
# Checked via ~/.nvm directory: nvm is a shell function, not a binary, so command -v won't find it
if [[ "${INSTALL_NVM}" == true ]]; then
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
fi
