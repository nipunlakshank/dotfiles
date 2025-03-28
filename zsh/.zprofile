# emulate sh
# source ~/.profile
# emulate zsh

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Show PATH in readable format
# path() {
# 	java ~/.programs/EnvFormatter.java $PATH
# }

function duration() {
    local start_time=$1
    local end_time=$2

    local diff=$(echo "($end_time - $start_time) * 1000" | bc)
    local ftime=$(printf "%.3f" $diff)
    local ftime_int=${ftime%.*}

    if [ $ftime_int -gt 60000 ]; then
        ftime=$(echo "scale=3; $ftime / 60000" | bc)
        echo "${ftime} m"
        return
    fi

    if [ $ftime_int -gt 1000 ]; then
        ftime=$(echo "scale=3; $ftime / 1000" | bc)
        echo "${ftime} s"
        return
    fi

    echo "${ftime} ms"
    return
}

function reload() {
    local start=$(gdate +%s.3%N)
    print "\33[3m\33[93mReloading shell configuration...\33[0m"
    source "$ZDOTDIR/.zprofile"
    source "$ZDOTDIR/.zshrc"
    local end=$(gdate +%s.3%N)
    local time=$(duration "$start" "$end")
    print "\33[92mDone. Execution time: ${time}\33[0m"
}

function ip() {
    ifconfig en0 | grep "inet\s" | awk '{ print $2}' | lolcat
}

