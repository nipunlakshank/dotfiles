#!/usr/bin/env bash

config=${1:-$(scutil --get LocalHostName)}

printf "\33[92mStep 1 --> Installing Homebrew... \33[0m\n"
if command -v brew &> /dev/null; then
    echo "Homebrew is already installed: $(brew --version)"
else
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash
fi


printf "\n\33[92mStep 2 --> Installing nix... \33[0m\n"
if [ "$(find /nix -mindepth 1 -print -quit 2> /dev/null)" ]; then
    echo "Nix is already installed"
else
    sh <(curl -L https://nixos.org/nix/install)
fi

printf "\n\33[92mStep 3 --> Installing nix-darwin... \33[0m\n"
if command -v darwin-rebuild &> /dev/null; then
    echo "nix-darwin is already installed. Rebuilding flake for configuration: ${config}..."
    darwin-rebuild switch --flake ~/dotfiles/nix-darwin#${config}
else
    echo "Building nix-darwin flake for configuration: ${config}..."
    /nix/var/nix/profiles/default/bin/nix run nix-darwin -- switch --flake ~/dotfiles/nix-darwin#${config}
fi

