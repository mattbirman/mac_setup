#!/usr/bin/env bash
DIR=`cd $(dirname $0); pwd`
pushd /tmp

# download iTerm2
if ! [ -d "/Applications/iTerm.app" ]; then
    curl -L -s -o iTerm.zip https://iterm2.com/downloads/stable/iTerm2-3_2_9.zip
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
brew install coreutils git python vim fish tmux go goenv rbenv ag
brew cask install alfred dozer

# install emacs
brew tap d12frosted/emacs-plus
brew install emacs-plus
brew linkapps emacs-plus
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
stack install apply-refact hlint stylish-haskell hasktags hoogle

# install janus vim
curl -L https://bit.ly/janus-bootstrap | bash

# install powerline fonts
PATH="/usr/local/opt/python/libexec/bin:${PATH}" pip install --user powerline-status

git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -fr fonts

# setup fish
curl -s -L https://get.oh-my.fish > omf-install.fish
fish omf-install.fish --noninteractive
rm omf-install.fish
fish -c 'omf install theme agnoster'
fish -c 'omf theme agnoster'
grep -sq fish /etc/shells
if [ $? -eq 1 ]; then
    sudo sh -c "echo /usr/local/bin/fish >> /etc/shells"
fi
chsh -s /usr/local/bin/fish

# install .dotfiles
DOTFILES_DIR=$HOME/.dotfiles 
if ! [ -d $DOTFILES_DIR ]; then
    mv $DOTFILES_DIR $HOME/.dotfiles_bak
    git clone --recurse-submodules https://github.com/mattbirman/dotfiles.git $DOTFILES_DIR
    $DOTFILES_DIR/setup.sh
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

popd 
