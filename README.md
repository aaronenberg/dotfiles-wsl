WSL development environment setup

- Install WSL

- Install git with [git credential manager (standalone)](https://github.com/GitCredentialManager/git-credential-manager/releases/latest):

- Clone this repo to the user's home directory
```bash
git init -b main
git remote add origin https://github.com/aaronenberg/dotfiles-wsl.git
git fetch
git reset origin/main # Required when the versioned files existed in path before "git init" of this repo.
git reset --hard HEAD
git branch --set-upstream-to origin/main
```

```bash
# These settings will be done by installing the repo locally, but leaving here for reference
git config --global credential.helper "$(wslpath "$(cmd.exe /c echo %LocalAppData%\\Programs\\Git Credential Manager\\git-credential-manager-core.exe 2>/dev/null)" | sed -e 's/\r//g' -e 's/ /\\ /g')"
echo 'export GIT_EXEC_PATH="$(git --exec-path)"' >> ~/.bashrc
echo 'export WSLENV=$WSLENV:GIT_EXEC_PATH/wp' >> ~/.bashrc
```

- Copy files to Windows filesystem

- Update submodules
```bash
git submodule update --init --recursive
```

- If you get an error like:
    error: chmod on .git/config.lock failed: Operation not permitted
    fatal: could not set 'core.filemode' to 'false'
    
    - edit /etc/wsl.conf. Add the following:
    ```
    [automount]
    options = "metadata"
    ```


X11 window behavior
- Enable focus window on hover
    - Open Control panel => ease of access => Change how the mouse works => activate a window by hovering over it

- Disable raise window on focus:
    - Open registry, go to `hkcu\control panel\desktop\UserPreferencesMask`, subtract 0x40 from the first hex value
    
- make focus on hover faster:
    - open registry, go to `hkcu\control panel\desktop\ActiveWndTrkTimeout`, set it to 250.
    - Need to sign out and sign back in for this change to take effect.
