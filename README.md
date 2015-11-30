Bash Scripts
---

Misc. bash scripts that i write mostly for fun. These are written for good practice, for tasks i occassionally need to do that involve multiple steps.

All **install scripts** begin with a `install_` in the file name.

### create_virtualhost.sh
Creates a virtual host file. The script takes one argument in the form of domain name, like `mydomain.com`.

What it does:
- creates directory structure
- grants permissions
- creates demo `index.html` for virtual host 
- creates new virtual host file
- enables the new virtual host file
- restarts apache

Execute remotely: 

	curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/create_virtualhost.sh | bash -s mydomain.com

### install_flask.sh
A rough script that takes care of all the steps in installing and setting up a Flask project. There are variables you can edit before running the script. At present, the script does the following:

- apt Update and Upgrade
- installs `apache2`
- installs and enables `libapache2-mod-wsgi`
- installs `pip`
- installs and activates `virtualenv`
- creates and enables `VirtualHost` file
- creates .wsgi script
- creates `__init__.py`
- restarts Apache

To run, simply do `bash install_flask.sh`. To run remotely:

	curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install_flask.sh | bash


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

The default install location is: ~/todo
