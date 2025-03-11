# nixos

## Get Started

- Clone this repo
- `sudo nixos-rebuild switch --flake .#nameofsystem` to initialize everything
- Log in with github (`gh auth login`)
- Clone your dot files and run `stow -vt ~ *`
- In nvim, for github copilot, run `:Copilot auth`
- If you have ssh keys, add them and `ssh-add`

## TODO

-[ ] Document all packages -[ ] Readme documentation in case anyone is crazy enough to want to use my stuff -[ ] Move to home-manager
[ ] nvim config
[ ] ZSH config -[ ] Move MacOS brew packages to nix -[ ] Add in server profiles
