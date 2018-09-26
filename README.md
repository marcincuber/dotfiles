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

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

```bash
# Git credentials
GIT_AUTHOR_NAME="Marcin Cuber"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "marcincuber"
GIT_AUTHOR_EMAIL="marcincuber@hotmail.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

### Install and pull packages

```bash
./install_pkgs.sh
```
### Install Homebrew formulae

```bash
./brew.sh
```

## Author

[Marcin Cuber](https://github.com/marcincuber)
