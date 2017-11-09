#!/bin/bash

install_homebrew () {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
