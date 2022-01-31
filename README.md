WSL 2 development environment setup

- install WSL

- install git with git credential manager:

```
    git config --global credential.helper "$(wslpath "$(cmd.exe /c echo %LocalAppData%\\Programs\\Git Credential Manager\\git-credential-manager-core.exe 2>/dev/null)" | sed -e 's/\r//g' -e 's/ /\\ /g')"
    echo 'export GIT_EXEC_PATH="$(git --exec-path)"' >> ~/.bashrc
    echo 'export WSLENV=$WSLENV:GIT_EXEC_PATH/wp' >> ~/.bashrc
```

- install Windows Terminal

- In Windows Terminal settings.json comment out the bindings for ctrl-v ctrl-c. They conflict with vim bindings.

X11 window behavior

    - Enable focus window on hover:
    
        Open Control panel => ease of access => Change how the mouse works => activate a window by hovering over it
    
    - Disable raise window on focus:
        
        open registry, go to hkcu\control panel\desktop\UserPreferencesMask, subtract 40 from first hex value
    
    - make focus on hover faster:
        
        open registry, go to hkcu\control panel\desktop, set ActiveWndTrkTimeout to 150.
