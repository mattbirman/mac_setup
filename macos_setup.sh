#!/usr/bin/env bash
DIR=`cd $(dirname $0); pwd`
pushd /tmp

# download iTerm2
if ! [ -d "/Applications/iTerm.app" ]; then
    curl -L -s -o iTerm.zip https://iterm2.com/downloads/stable/latest
    unzip iTerm.zip
    mv iTerm.app /Applications
    
    curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
fi

# install brew
which brew > /dev/null
if [ $? -eq 1 ]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update-reset
brew tap
brew update
brew install coreutils git python vim fish

# install janus vim
curl -L https://bit.ly/janus-bootstrap | bash

# setup fish
curl -s -L https://get.oh-my.fish > omf-install.fish
fish omf-install.fish --noninteractive
rm omf-install.fish
fish -c omf theme install agnoster
fish -c omf theme agnoster
grep -sq fish /etc/shells
if [ $? -eq 1 ]; then
    sudo sh -c "echo /usr/local/bin/fish >> /etc/shells"
fi
chsh -s /usr/local/bin/fish

# install .dotfiles
DOTFILES_DIR=$HOME/.dotfiles 
if ! [ -d $DOTFILES_DIR ]; then
    git clone --recurse-submodules https://github.com/mattbirman/dotfiles.git $DOTFILES_DIR 
fi

for file in $(ls $DOTFILES_DIR) do
  ln -sf "$DOTFILES_DIR/$file" "$HOME/.$file"
  echo "Linking $HOME/.$file"
done

popd