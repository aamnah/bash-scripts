#!/bin/bash
# Author: Aamnah Akram
# URL: http://aamnah.com
# Email: hello@aamnah.com
# Description: Bash script to install Opencart
# Usage: You can use 'curl' to run this script directly from Github.
# curl -L https://raw.githubusercontent.com/aamnah/bash-scripts/master/install_opencart.sh | bash

# TODO
# [ ] File and folder permissions for install https://gist.github.com/aamnah/9cab2942f42d5fe7035d
# [ ] File and folder permissions post-install (secure) https://gist.github.com/aamnah/eff1c13f8b8d893c7c61
# [ ] Create the config files from script instead of going to http://domain.com/install and entering them
# [ ] Delete install folder when done

# COLORS
Cyan='\033[0;36m'         # Cyan
Green='\033[0;32m'        # Green
Red='\033[0;31m'          # Red
BCyan='\033[1;36m'        # Bold Cyan
Color_Off='\033[0m'       # Text Reset

  checkVersion() {
      # check if version provided is a valid OpenCart release
      version_list=("3.0.2.0" "3.0.1.2" "3.0.1.1" "3.0.0.0" "2.3.0.2" "2.3.0.1" "2.3.0.0" "2.2.0.0" "2.1.0.2" "2.1.0.1" "2.0.3.1" "2.0.2.0" "2.0.1.1" "2.0.1.0" "2.0.0.0" "1.5.6.4" "1.5.6.3" "1.5.6.2" "1.5.6.1" "1.5.6")

      match=0
      for v in "${version_list[@]}"
      do
        if [[ $v = "$VERSION" ]]; then
          match=1
          break
        fi
      done
    }

  # Ask for version
  echo -e "${Cyan} What version should i install? (for example: ${BCyan}1.5.6.4${Cyan} or ${BCyan}3.0.2.0${Cyan})${Color_Off}"
  read VERSION

  checkVersion

  if [[ $match = 0 ]]; then
    echo -e "${Red} Not a valid OpenCart version. Exiting.. ${Color_Off}"
    return 0
  fi

  if [[ $match = 1 ]]; then
    # Download files for that version from Github
    echo -e "${Cyan} Downloading files.. ${Color_Off}"
    wget -O opencart-$VERSION.zip https://github.com/opencart/opencart/archive/${VERSION}.tar.gz

    echo -e "${Cyan} Extracting.. ${Color_Off}"
    tar xzf opencart-$VERSION.zip

    echo -e "${Cyan} Cleaning up.. ${Color_Off}"
    mv opencart-$VERSION/* .
    rm -rf opencart-$VERSION.zip opencart-$VERSION
    mv upload/* .
    mv upload/.htaccess.txt ./.htaccess
    rmdir upload

    echo -e "${Green} Opencart was successfully copied. Please run the install script to finish installation. \n
            http://yourdomain.com/install \n ${Color_Off}"
    return 1
  fi
