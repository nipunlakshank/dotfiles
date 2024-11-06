#!/usr/bin/env bash

config=${1:-$(scutil --get LocalHostName)}

printf "\33[92mStep 1 --> Installing Homebrew... \33[0m\n"
if command -v brew &>/dev/null; then
    echo "Homebrew is already installed: $(brew --version)"
else
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash
fi

printf "\n\33[92mStep 2 --> Installing nix... \33[0m\n"
if [ "$(find /nix -mindepth 1 -print -quit 2>/dev/null)" ]; then
    echo "Nix is already installed"
else
    sh <(curl -L https://nixos.org/nix/install)
fi

printf "\n\33[92mStep 3 --> Installing nix-darwin... \33[0m\n"
if command -v darwin-rebuild &>/dev/null; then
    echo "nix-darwin is already installed. Rebuilding flake for configuration: ${config}..."
    darwin-rebuild switch --flake ~/dotfiles/nix/darwin#"${config}" --impure
else
    echo "Building nix-darwin flake for configuration: ${config}..."
    /nix/var/nix/profiles/default/bin/nix run nix/darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/nix/darwin#"${config}" --impure
fi

printf "\n\33[92mStep 4 --> Installing oh-my-zsh... \33[0m\n"
if command -v omz &>/dev/null; then
    echo "oh-my-zsh is already installed."
else
    URL_PRIMARY='https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
    URL_FALLBACK='https://install.ohmyz.sh'

    export ZSH="${XDG_DATA_HOME:-$HOME/dotfiles}/ohmyzsh"
    export KEEP_ZSHRC=yes
    export ZSH_CUSTOM="$ZSH"/custom

    if [ "$(find "${ZSH}" -mindepth 1 -print -quit 2>/dev/null)" ]; then
        echo "${ZSH} is already exists"
    else
        (! sh -c "$(curl -fsSL --connect-timeout 5 --max-time 10 "$URL_PRIMARY")" "" --unattended &&
            sh -c "$(curl -fsSL --connect-timeout 5 --max-time 10 "$URL_FALLBACK")" "" --unattended)
    fi

    echo "Installing plugins..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM"/plugins/zsh-autosuggestions 2>/dev/null
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM"/plugins/zsh-syntax-highlighting 2>/dev/null
    printf "\n\33[92mDone.\33[0m\n"
fi
