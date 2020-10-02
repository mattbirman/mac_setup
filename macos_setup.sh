#!/usr/bin/env bash
DIR=`cd $(dirname $0); pwd`
pushd /tmp

# download iTerm2
if ! [ -d "/Applications/iTerm.app" ]; then
    curl -L -s -o iTerm.zip https://iterm2.com/downloads/stable/iTerm2-3_3_6.zip
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
brew install coreutils git python vim fish tmux ag bat emacs-plus
brew cask install alfred dozer 1password fluor firefox slack

# install powerline fonts
PATH="/usr/local/opt/python/libexec/bin:${PATH}" pip install --user powerline-status

git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -fr fonts

# setup fish
rm -rf ~/.local/share/omf
curl -s -L https://get.oh-my.fish > omf-install.fish
fish omf-install.fish --noninteractive
rm omf-install.fish
fish -c 'omf install bass'
fish -c 'omf install bobthefish'

grep -sq fish /etc/shells
if [ $? -eq 1 ]; then
    sudo sh -c "echo /usr/local/bin/fish >> /etc/shells"
fi
chsh -s /usr/local/bin/fish

# install .dotfiles
git clone https://github.com/mattbirman/dotfiles
./dotfiles/setup.sh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

// set mac defaults
sudo defaults write bluetoothaudiod "Enable AAC codec" -bool true
mkdir ~/Pictures/Screenshots
defaults write com.apple.screencapture location ~/Pictures/Screenshots
// scroll speed, sidebar icon size, key repeat rate
popd

// install vim config
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
