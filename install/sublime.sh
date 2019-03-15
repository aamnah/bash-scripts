#!/bin/bash

###################################################################
#         Author: Aamnah Akram
#           Link: http://github.com/aamnah/bash-scripts
#    Description: Install Sublime Text and Sublime Merge on Debian Ubuntu
###################################################################

add_sublime_repo () {
	echo -e "\n\n  Installing SublimeHQ Repo .. "

	# Install the GPG key:
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

	# Ensure apt is set up to work with https sources:
	sudo apt-get install apt-transport-https

	# Select the channel to use:
	
	## Stable
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	
	## Dev
	# echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

	# Update apt sources and install Sublime Merge
	sudo apt-get update
}

install_sublime_text () {
	echo -e "\n\n  Installing Sublime Text .. "
	sudo apt-get install sublime-text

	# Install `libgtk` for Sublime to work on 18.10
	# otherwise it just doesn't open
	sudo apt install -y libgtk2.0-0
  
	# 'subl' command comes already in place, no need to edit $PATH
}

install_sublime_merge () {
	echo -e "\n\n  Installing Sublime Merge .. "
	sudo apt-get install sublime-merge
}

add_sublime_repo
install_sublime_text
install_sublime_merge

echo -e "\n  DONE \n "


# LINKS
# https://www.sublimemerge.com/docs/linux_repositories
# https://www.sublimetext.com/docs/3/linux_repositories.html

# Recommended Packages
# 1. Markdown Extended (for language-specific syntax highlighting inside fenced code blocks)