# Function to change active jdk version
function jdk() {
    if [ $# -ne 0 ]; then
        removeFromPath "${JAVA_HOME}/bin"
        if [[ -n ${JAVA_HOME+x} ]]; then
            removeFromPath "$JAVA_HOME"
        fi
        print "\33[3m\33[93mSwitching jdk...\33[0m"
        JAVA_HOME=$(/usr/libexec/java_home -v "$@")
        export JAVA_HOME
        export PATH=$PATH:$JAVA_HOME/bin
    fi
    java -version
}

function removeFromPath() {
    PATH=$(echo "$PATH" | sed -E -e "s;:$1;;" -e "s;$1:?;;")
    export PATH
}

function scan() {
    IP=$(ifconfig en0 | grep 'inet ' | awk '{ print $2 }')
    sudo nmap "$IP"/24
}

EM350_MAC='78:e4:0:b8:cf:7c'
TERMUX_MAC='a4:4b:d5:d1:c6:58'

function ssh_nadun() {
    IP=$(arp -a | grep ${EM350_MAC} | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
    ssh nadun@"${IP}"
}

function ssh_termux() {
    IP=$(arp -a | grep ${TERMUX_MAC} | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
    ssh "${termux}"@"${IP}" -p 8022
}

function ip_nadun() {
    IP=$(arp -a | grep ${EM350_MAC} | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
    echo "${IP}"
}

function ip_termux() {
    arp -a | grep ${TERMUX_MAC} | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
}

function clone() {
    # Default to SSH
    method="ssh"

    # Check for flags
    while getopts "m:" opt; do
        case "$opt" in
            m)
                if [ "$OPTARG" = "https" ]; then
                    method="https"
                elif [ "$OPTARG" != "ssh" ]; then
                    echo "Invalid method! Use -m ssh or -m https."
                    return 1
                fi
                ;;
            \?)
                echo "Invalid option: -$OPTARG"
                return 1
                ;;
        esac
    done
    shift $((OPTIND - 1))

    # Check if repository name is provided
    if [ $# -lt 1 ]; then
        echo "Repository name missing!"
        return 1
    fi

    # Set repository name and optional directory name
    repo_name="$1"
    directory_name="${2:-$repo_name}"  # Use the provided directory name or default to repo_name if not specified

    # Set the repository URL based on the selected method
    if [ "$method" = "https" ]; then
        repo_url="https://github.com/nipunlakshank/$repo_name.git"
    else
        repo_url="git@github.com:nipunlakshank/$repo_name.git"
    fi

    # Clone the repository into the specified directory
    git clone "$repo_url" "$directory_name"
}

function lfs_mnt() {
    osascript -e "mount volume \"smb://nipun:password@${IP_ANTIX}/Shared\""
}

function lfs_umnt() {
    diskutil umount /Volumes/Shared
}

function nfs_mnt() {
    osascript -e "mount volume \"nfs://${IP_ANTIX}/mnt/Shared\"" 1>/dev/null
    # sudo mount -t nfs antix.local:/mnt/Shared /Volumes/nfs/Shared
}

function nfs_umnt() {
    diskutil umount /Volumes/Shared
}

function debug_key() {
    ./gradlew signinReport | grep SHA1 | head -n 1 | awk '{print $2}' | pbcopy && print "\33[92m$(pbpaste)" && print "\33[0mCopied to Clipboard"
}

function barrier_server() {
    barriers -f --no-tray --debug INFO --name Nipuns-MacBook-Air.local --enable-drag-drop --disable-crypto -d
}

function db_export() {
    mysqldump -uroot -p "$1" >/Users/nipun/Documents/db_dumps/"${1}".sql
}

function term_info() {
    env | grep 'TERM'
}

function lt() {
    [ -n "$1" ] && [ "$1" -eq "$1" ] 2>/dev/null
    if [ $? -ne 0 ]; then
        colorls --tree
    else
        colorls --tree="$1"
    fi
}

function ltd() {
    [ -n "$1" ] && [ "$1" -eq "$1" ] 2>/dev/null
    if [ $? -ne 0 ]; then
        colorls --tree -d
    else
        colorls --tree="$1" -d
    fi
}

# if command -v ngrok &>/dev/null; then
# 	eval "$(ngrok completion)"
# fi

# ----- Use this function to manage different installations of apache -----
function apache() {

    local actions=("start" "stop" "restart")
    local servers=("homebrew" "hb" "mamp")

    # -------------- argument validation start --------------
    if [ $# -gt 2 ]; then
        echo "Error: argument count mismatch. Ex: apache start mamp"
        return 1
    fi

    found=0

    for a in "${actions[@]}"; do
        if [ "$a" = "$1" ]; then
            found=1
            break
        fi
    done

    if [ $found -eq 0 ]; then
        echo "Invalid action: $1"
        return 1
    fi

    found=0

    for s in "${servers[@]}"; do
        if [ $# -eq 1 ]; then
            if [ "$1" = "start" ]; then
                printf "Argument missing.\nEx: apache %s <server variant>" "$1"
                return 1
            fi
            (apache stop "$s")
            continue
        fi
        if [ "$s" = "$2" ]; then
            found=1
            break
        fi
    done

    if [ $found -eq 0 ]; then
        if [ $# -eq 1 ]; then
            return 0
        fi
        echo "Invalid server: $2"
        return 1
    fi
    # -------------- argument validation end --------------

    if [ "$1" = "start" ]; then
        if [ "$2" = "homebrew" ] || [ "$2" = "hb" ]; then
            /Applications/MAMP/Library/bin/httpd -k stop >/dev/null
            brew services start mysql >/dev/null
            brew services start httpd
            return 0
        elif [ "$2" = "mamp" ]; then
            brew services stop httpd >/dev/null
            brew services start mysql >/dev/null
            /Applications/MAMP/Library/bin/httpd -k start
            return 0
        fi
    elif [ "$1" = "stop" ]; then
        if [ "$2" = "homebrew" ] || [ "$2" = "hb" ]; then
            brew services stop httpd
            return 0
        elif [ "$2" = "mamp" ]; then
            /Applications/MAMP/Library/bin/httpd -k stop
            return 0
        fi
    elif [ "$1" = "restart" ]; then
        (apache stop "$2")
        (apache start "$2")
        return 0
    fi
}

function nvs() {
    local config

    if [ $# -eq 1 ]; then
        config="$1"
    else
        items=("default" "NvimTest" "KickStart" "LazyVim" "NvChad" "AstroNvim" "Clean")
        config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
    fi

    if [[ -z $config ]]; then
        echo "Nothing selected"
        return 0
    elif [[ $config == "default" ]]; then
        config=""
    elif [[ $config == "Clean" ]]; then
        config="nvim-clean"
    fi

    NVIM_APPNAME=$config nvim "$@"
}

function topsizes() {
    if [ $# -eq 0 ]; then
        du -ah . | sort -hr | head -n 10
        return 0
    elif [ $# -eq 1 ] && [ "$1" = "-a" ]; then
        du -ah . | sort -hr | fzf --height=~60% --layout=reverse --border --exit-0
        return 0
    elif [ $# -eq 1 ] && [[ $1 -gt 20 ]]; then
        du -ah . | sort -hr | head -n "$1" | fzf --height=~60% --layout=reverse --border --exit-0
        return 0
    elif [ $# -eq 1 ]; then
        du -ah . | sort -hr | head -n "$1"
        return 0
    else
        echo "Invalid input"
        return 1
    fi
}

function jdks() {
    versions=$(/usr/libexec/java_home -V)

    # echo $versions
}

function nvtestdir() {
    local dir='.'

    if [ $# -gt 0 ]; then
        dir="$1"
    fi

    if [ ! -d "$dir" ]; then
        echo "Invalid directory: $dir"
        return 1
    fi

    nvim --headless -c "set rtp=+./" -c "lua require('plenary')" -c "PlenaryBustedDirectory $dir"
}

function lh() {
    if [ $# -eq 0 ]; then
        ls -lAh --color | grep \\s\\.
    else
        ls -lAh --color "$1" | grep \\s\\.
    fi
}

function mvn-create() {
    if [ $# -eq 0 ]; then
        echo "No project name given"
        return 1
    else
        mvn archetype:generate -DgroupId=com.nlk.app -DartifactId="$1" -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeCatalog=internal -DarchetypeVersion=1.4 -DinteractiveMode=false
    fi
}

# home-manager switch
function hms() {
    if ! command -v home-manager &>/dev/null; then
        HOME_MANAGER_PATH=$(dirname "$(find /nix/store -name home-manager -type f | grep bin)")
        export PATH=$PATH:"${HOME_MANAGER_PATH}"
    fi

    "$HOME_MANAGER_PATH"/home-manager switch --extra-experimental-features flakes -f ~/dotfiles/nix/darwin/home.nix
}
