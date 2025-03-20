# Homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_BUNDLE_FILE=~/dotfiles/homebrew/Brewfile
# export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

# zsh
mkdir -p "${XDG_STATE_HOME}/zsh"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZINCLUDE="${ZDOTDIR}/include"
export ZAFTER="${ZDOTDIR}/after"
export HISTFILE="${XDG_STATE_HOME}/zsh/zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# include custom configurations
for config_file in "${ZINCLUDE}"/*.zsh(N); do
    source "$config_file"
done
unset config_file

TERM_NAME="$(env | grep 'TERM_PROGRAM=' | awk -F'=' '{ print $2 }')"
if [ "$TERM_NAME" != "Apple_Terminal" ]; then
    type starship_zle-keymap-select >/dev/null ||
        {
            eval "$(starship init zsh)"
        }
fi

# fzf
eval "$(fzf --zsh)"

# ngrok
if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
fi

# NVM
export NVM_DIR="$XDG_DATA_HOME/nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# export NVM_DIR="/Users/nipun/Library/Application Support/Herd/config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="${HOME}/Library/Application Support/Herd/config/php/83/"

# Zoxide
eval "$(zoxide init zsh)"

# home-manager
[[ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]] && source /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
[[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]] && source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

# Welcome message (keep this at bottom)
function sysfetch() {
    # cowsay "$(fortune -s)" | lolcat
    neofetch | lolcat
}

# load after configurations
for config_file in "${ZAFTER}"/*.zsh(N); do
    source "$config_file"
done
unset config_file

