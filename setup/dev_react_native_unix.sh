#!/bin/bash

# React Native Dev environment setup

# Author: Aamnah <sudolearndev@gmail.com>
# Lastmod: 2022-07-20
# Status: Needs testing

JDK_VERSION=18
NVM_VERSION=0.39.1


abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

# Check OS
OS=$(uname) # Darwin means macOS, Linux means Ubuntu
if [[ "${OS}" == "Linux" ]]
then
  SETUP_ON_LINUX=1
elif [[ "${OS}" != "Darwin" ]]
then
  abort "This scripts only works on Unix systems (macOS/Ubuntu)"
fi

# Determine shell profile
# Check for ~/.zprofile, ~/.zshrc, ~/.bash_profile, ~/.bashrc
if [[ -f "${HOME}/.zprofile" ]]; then
  SHELL_PROFILE="${HOME}/.zprofile"
elif [[  -f "${HOME}/.zshrc" ]]; then 
  SHELL_PROFILE="${HOME}/.zshrc" 
elif [[  -f "${HOME}/.bash_profile" ]]; then
  SHELL_PROFILE="${HOME}/.bash_profile" 
else
  SHELL_PROFILE="${HOME}/.bashrc"
fi


install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo -e "\n Homebrew version $(brew --version) installed"
}

insatll_watchman() {
  # make sure Homebrew is installed first
  brew install watchman
  echo -e "\n Watchman version $(watchman --version) installed"
}

install_cocoapods() {
  # only run this on macOS
  brew install cocoapods
  echo -e "\n Cocoapods version $(pod --version) installed"
}


install_node_nvm() {
  # Node (with NVM) - to run JavaScript from terminal
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash

  echo '
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  ' >> ${SHELL_PROFILE}

  source ${SHELL_PROFILE}

  nvm install --lts
  nvm alias default node

  echo -e "\n Node version $(node --version) installed"
}


install_jdk() {
  if [[ -z "${SETUP_ON_LINUX}" ]]; then
    brew install openjdk@${JDK_VERSION}
    echo -e "\nexport JAVA_HOME=`/usr/libexec/java_home -v${JDK_VERSION}`" >> ${SHELL_PROFILE}
  else
    sudo apt install -y openjdk-${JDK_VERSION}-jdk
    sudo update-java-alternatives --set /usr/lib/jvm/java-1.${JDK_VERSION}.0-openjdk-amd64
    echo -e "\nexport JAVA_HOME='/usr/lib/jvm/java-1.${JDK_VERSION}.0-openjdk-amd64' " >> ${SHELL_PROFILE}
    echo "\nexport PATH=$PATH:$JAVA_HOME/bin" >> ${SHELL_PROFILE}
  fi

  source ${SHELL_PROFILE}
  echo -e "\n Java version $(java --version) installed"
}


install_homebrew
insatll_watchman
install_node_nvm
install_jdk

# macOS only installs
if [[ -z "${SETUP_ON_LINUX-}" ]]; then
  install_cocoapods
fi

# NOTES
# if -z return true if strintg is null