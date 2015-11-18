Bash Scripts
---

Misc. bash scripts that i write mostly for fun. These are written for good practice, for tasks i occassionally need to do that involve multiple steps.

All **install scripts** begin with a `install_` in the file name.

### install_todotxt.sh
Installs [todo.txt](http://todotxt.com/) - a minimal command line based todo application - in the default Dropbox folder on a Mac. Also configures the recommended [tweaks](https://github.com/ginatrapani/todo.txt-cli/wiki/Tips-and-Tricks). 

The tweaks are:

- Sets alias `t`
- Sets command and alias auto-completion
- Sets `$PATH`
- Sets default action `TODOTXT_DEFAULT_ACTION`
- Sets output by priority and then number `TODOTXT_SORT_COMMAND`

The install location is: ~/Dropbox/todo

Requires: `wget`

Execute script remotely:

	curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install_todotxt.sh | bash -s

### install_todotxt_debian.sh

Same as `install_todotxt.sh`, just different install directory. Uses a `folder_name` variable that can be customized by editing the script.

run:

	curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install_todotxt_debian.sh | bash -s

The default install location is: /root/todo
