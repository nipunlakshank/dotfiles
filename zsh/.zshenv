# XDG BASE DIR Specification
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
export XDG_BIN_HOME=$HOME/.local/bin
export XDG_RUNTIME_DIR=/var/run

# Editor
# if [[ -z $SSH_CONNECTION ]]; then
# 	EDITOR='nvim'
# else
# 	EDITOR='vim'
# fi

# General
export EDITOR='nvim'
export LESS="-SRXF"
export PS_FORMAT="\nID\t{{.ID}}\nNAME\t{{.Names}}\nImage\t{{.Image}}\nPORTS\t{{.Ports}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.CreatedAt}}\nSTATUS\t{{.Status}}\n"
export DOTFILES=${HOME}/dotfiles

# nix
export NIX_CONF_DIR=${XDG_CONFIG_HOME}/nix

# Other programs
export LESSHISTFILE=$XDG_STATE_HOME/less/history
export MYCLI_HISTFILE=$XDG_DATA_HOME/mycli/history
export JAVA_HOME="$(/usr/libexec/java_home -v 17)"
export XAMPP_HOME=/Applications/XAMPP/xamppfiles
export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
export CARGO_HOME=$XDG_DATA_HOME/cargo
export DOTNET_CLI_HOME=$XDG_DATA_HOME/dotnet
export GLASSFISH_HOME=/opt/homebrew/opt/glassfish/libexec
export _Z_DATA="$XDG_DATA_HOME/z"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export GNUPGHOME=${XDG_DATA_HOME}/gnupg
export GPG_TTY="$(tty)"
export LG_CONFIG_FILE="${XDG_CONFIG_HOME}/lazygit/config.yml,${XDG_CONFIG_HOME}/lazygit/themes-mergable/mocha/peach.yml"
export ARDUINO_CLI_CONFIG_FILE="${XDG_CONFIG_HOME}/arduino-cli/arduino-cli.yaml"

export ANDROID_HOME=$XDG_DATA_HOME/android
export ANDROID_USER_HOME=$XDG_DATA_HOME/android
export ANDROID_EMULATOR_HOME=$ANDROID_USER_HOME
export ANDROID_AVD_HOME=$ANDROID_USER_HOME/avd
export GRADLE_USER_HOME=$XDG_DATA_HOME/gradle

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Set PATH
PATH="/opt/homebrew/opt/ruby/bin:$PATH"
PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
PATH=$PATH:$XDG_BIN_HOME
PATH=$PATH:$XAMPP_HOME/bin
PATH=$PATH:$ANDROID_HOME/emulator
PATH=$PATH:$ANDROID_HOME/platform-tools
PATH=$PATH:$JAVA_HOME/bin
PATH=$PATH:$HOME/.composer/vendor/bin
PATH=$PATH:/Applications/IntelliJ\ IDEA.app/Contents/MacOS
PATH=$PATH:/Applications/Barrier.app/Contents/MacOS
PATH=$PATH:$HOME/.docker/bin
PATH="$PATH:/Users/nipun/Library/Application Support/Herd/bin"
PATH="$PATH:/Users/nipun/Library/Application Support/JetBrains/Toolbox/scripts" # Added by Toolbox App
PATH="$PATH:/opt/homebrew/lib/ruby/gems/3.3.0/bin"

# Add any additional environment variables here
# export PATH=$PATH:$(dirname "$(find /nix/store -name home-manager -type f | grep bin)")

export PATH
