# *********** Add your custom aliases here ***********
# For a full list of active aliases, run `alias`.

alias sudo='sudo ' # to use sudo with aliases
alias cd='z'

# colorls map
alias ls='colorls'
alias lsa='colorls -A'
alias ll='colorls -lh'
alias lA='colorls -lAh'
alias la='colorls -lah'

# XDG directories
alias config='cd ${XDG_CONFIG_HOME} && lsa'
alias cache='cd ${XDG_CACHE_HOME} && lsa'
alias state='cd ${XDG_STATE_HOME} && lsa'
alias data='cd ${XDG_DATA_HOME} && lsa'
alias bin='cd ${XDG_BIN_HOME} && lsa'

# Database shortcuts
alias db='mysql --version'
alias db-start='brew services start mysql'
alias db-stop='brew services stop mysql'
alias db-restart='brew services restart mysql'
alias db-status='sudo mysql.server status'
alias db-connect='mycli -u root'

# Edit files
alias aliases='${EDITOR} ${DOTFILES}/zsh/include/aliases.zsh'
alias flake='${EDITOR} ${DOTFILES}/nix/darwin/flake.nix'
alias home='${EDITOR} ${DOTFILES}/nix/darwin/home.nix'
alias customvar='${EDITOR} ${XDG_DATA_HOME}/oh-my-zsh/custom/customvar.zsh'
alias vimrc='${EDITOR} ${DOTFILES}/vim/.vim/vimrc'
alias ideavimrc='${EDITOR} ${XDG_CONFIG_HOME}/ideavim/ideavimrc'
alias zshenv='${EDITOR} ${DOTFILES}/zsh/.zshenv'
alias zshrc='${EDITOR} ${DOTFILES}/zsh/.zshrc'
alias zprofile='${EDITOR} ${DOTFILES}/zsh/.zprofile'
alias zlogin='${EDITOR} ${DOTFILES}/zsh/.zlogin'
alias httpdconfig='${EDITOR} /opt/homebrew/etc/httpd'
alias sshconfig='${EDITOR} ~/.ssh/config'
alias pmaconfig='${EDITOR} /opt/homebrew/etc/phpmyadmin.config.inc.php'
alias nvimconfig='${EDITOR} ${DOTFILES}/neovim/nvim/'
alias mamp_apache_conf='${EDITOR} /Applications/MAMP/conf/apache/'
alias mamp_nginx_conf='${EDITOR} /Applications/MAMP/conf/nginx/'
alias phpini='${EDITOR} /opt/homebrew/etc/php/8.3/php.ini'
alias vhosts='${EDITOR} /opt/homebrew/etc/httpd/extra/httpd-vhosts.conf'
alias hosts='${EDITOR} /etc/hosts'
alias tmuxconf='${EDITOR} ${DOTFILES}/tmux/tmux.conf'
alias myclirc='${EDITOR} ${DOTFILES}/mycli/myclirc'
alias gitconfig='${EDITOR} ${DOTFILES}/git/config'
alias kittyconfig='${EDITOR} ${DOTFILES}/kitty/kitty.conf'
alias promptconfig='${EDITOR} ${DOTFILES}/starship/starship.toml'

# General aliases
alias drb='darwin-rebuild switch --flake ~/dotfiles/nix/darwin#air --impure'
alias hrb='home-manager switch -f ~/dotfiles/nix/darwin/home.nix --extra-experimental-features flakes'
alias refresh='reload'
alias dots='mkdir -p ~/dotfiles && cd "$_" && lsa'
alias zdot='cd ${DOTFILES}/zsh && lsa'
alias dotrepo='/usr/bin/git --git-dir=${HOME}/.dotfiles --work-tree=${HOME}'
alias pmathemes='cd /opt/homebrew/Cellar/phpmyadmin/5.2.1/share/phpmyadmin/themes'
alias python=python3
alias diskinfo='sudo smartctl --all /dev/disk0'
alias htdocs='cd /Applications/XAMPP/xamppfiles/htdocs'
alias sites='mkdir -p ~/dev/Sites && cd "$_" && ls'
alias www=sites
# alias www='mkdir -p ~/dev/www && cd "$_" && ls && print "\n\33[31mDocument root moved to \33[3m~/dev/Sites\33[23m\33[0m"'
alias rn='cd ~/dev/ReactNative && ls'
alias dev='mkdir -p ~/dev && cd "$_" && ls'
alias tmp='mkdir -p ~/dev/tmp && cd "$_" && ls'
alias httpddir='cd /opt/homebrew/etc/httpd && ls'
alias termux='ssh -p 8022 ${USER_TERMUX}@${IP_TERMUX}'
# alias jdks='/usr/libexec/java_home -V'
alias q='osascript -e "tell application \"System Events\" to keystroke \"q\" using command down"'
alias pa='php artisan'
alias signin-report='./gradlew signinReport'
alias v='vim'
alias nv='nvim'
alias httpd_start='brew services start httpd'
alias httpd_stop='brew services stop httpd'
alias wget=wget --hsts-file='${XDG_DATA_HOME}/wget-hsts'
alias fman='compgen -c | fzf | xargs man'
alias nvf='nvim $(fd | fzf --prompt=" Select file or directory  " --height=~80% --layout=reverse --border --exit-0)'
alias nvsf='nvs $(fd | fzf --prompt=" Select file or directory  " --height=~80% --layout=reverse --border --exit-0)'
alias path='line_format ${PATH} :'
alias oil='nvim -c "Oil"'
alias mx='ssh_connect --user nipun --file ${XDG_CONFIG_HOME}/ssh_connect/servers/antix.txt'
alias lg='lazygit'

alias ipinfo='curl --silent ipinfo.io | jq'
alias ip.pub='echo $(curl ipinfo.io/ip --silent) | lolcat'

# tmux
alias ta='tmux attach'
alias tn='tmux'
alias td='tmux detach'
alias tx='tmux kill-server'

alias nvrtp='nvim -c "set rtp+=./"'
alias nvg='nvim -c "Git" -c "only"'
