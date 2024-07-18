# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

stty -ixon

command_not_found_handle()
{
    cmd=$1
    shift
    args=( "$@" )

    saveIFS="$IFS"
    IFS=:
    for dir in $PATH; do
       for executable in "$dir/$cmd.exe" "$dir/$cmd.com" "$dir/$cmd.bat"; do
          if [ -x $executable ]; then
             IFS="$saveIFS"
             "$executable" "${args[@]}"
             return
          fi
       done
    done

    IFS="$saveIFS"
    if [ -x /usr/lib/command-not-found ]; then
       /usr/lib/command-not-found -- "$cmd" "${args[@]}"
       return $?
    elif [ -x /usr/share/command-not-found/command-not-found ]; then
       /usr/share/command-not-found/command-not-found -- "$1" "${args[@]}"
       return $?
    else
        printf "%s: command not found\n" "$cmd" >&2
        return 127
    fi
}

# Clean OneCert solution
occ()
{
    pushd .
    cd $oc
    nc SharedConfiguration/appsettings.dev.json
    popd
}

# Clean a .NET solution
nc()
{
    any_untracked
    if [ $? -eq 0 ]; then
        echo "there are untracked files that need to be stashed or tracked"
        return 1
    fi

    tskill vbcscompiler 2>&1 > /dev/null
    tskill devenv 2>&1 > /dev/null
    tskill msbuild 2>&1 > /dev/null

    if [ -z "$1" ]; then
        git clean -xdf
    else
        git clean -xdf -e "$1"
    fi

# uncomment after testing when clean fails
# if clean fails with message "failed to remove"
# terminate w3wp.exe
# pid=$(tasklist /FI "IMAGENAME eq w3wp.exe" | tail -n1 | awk '{ print $2 }')
# echo $pid | grep -E '[0-9]{3,}'
# [ $? -eq 0 ] && tskill $pid
}

# Restore a .NET solution or project
nr()
{
    if [ -z "$1" ]; then
        echo "Argument empty: SOLUTION"
        return 1;
    fi

    pushd .
    cd "$(dirname "$(realpath "$1")")"
    nuget restore "$(basename $1)"
    popd
}

# Build a .NET Solution
nb()
{
    if [ -z "$1" ]; then
        echo "Argument empty: SOLUTION"
        return 1;
    fi

    pushd .
    cd "$(dirname "$(realpath "$1")")"
    msbuild "$(basename $1)"
    popd
}

tsrb()
{
    if [ -z "$1" ]; then
        echo "Argument empty: PATH_TO_REPO"
        return 1;
    fi

    pushd .
    cd $(realpath "$1")
    nc && \
    tsb "$1"
    popd
}

tsb()
{
    if [ -z "$1" ]; then
        echo "Argument empty: PATH_TO_REPO"
        return 1;
    fi

    pushd .
    cd $(realpath "$1")
    powershell -command 'msbuild -t:slngen -p:"SlnGenLaunchVisualStudio=false" -p:"Platform=x64"' && \
    # build is failing when run in bash
    powershell -command 'msbuild -p:"Platform=x64"'
    popd
}

# Rebuild OneCert Solution
ocrb()
{
    if [ -z "$1" ]; then
        echo "Argument empty: SOLUTION"
        return 1;
    fi

    nrb "$1" SharedConfiguration/appsettings.dev.json
}

# Rebuild a .NET Solution
nrb()
{
    if [ -z "$1" ]; then
        echo "Argument empty: SOLUTION"
        return 1;
    fi
 
    pushd .
    cd "$(dirname "$(realpath "$1")")"

    nc "$2"
    [ $? -ne 0 ] && return 1

    nuget restore "$(basename $1)"
    tasklist /fi "IMAGENAME eq devenv.exe" | grep devenv
    [ $? -ne 0 ] && nohup devenv.exe /nosplash "$(basename $1)" >/dev/null 2>&1 &
    msbuild "$(basename $1)"
    popd
}

restartoc()
{
    appcmd recycle apppool /apppool.name:"onecert-dev"
}

# Check a git repo for any untracked files
any_untracked()
{
    num_untracked=`git ls-files --other --directory --exclude-standard --no-empty-directory | sed q1 | wc -l`
    [[ $num_untracked -eq 0 ]] && return 1 || return 0;
}

tsstart()
{
    if [ -z "$1" ]; then
        echo "Argument empty: PATH_TO_REPO"
        return 1;
    fi

    if [ -z "$2" ]; then
        echo "Argument empty: build type: debug|retail"
        return 1;
    fi

    pushd .
    cd $(realpath "$1")/out/$2-amd64/TriggerService
    cmd.exe /C startdev.bat &
    popd
}

slngents()
{
    slngen --platform x64
}

gcm()
{
    gc master "$@" 2>/dev/null || gc main "$@"
}

gc()
{
    if [ -z "$1" ]; then
        echo "Argument empty: BRANCH_NAME"
        return 1;
    fi

    git branch | grep -E "^\*\s$1$" 2>&1 >/dev/null
    if [ $? -eq 0 ]; then
        echo "already on branch $1"
        return 0;
    fi

    git branch | grep -E "^\s\s$1$" 2>&1 >/dev/null
    if [ $? -ne 0 ]; then
        echo >&2 "$1 is not an existing branch"
        return 1;
    fi

    git checkout "$@"
}

gcb()
{
    if [ -z "$1" ]; then
        echo "Argument empty: BRANCH_NAME"
        return 1;
    fi

    git checkout -b "$1"
}

gcan()
{
    git commit --amend --no-edit
}

gp()
{
    git pull -p
}

