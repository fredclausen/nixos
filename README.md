# nixos

![Hyprland](hyprland.png "NixOS with Hyprland")

## What is this?

My personal NixOS configuration. It uses home manager to manage user package configuration. However, I have some systems (like MacOS) that are not running NixOS, so for programs that are common I have NixOS import the configuration for those apps directly from a common dot file in this repo.

## Jumping in point

The `flake.nix` is the jumping in point for the configuration. It has a few systems defined:

| System Name | Description                   | "Profile"                              |
| ----------- | ----------------------------- | -------------------------------------- |
| Nebula      | My personal laptop            | Desktop + Extra Packages + Development |
| Maranello   | Home Workstation              | Desktop + Extra Packages + Development |
| VM          | A virtual machine for testing | Desktop + Development                  |

- note: the desktop stuff in the packages directory is enabled for all systems right now. However, once I add in servers the option to configure it will make sense.

## Do you want to use this?

It's a good starting point for your nix journey, but see [Caveats](#caveats). If you want to use this, follow the steps below:

1. Install NixOs using a graphical installer. I suggest gnome.
2. Clone this repo to your home directory.
3. Remove all system configs from `flake.nix` except `maranello`
4. Rename the system to your system name
5. Rename the `system/maranello` directory to `system/<system name>`
6. Copy your `/etc/nixos/hardware-configuration.nix` to `system/<system name>/hardware-configuration.nix`
7. Search the code base for `fred` and replace it with your username
8. If you also replace any pathing to dot files, make sure you rename `dotfiles/fred` to `dotfiles/<your username>`
9. In `system/configuration.nix` replace `maranello` with your system name
10. In the cloned directory, run `sudo nixos-rebuild switch --flake .#<system name>`
11. (optional, if you use github) Log in with github (`gh auth login`)
12. (optional), if you have special dot files, clone them and run `stow -vt ~ *`
13. (optional) If you have ssh keys, add them to `~/.ssh` and `ssh-add`
14. (optional) to make VS code work correctly add:

    ```json
    "password-store": "gnome"
    ```

    to your `~/.vscode/argv.json`

15. (optional) In nvim, for github copilot, run `:Copilot auth`

In your `system/<system name>/configuration.nix` the following options can be set:

| Option               | Description                                                                                                            | Default |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------- |
| desktop.enable       | Enable desktop environment                                                                                             | false   |
| desktop.enable_extra | Enable extra packages. These are gated because on my VM there are a handful of packages that will not work on aarch64. | false   |

## Caveats

> [!WARNING]
> There are a few non-nixy things here. For instance, development packages are installed system wide. This is done to make lazygit work, as well as a few other random things that needed access to system development packages.

## Provided Packages

This is an incomplete list, but here are some of the packages that are provided:

### Graphical Environments

- Gnome
- hyprland

#### Hyprland

- fuzzel
- waybar

### Graphical Applications

#### Browsers

- Firefox
- Brave

#### Terminals

- Alacritty
- Ghostty (default)
- Wezterm

#### Editors

- Neovim
- VS Code
- Sublime Text

#### Shells

- Bash
- ZSH (default)

#### Shell Utilities and Programs

- bat
- eza
- fastfetch
- fd
- fzf
- gnupg
- lazygit
- oh-my-zsh
- starship
- yazi
- zoxide

## TODO

- [ ] Document all packages
- [ ] Readme documentation in case anyone is crazy enough to want to use my stuff
- [x] Move to home-manager
  - [x] nvim config
  - [x] ZSH config
- [ ] Move MacOS brew packages to nix
- [ ] Add in server profiles
