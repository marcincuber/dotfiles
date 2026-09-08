# Marcin’s dotfiles

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/Projects/dotfiles`, with `~/dotfiles` as a symlink.) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/marcincuber/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
source bootstrap.sh
```

### Install and pull packages

```bash
./install_pkgs.sh
```

Install only NVM or RVM, or install both selectively:

```bash
./install_pkgs.sh --nvm
./install_pkgs.sh --rvm
./install_pkgs.sh --nvm --rvm
```

Use `./install_pkgs.sh --all` to explicitly install every supported package.

To install Homebrew under `/opt/homebrew` without invoking sudo:

```bash
./install_pkgs.sh --rootless-brew
```

Pass a different absolute installation path when needed:

```bash
./install_pkgs.sh --rootless-brew "${HOME}/.homebrew"
```

The current user must be able to write to the selected directory (or its parent
if the directory does not exist). If necessary, have an administrator create
the installation directory and grant the user ownership before running the
script.

The selected path is saved under `${XDG_CONFIG_HOME:-$HOME/.config}/homebrew`
and loaded by `.zshrc` in future shells. `/opt/homebrew` and the legacy
`~/.homebrew` path remain automatic fallbacks.

Combine it with `--all` to use rootless Homebrew while installing everything:

```bash
./install_pkgs.sh --all --rootless-brew /opt/homebrew
```

A custom path may be a nonstandard Homebrew prefix, so some formulae may need to
build from source. Casks or packages requiring system-level changes will still
not work without administrator access. A working Git installation is required.

### Install Homebrew formulae

```bash
./brew.sh
```

## Author

[Marcin Cuber](marcincuber.github.io)
[Native Cube Tools](https://native-cube.com)
