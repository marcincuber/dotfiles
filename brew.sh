#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
# export PATH="$(brew --prefix)/opt/findutils/libexec/gnubin:$PATH"
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
# export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
brew install gnu-sed

brew install watch
brew install watchman
brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install tools
brew install awscli
brew install aws-iam-authenticator
brew install saml2aws
brew install telnet
brew install tfenv

# Install more recent versions of some macOS tools.
brew install grep # export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
brew install openssh
brew install openssl
brew install screen
brew install make # export PATH="$(brew --prefix)/opt/make/libexec/gnubin:$PATH"

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install binutils # export PATH="$(brew --prefix)/opt/binutils/bin:$PATH"
brew install knock
brew install nmap
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace

# Install other useful binaries.
brew install jq
brew install git
brew install git-lfs
brew install htop
brew install p7zip
brew install pwgen
brew install rename
brew install ssh-copy-id # export PATH="$(brew --prefix)/opt/ssh-copy-id/bin:$PATH"
brew install tree
brew install yq

# K8s
brew install fluxctl
brew install kubernetes-cli
brew install kubernetes-helm
brew install kustomize
brew install minikube

# Docker
brew install hadolint

# brew installing games and fun stuff
brew install cheat
brew install cowsay
brew install figlet
brew install fortune
brew install sl
brew install neofetch
brew install lolcat

# Casks (GUI applications)
brew install --cask aerial

# Remove outdated versions from the cellar.
brew cleanup
