#!/usr/bin/env bash

CWD=$(realpath $(dirname $0))
# Color and Theme
ln -s $CWD/.minttyrc ~/.minttyrc
ln -s $CWD/.vimrc ~/.vimrc

# install oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && cp ys.zsh-theme ~/.oh-my-zsh/themes/ys-tweaked.zsh-theme
ln -s $CWD/.zshrc ~/.zshrc

current_user=`whoami`
USER_HOME=/cygdrive/c/Users/$current_user/

# Git global config
if [ -f "$USER_HOME/.gitconfig" ]; then
    ln -s $USER_HOME/.gitconfig ~/.gitconfig
fi
# ssh
if [ -d "$USER_HOME/.ssh/" ]; then
    ln -s $USER_HOME/.ssh/ ~/.ssh
fi
# Vim plugins (pathogen and others)
if [ ! -d "$USER_HOME/vimfiles/" ]; then
    mkdir -p $USER_HOME/vimfiles/autoload $USER_HOME/vimfiles/bundle
    curl -LSso $USER_HOME/vimfiles/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    # install plugins
    cd $USER_HOME/vimfiles/bundle
    git clone https://github.com/chriskempson/base16-vim
    git clone https://github.com/tpope/vim-surround
    git clone https://github.com/kien/ctrlp.vim
    git clone https://github.com/terryma/vim-multiple-cursors
    git clone https://github.com/bling/vim-airline
    cd -
fi
ln -s $USER_HOME/vimfiles/ ~/.vim

# chsh to zsh
if [ -f "~/.bash_profile" ]; then
    grep -e "^exec zsh \-l$" ~/.bash_profile 2&> /dev/null
    if [ "$?" != "0" ]; then
        echo "exec zsh -l" >> ~/.bash_profile
        source ~/.bash_profile
    fi
else
    echo "The ~/.bash_profile does not exist! Cannot chsh to zsh, do it manually."
    exit 1
fi
