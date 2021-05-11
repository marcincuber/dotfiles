#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.

brew install watch
brew install watchman
brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install tools
brew install akamai
brew install awscli
brew install aws-iam-authenticator
brew install aws-okta
brew install saml2aws
brew install httpie
brew install packer
brew install telnet
brew install tfenv
brew install vault
brew install yarn

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install openssl
brew install screen
brew install make

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
brew install xpdf

# Install other useful binaries.
brew install ack
brew install cfssl
brew install jq
brew install git
brew install git-lfs
brew install git-crypt
brew install git-secrets
brew install htop
brew install p7zip
brew install pigz
brew install pv
brew install pwgen
brew install rename
brew install rlwrap
brew install shellcheck
brew install ssh-copy-id
brew install tree
brew install yq

# K8s
brew install fluxctl
brew install kubernetes-cli
brew install kubectx
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
brew install nethack
brew install sl
brew install speedtest_cli
brew install youtube-dl
brew install neofetch
brew install lolcat

brew cask install aerial

# Remove outdated versions from the cellar.
brew cleanup
