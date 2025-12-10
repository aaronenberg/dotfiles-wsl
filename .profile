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

if [ -f ~/.secrets ]; then
    . ~/.secrets
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "/usr/local/go/bin" ]; then
    PATH="/usr/local/go/bin:$PATH"
fi

PATH="/mnt/c/Windows/System32/inetsrv:/mnt/c/Users/aaronenberg/workspace/tools:/mnt/c/Program Files/Microsoft Visual Studio/2022/Enterprise/MSBuild/Current/Bin:/mnt/c/Program Files/Microsoft Visual Studio/2022/Enterprise/Common7/IDE:${HOME}/.msrustup/bin:$PATH"

test -f ~/.git-completion.bash && . $_ 

export wh="$USERPROFILE"
export oc="$wh/projects/OneCert"
export pkir="$wh/projects/Cauldron"
export lx="$wh/projects/Identity-LX"
export ocalt="$wh/projects/OneCert-alt"
export ts="$wh/projects/Secrets-SDP-TriggerService"
export tss="$ts/src/service/PilotFish/TriggerService/TriggerService.Synthetics"
export rcv="$wh/projects/security-RCV-Agent-Linux"

export MYVIMRC="$wh/vimfiles/.vimrc"
export VIMINIT="source $MYVIMRC"

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# rust cross-compile ARM64
export CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++
export CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc
export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc

export DOTNET_CLI_TELEMETRY_OPTOUT=1

if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi


if [ -f "$HOME/.rye/env" ]; then
    . "$HOME/.rye/env"
fi
