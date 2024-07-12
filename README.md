# dotfiles-wsl

## Windows Setup

If disabling Exploit Protection, WSL depends on Hyper-V to create VMs and this
requires **Control Flow Guard (CFG)** protection enabled. 

- Check in *Windows Security -> App & Browser Control -> Exploit Protection
  Settings*
  - Open Program settings
  - Add program to customize: `C:\Windows\System32\vmcompute.exe`
  - Under *Control flow guard (CFG)*, check **Override system settings** and turn
    it **On**

- Install [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

- Set `WSLENV` in Windows user environment variables:

    ```sh
    USERPROFILE/p
    ```

### X11 window behavior

- Enable focus window on hover
    - Open Control panel => ease of access => Change how the mouse works => activate a window by hovering over it

- Disable raise window on focus:
    - Open registry, go to `hkcu\control panel\desktop\UserPreferencesMask`, subtract 0x40 from the first hex value
    
- make focus on hover faster:
    - open registry, go to `hkcu\control panel\desktop\ActiveWndTrkTimeout`, set it to 250.
    - Need to sign out and sign back in for this change to take effect.

## WSL Setup

- Install [git credential manager (standalone)](https://github.com/GitCredentialManager/git-credential-manager/releases/latest):

- Clone this repo to the user's home directory

    ```bash
    git init -b main
    git remote add origin https://github.com/aaronenberg/dotfiles-wsl.git
    git fetch
    git reset origin/main # Required when the versioned files existed in path before "git init" of this repo.
    git reset --hard HEAD
    git branch --set-upstream-to origin/main
    ```

- Copy [.dotfiles/win](.dotfiles/win) contents to Windows filesystem

- Update submodules

    ```bash
    git submodule update --init --recursive
    ```
