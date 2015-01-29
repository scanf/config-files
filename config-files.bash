#!/bin/bash

CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
GITHUB_ME=$HOME/src/github.com/scanf
S=/usr/bin/sudo

source $CONFIG_FILES_DIR/term/funcs # We need it for gicp

install_program() {
  echo Will be installing $1
  cd $GITHUB_ME
  gicp $1
  cd $GITHUB_ME/$1
  autoreconf -i
  ./configure
  $S make install
}

install_go() {
  cd $GITHUB_ME && gicp go
  cd go/
  git ch go1.4.1
  cd src/ && ./all.bash
}

install_linux_extra() {
  $S apt-get update
  $S apt-get upgrade -y
  $S apt-get dist-upgrade -y
  $S dpkg --set-selections < $CONFIG_FILES_DIR/dpkg-selections
  $S apt-get autoclean -y
  $S apt-get autoremove -y

  install_program cantera-wm
  install_program cantera-term
  install_program cantera-lock

  install_go
}

create_directories() {
  echo "Will try to create default directories."
  mkdir -p $GITHUB_ME
  for d in `cat directories`; do
    echo mkdir -p $HOME/$d
  done
}

copy_config_files() {
  echo "Creating default directories."

  echo "Placing configuration files."

  cp $CONFIG_FILES_DIR/ssh/config $HOME/.ssh/config
  cp $CONFIG_FILES_DIR/cantera/config $HOME/.cantera/

  cp $CONFIG_FILES_DIR/mutt/muttrc $HOME/.muttrc
  cp -r $CONFIG_FILES_DIR/mutt/mutt/* $HOME/.mutt/
  cp -r $CONFIG_FILES_DIR/mutt/mutt_files/* $HOME/.mutt_files/

  cp $CONFIG_FILES_DIR/db/psqlrc $HOME/.psqlrc

  cp $CONFIG_FILES_DIR/term/aliases $HOME/.term/.aliases
  cp $CONFIG_FILES_DIR/term/funcs $HOME/.term/.funcs
  cp $CONFIG_FILES_DIR/term/env $HOME/.term/.env

  cp $CONFIG_FILES_DIR/git/gitconfig $HOME/.gitconfig
  cp $CONFIG_FILES_DIR/git/git-completion.bash $HOME/.git-completion.bash

  cp $CONFIG_FILES_DIR/term/bashrc $HOME/.bashrc
  cp $CONFIG_FILES_DIR/term/lintianrc $HOME/.lintianrc

  cp $CONFIG_FILES_DIR/vim/vimrc $HOME/.vimrc

  cp $CONFIG_FILES_DIR/X/xbindkeysrc $HOME/.xbindkeysrc
  cp $CONFIG_FILES_DIR/X/xsession $HOME/.xsession
  cp $CONFIG_FILES_DIR/X/Xdefaults $HOME/.Xdefaults
  cp $CONFIG_FILES_DIR/X/Xmodmap $HOME/.Xmodmap
  cp $CONFIG_FILES_DIR/X/Xresources $HOME/.Xresources

  cd $GITHUB_ME
  gicp Vundle.vim
  cd $GITHUB_ME
  gicp liquidprompt

  cp $CONFIG_FILES_DIR/gnupg/gpg.conf $HOME/.gnupg/
  echo "Done."
}

install_stuff() {
  if [[ $1 == *setup* ]]; then
    unamestr=`uname`
    install_linux_extra $1
    if [ ! -d "$HOME/.ssh" ]; then
      ssh-keygen -t rsa -C "alexander@alemayhu.com"
    fi
  fi
}

main() {
  if [ ! -d "$GITHUB_ME" ]; then
    cd $GITHUB_ME
    git clone https://github.com/scanf/config-files
    cd config-files
  fi

  create_directories
  install_stuff $1
  copy_config_files
}

main $1