pushd()
{
    command pushd "$@" > /dev/null
}

popd()
{
    command popd "$@" > /dev/null
}

adduntracked()
{
    echo -e "a\n*\nq\n" | git add -i
}

glfmt()
{
    git log --format=format:%B
}

dc()
{
    if [[ "$1" == "attach" ]]; then
        dcattach "${@:2}"
    elif [[ "$1" == "up" ]]; then
        devcontainer up --workspace-folder . "${@: 2}"
    else
        devcontainer "$@"
    fi
}

dcattach()
{
    local project_name
    if [[ -n "$1" ]]; then
        project_name="$1"
    else
        project_name="$(basename "$(pwd)")"
    fi

    local container_id
    container_id=$(docker container ls --no-trunc | grep -i "while sleep 1000" | grep -i "${project_name}" | awk '{ print $1 }')

    if [ -z "$container_id" ]; then
        echo "Failed to find a running devcontainer"
        return 1;
    fi

    # attach to the container and set REMOTE_CONTAINERS_IPC for git auth
    command docker exec -it \
        -e COLUMNS="`tput cols`" \
        -e LINES="`tput lines`" \
        -w "/workspace" \
        $container_id /usr/bin/env bash -c '
        export REMOTE_CONTAINERS_IPC=$(
            find /tmp -name '\''vscode-remote-containers-ipc*'\'' -type s -printf "%T@ %p\n" 2>/dev/null \
            | sort -n \
            | cut -d " " -f 2- \
            | tail -n 1)
        $SHELL'
}

retag()
{
    if [ -z "$1" ]; then
        echo "Argument empty: TAG_NAME"
        return 1;
    fi

    local tag_exists
    tag_exists=$(git tag -l | grep "$1")

    if [[ -z "${tag_exists}" ]]; then
        echo "Failed to find tag $1"
        return 1;
    fi

    git push -d origin "$1"
    git tag -d "$1"
    git fetch --tags
    git tag "$1"
    git push origin "$1"
}

notes()
{
    vim "${HOME}"/docs/notes
}

todo()
{
    vim "${HOME}"/docs/todo
}

git()
{
    WORK_DIR=$(pwd -P)
    if [[ "${WORK_DIR}" == /mnt/c/* ]]; then
        "/mnt/c/Program Files/Git/bin/git.exe" "$@"
    else
        command git "$@"
    fi
}

jaeger_run()
{
    docker run -d --rm --name jaeger \
        -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
        -p 6831:6831/udp \
        -p 6832:6832/udp \
        -p 5778:5778 \
        -p 16686:16686 \
        -p 4317:4317 \
        -p 4318:4318 \
        -p 14250:14250 \
        -p 14268:14268 \
        -p 14269:14269 \
        -p 9411:9411 \
        jaegertracing/all-in-one:latest
}

jaeger_stop()
{
    docker stop jaeger
}

azurite_run()
{
    docker run -d --rm --name azurite \
        -p 10000:10000 \
        -p 10001:10001 \
        -p 10002:10002 \
        mcr.microsoft.com/azure-storage/azurite
}

azurite_stop()
{
    docker stop azurite
}

cosmos_run()
{
    docker run -d --rm --name cosmos \
        -e AZURE_COSMOS_EMULATOR_IP_ADDRESS_OVERRIDE="127.0.0.1" \
        -p 8081:8081 \
        -p 10250-10255:10250-10255 \
        mcr.microsoft.com/cosmosdb/linux/azure-cosmos-emulator:latest
}

cosmos_stop()
{
    docker stop cosmos
}

stx()
{
    if [ -z "$1" ]; then
        echo "Argument empty: JOB_NAME"
        return 1;
    fi
    if [ -z "$1" ]; then
        echo "Argument empty: INSTANCE_NAME"
        return 1;
    fi

    local CAULDRON_PATH="C:/Users/aaronenberg/projects/Cauldron/src/Synthetics/Microsoft.Cauldron.Synthetics/bin/Debug/net6.0"

    RunSynthetics.exe -d \
        -r uswest \
        -a "${CAULDRON_PATH}" \
        -c "${CAULDRON_PATH}"/syntheticjobs.dev.json \
        -j "$1" \
        -i "$2"
}

cert_info()
{
    for crt in *.crt
    do
        openssl x509 -inform der -in "${crt}" -fingerprint -serial -noout | awk -F= '{ print $2 }' | tr -d : | xargs echo "${crt%.*}"
    done
}

map_cert_opreq()
{
    for crt in *.crt
    do
        if ! grep "${crt}" operationrequests*.json
        then
            echo help "${crt}";
        fi
    done
}

clone_gold_pe()
{
    clone_gold "$1" "1"
}

clone_gold()
{
    local dir="Azure-Gold-Config_sparse"
    rm -rf "${dir}"
    git clone --no-checkout --filter=tree:0 --depth=1 https://azureconfig@dev.azure.com/azureconfig/Gold/_git/Azure-Gold-Config "${dir}"
    pushd "${dir}"
    local pe_pattern=''
    if [ -n "$2" ]; then
        local pe_pattern='autopilotservice/*/AzurePKI*'
    fi
    git sparse-checkout set --no-cone '/*' '!/*/' .config .corext build guardian src tools autopilotservice/Global/VirtualEnvironments/CEG_AzureIdentity/AzurePKI_PPE autopilotservice/Global/VirtualEnvironments/CEG_AzureIdentity/AzurePKI_PROD "${pe_pattern}"
    git checkout
    if [ -n "$1" ]; then
        git checkout -b "$1"
    fi
    popd
}

apsign()
{
    apsigntool -a -g -d ame
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
