Bash Scripts
---

Misc. bash scripts that i write mostly for fun. These are written for good practice for things i occassionally need to do that involve multiple steps.

All install scripts begin with a `install_` in the file name.

### install_todotxt.sh
Installs [todo.txt](http://todotxt.com/) - a minimal command line based todo application - in the default Dropbox folder on a Mac. Also configures the recommended [tweaks](https://github.com/ginatrapani/todo.txt-cli/wiki/Tips-and-Tricks). 

The tweaks are:

- Sets alias `t`
- Sets command auto-completion
- Sets $PATH 
- Sets default `t` action (TODOTXT_DEFAULT_ACTION)
- Sets output by priority and then number (TODOTXT_SORT_COMMAND)

The install location is: ~/Dropbox/todo

requires: `wget`