# enable vim motions in shell
bindkey -v

# include custom configurations
for config_file ("$ZINCLUDE"/*.zsh(N)); do
  source "$config_file"
done
unset config_file


TERM_NAME="$(env | grep 'TERM_PROGRAM=' | awk -F'=' '{ print $2 }')"
if [ "$TERM_NAME" != "Apple_Terminal" ]; then
    type starship_zle-keymap-select >/dev/null || \
        {
            echo "Load starship"
            eval "$(/usr/local/bin/starship init zsh)"
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
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# export NVM_DIR="/Users/nipun/Library/Application Support/Herd/config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="${HOME}/Library/Application Support/Herd/config/php/83/"

# Zoxide
eval "$(zoxide init zsh)"

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# home-manager
# source /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

# Welcome message (keep this at bottom)
function welcome() {
    # cowsay "$(fortune -s)" | lolcat
    neofetch | lolcat
}

# welcome
