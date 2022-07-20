#!/bin/bash

# Setup a FRESH, just out of the shop, macOS dev station

# Xcode
# xcode-select --install

install_homebrew () {
  # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  # it stops at confirmation for xocde command line tools..
  # figure out a way to say yes to it without interrupting the script

  # doesn't look like there is an easy way of automating the Xcode install. 

  # Do that manually and then run this script

  # even after installing xcode tools..
  # will ask for password, and will ask for Enter
}

install_casks () {

  # Browsers
  brew cask install chrome opera

  # Code Editors
  brew cask install visual-studio-code sublime-text

  # Dev Tools
  brew cask install iterm2 ngrok
}


install_homebrew
install_casks


alfred
vs code
tmux
oh-my-zsh