# NixOS Configuration Flake

![Hyprland](hyprland.png "NixOS with Hyprland")

## Overview

This repository contains **my personal NixOS configuration**, built
around:

- **Nix Flakes**
- **Home Manager**
- **Hyprland / GNOME**
- A shared set of dotfiles for both **NixOS** and **non-NixOS**
  machines (e.g., macOS)

It is designed primarily for my own systems, but it can serve as a
**reference or starting point** if you are building your own flake-based
NixOS setup.

## Systems Included

The main entry point is [`flake.nix`](./flake.nix).

It defines several host configurations:

| System Name   | Description      | Profile                                                    |
| ------------- | ---------------- | ---------------------------------------------------------- |
| **Daytona**   | Personal laptop  | Desktop + Extra Packages + Development                     |
| **Maranello** | Home workstation | Desktop + Extra Packages + Games + Streaming + Development |
| **acarshub**  | Server           | Server + Development                                       |
| **vdlmhub**   | Server           | Server + Development                                       |
| **hfdlhub-1** | Server           | Server + Development                                       |
| **hfdlhub-2** | Server           | Server + Development                                       |

## Using This Configuration (If You Really Want To)

This is mostly here for my own machines---but if you want to adopt it:

1. Install NixOS (graphical installer recommended --- GNOME works
   fine).
2. Clone this repo into your home directory.
3. In `flake.nix`, remove all systems except **maranello**.
4. Rename `maranello` to your desired hostname.
5. Rename `system/maranello` → `system/<your system name>`.
6. Copy your generated `/etc/nixos/hardware-configuration.nix` into
   that directory.
7. Change the `user`, `verbose_name`, and `github_username` fields in
   `flake.nix`.
8. Search for the username `fred` and replace with your own. See the note below.
9. Update dotfile paths (rename `dotfiles/fred` →
   `dotfiles/<your username>` if needed).
10. In your `system/<system>/configuration.nix`, replace `maranello`
    with your system name.
11. Build and switch:

```bash
sudo nixos-rebuild switch --flake .#<system name>
```

> [!IMPORTANT]
> `fred` as a username is still baked in in quite a few places, namely in the `dotfiles` directory. A lot of my custom scripts just have the `/home/fred` path hardcoded. You will need to change these to your own username or home directory path.
>
> Additionally, there are a few other files that have `fred` hardcoded in them. You will need to change these as well.

### Optional Post-Install Steps

- Authenticate GitHub:

  ```bash
  gh auth login
  ```

- Bring in any extra dotfiles:

  ```bash
  stow -vt ~ *
  ```

- Install SSH keys into `~/.ssh` and run `ssh-add`.

- Fix VS Code keyring integration by adding:

  ```json
  "password-store": "gnome"
  ```

  to `~/.vscode/argv.json`.

- In Neovim, authenticate GitHub Copilot:

```bash
      :Copilot auth
```

## Configurable Options

Each system's `configuration.nix` supports these options:

| Option                     | Description                                             | Default |
| -------------------------- | ------------------------------------------------------- | ------- |
| `desktop.enable`           | Enables the desktop environment                         | `false` |
| `desktop.enable_extra`     | Installs "extra" packages (some may fail on aarch64 VM) | `false` |
| `desktop.enable_games`     | Installs Steam and related gaming packages              | `false` |
| `desktop.enable_streaming` | Installs OBS and streaming-related packages             | `false` |

## Caveats

> \[!WARNING\] This is **not** a pure-Nix, perfectly-immutable setup.
>
> Some development tools are installed **system-wide** to make tools
> like `lazygit` work cleanly.\
> Several optional post-install steps are still **imperative**, and
> should ideally be baked into declarative modules in the future.
>
> Treat this as a functional starting point---not an example of strict
> Nix purity.

## Included Packages (Partial List)

### Graphical Environments

- GNOME
- Hyprland

#### Hyprland Tools

- fuzzel
- waybar

### Graphical Applications

#### Browsers

- Firefox
- Brave

#### Terminals

- Alacritty
- Ghostty
- WezTerm _(default)_

#### Editors

- Neovim
- VS Code
- Sublime Text

### Shells

- bash
- Zsh _(default)_

### CLI Tools

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
