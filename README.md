Bash Scripts
---

Misc. bash scripts that i write mostly for fun. These are written for good practice, for tasks i occassionally need to do that involve multiple steps.

Scripts in the `install/` directory are for installing stuff, obviously.

### create_virtualhost.sh
Creates a virtual host file. The script can take one or more argument in the form of domain name, like `mydomain.com`.
e.g:

```bash
bash create_virtualhost.sh domain1.com domain2.com domain3.com
```

For every domain, the script:
- creates directory structure
- grants permissions
- creates demo `index.html` for virtual host 
- creates new virtual host file
- enables the new virtual host file

The script also restarts Apache after all domains are set up.

Execute remotely: 

```bash
curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/create_virtualhost.sh | bash -s mydomain.com
```

Notes: 
- The `PHPINIDir` directive in the virtual host conf file  will give an Apache config test failed error if PHP is not installed on the system. Either install PHP (why not?) or remove the directive.
- Sets the directory ownership for the user who ran the script 

### install/amp_debian.sh

Install Apache, MySQL, PHP and phpMyAdmin

- requires no user input
- sets a MySQL password and shows in console
- does not overwrite the MySQL password if it is already set

```bash
curl https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/amp_debian.sh | bash
```


### install/flask.sh
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

To run, simply do `bash flask.sh`. To run remotely:

```bash
curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/flask.sh | bash
```

### install/froxlor_debian.sh
Installs [Froxlor](https://froxlor.org/) Server Management Panel.

What it does:
- adds Froxlor repo
- adds Froxlor approve key for packages
- updates system
- installs Froxlor
- sets directory permissions
- provides a link to continue with web install

Execute remotely: 

```bash
curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/froxlor_debian.sh | bash
```

Note: LAMP needs to be installed already

### install/imgcat.sh

[imgcat](https://www.iterm2.com/images.html) is a script that previews images and GIFs right in the Terminal. You can see a gif in the Terminal with `img foo.gif` or a jpeg with `img bar.jpg`..

- Sets alias `img`
- Adds to `$PATH`

To run, simply do `bash imgcat.sh`. To run remotely:

```bash
curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/imgcat.sh | bash
```

### install/nodejs.sh

Removes the pre-installed Node.js on Raspbery Pi (Raspbian Jessy) and installs the latest release. The script:

- Uninstalls `nodejs`, `nodejs-legacy`, `nodered` and `npm`
- Downloads latest release from Heroku servers
- Installs latest Node.js release for ARM computers (i.e. Raspberry Pi)
- Cleans up temporary install files and `autoremove`
- Confirms successful install and Node.js version

To run, simply do `bash nodejs.sh`. To run remotely:

```bash
curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/nodejs.sh | bash
```

### install/opencart.sh

NOTE: I stopped working with OpenCart years ago and haven't looked at this scrip in a very long time. May not work as expected anymore..

Installs any opencart version between 1.5.6 and 3.0.2.0 The script:

- Asks for a specific version to install
- Downloads and extracts the compressed files for that version from OpenCart's Github release archive
- renames the `.htaccess` file

To finish the installation, go to `/install` in your browser (http://yourdomain.com/install)

To run, simply do `bash opencart.sh`. To run remotely:

```bash
curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/opencart.sh | bash
```
### install/sublime.sh

- Adds Sublime HQ repo for both Sublime Text and Sublime Merge (it's the same repo for both)
- Installs [Sublime Text](https://www.sublimetext.com/)
- Installs [Sublime Merge](https://www.sublimemerge.com/)

```bash
curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/sublime.sh | bash
```

### install/todotxt.sh
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

```bash
curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/todotxt.sh | bash -s
```

### install/todotxt_debian.sh

Same as `install/todotxt.sh`, just different install directory. Uses a `folder_name` variable that can be customized by editing the script.

run:

```bash
curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/todotxt_debian.sh | bash -s
```

The default install location is: ~/todo

### install/webmin_debian.sh
Installs Webmin on Debian. Adds Webmin to `sources.list`, adds GPG key, updates apt and installs Webmin. Also adds a rule for Webmin in UFW.

```bash
curl -s https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/webmin_debian.sh | bash
```
