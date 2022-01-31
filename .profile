# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

test -f ~/.git-completion.bash && . $_ 

export wh="/mnt/c/Users/aaronenberg"
export oc="/mnt/c/Users/aaronenberg/projects/OneCert"

export MYVIMRC="$wh/vimfiles/.vimrc"
export VIMINIT="source $MYVIMRC"

export GIT_EXEC_PATH="$(git --exec-path)"
export WSLENV=$WSLENV:GIT_EXEC_PATH/wp
