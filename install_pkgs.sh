#!/usr/bin/env bash

# Pull repository to Documents.
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/Documents

# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Install ruby
curl -sSL https://get.rvm.io | bash -s stable --ruby
