#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "install_pkgs.sh" \
		--exclude "convert_p7b.sh" \
		--exclude "brew.sh" \
		-avh --no-perms . ~;
	printf '\nDotfiles deployed. Reloading shell…\n';
	exec zsh -l;
}

if [[ "${1:-}" == "--force" || "${1:-}" == "-f" ]]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
