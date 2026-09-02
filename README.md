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

To install Homebrew under `~/.homebrew` without sudo or administrator access:

```bash
./install_pkgs.sh --rootless-brew
```

Combine it with `--all` to use rootless Homebrew while installing everything:

```bash
./install_pkgs.sh --all --rootless-brew
```

This uses a nonstandard Homebrew prefix. Some formulae may need to build from
source, and casks or packages requiring system-level changes will still not work
without administrator access. A working Git installation is required.

### Install Homebrew formulae

```bash
./brew.sh
```

## Author

[Marcin Cuber](https://github.com/marcincuber)
