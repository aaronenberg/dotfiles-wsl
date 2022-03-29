WSL 2 development environment setup

- install WSL

- install git with [git credential manager (standalone)](https://github.com/GitCredentialManager/git-credential-manager/releases/latest):

```bash
git config --global credential.helper "$(wslpath "$(cmd.exe /c echo %LocalAppData%\\Programs\\Git Credential Manager\\git-credential-manager-core.exe 2>/dev/null)" | sed -e 's/\r//g' -e 's/ /\\ /g')"
echo 'export GIT_EXEC_PATH="$(git --exec-path)"' >> ~/.bashrc
echo 'export WSLENV=$WSLENV:GIT_EXEC_PATH/wp' >> ~/.bashrc
```

- Copy files to Windows filesystem
```
mkdir $wh/vimfiles
cp .vim/.vimrc $wh/vimfiles
```

- Update submodules
```
git submodule update --init --recursive
```

- install Windows Terminal

    - In Windows Terminal settings.json comment out the bindings for ctrl-v, ctrl-c. They conflict with vim bindings.

- If you get an error like:
    error: chmod on .git/config.lock failed: Operation not permitted
    fatal: could not set 'core.filemode' to 'false'
    
    - edit /etc/wsl.conf. Add the following:
    '''
    [automount]
    options = "metadata"
    '''


X11 window behavior
- Enable focus window on hover
    - Open Control panel => ease of access => Change how the mouse works => activate a window by hovering over it

- Disable raise window on focus:
    - Open registry, go to `hkcu\control panel\desktop\UserPreferencesMask`, subtract 40 from first hex value
    
- make focus on hover faster:
    - open registry, go to `hkcu\control panel\desktop\ActiveWndTrkTimeout`, set it to 150.
