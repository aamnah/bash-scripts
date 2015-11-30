#!/bin/bash

folder_name='todo'
folder_path=$HOME/${folder_name}

mkdir ${folder_path} && cd ${folder_path}
wget https://github.com/ginatrapani/todo.txt-cli/archive/master.zip # Download
unzip master.zip # Extract
mv todo.txt-cli-master/* . # Move extracted files
rm -rf master.zip LICENSE GEN-VERSION-FILE CONTRIBUTING.md Makefile README.textile tests/ todo.txt-cli-master # delete unnecessary files
chmod +x todo.sh # make executable

# add tweaks to .bash_prfile
echo -e "
### todo.txt
PATH=$PATH:\"${folder_path}" #path
alias t='${folder_path}todo.sh -d ${folder_path}todo.cfg #alias'
source ${folder_path}todo_completion #auto-completion
complete -F _todo t #auto-completion for alias
export TODOTXT_DEFAULT_ACTION=ls #default action 
export TODOTXT_SORT_COMMAND='env LC_COLLATE=C sort -k 2,2 -k 1,1n' #sort by priority, then by number 
" >> ~/.bash_profile
