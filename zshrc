# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="bullet-train"
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_DIR_HOME_BACKGROUND='062'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='red'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='062'
POWERLEVEL9K_DIR_HOME_FOREGROUND='236'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='236'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='236'
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='240'
POWERLEVEL9K_STATUS_OK=false
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context vcs time status newline dir)
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv time newline)
if which pyenv-virtualenv-init > /dev/null; then
    eval "$(pyenv init -)";
fi

# BULLETTRAIN_VIRTUALENV_FG="black"
# BULLETTRAIN_GO_SHOW="true"
# BULLETTRAIN_GO_FG="black"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=10000

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/mysql/bin:${HOME}/.cargo/bin"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n ${SSH_CONNECTION} ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

setopt appendhistory
setopt share_history
setopt inc_append_history

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Bindings for FZF
export FZF_DEFAULT_OPTS='-m'

fh() {
    # fh - repeat history
    LBUFFER="$(fc -l 1 | sed 's/ *[0-9]* *//' | sort | uniq | fzf +s -e --tac)"
}

fkill() {
    # fkill - kill process
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x${pid}" != "x" ]
    then
        kill -${1:-9} ${pid}
    fi
}

fb() {
    git branch --list --all | fzf --color | xargs git checkout
}

taskw() {
    # Poor man's do-while
    clear
    out=$(task rc._forcecolor:on rc.defaultwidth:120 next limit:50)
    echo "$out"
    while sleep 5; out=$(task rc._forcecolor:on rc.defaultwidth:120 next limit:50); do clear; echo "$out"; done
}

vpnc() {
    nmcli con up id DataRobotVPN_hq
}

vpnd() {
    nmcli con down id DataRobotVPN_hq
}

vpns() {
    nmcli con show --active | grep vpn
}

vpnw() {
    while true; do
        vpns > /dev/null 2>&1
        if [[ $? != 0 ]]; then
            vpnc > /dev/null 2>&1
        fi
        sleep 10
    done
}

vpnwbg() {
    echo "Starting VPN watcher daemon"
    vpnw &
    export VPNWATCHPID=$!
}

vpnwbgkill() {
    echo "Killing VPN watcher daemon"
    kill -9 ${VPNWATCHPID} > /dev/null
}

title() {
    echo -e "\033]0;$@\007"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fpath=(~/_rg $fpath)

# Binding reverse history search to fzf function
zle -N fh
# bindkey -s '^r' 'fh\n'
bindkey '^r' fh

# SUDO PLUGIN
sudo-command-line() {
    [[ -z ${BUFFER} ]] && zle up-history
    if [[ ${BUFFER} == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ ${BUFFER} == ${EDITOR}\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit ${LBUFFER}"
    elif [[ ${BUFFER} == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="${EDITOR} ${LBUFFER}"
    else
        LBUFFER="sudo ${LBUFFER}"
    fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" sudo-command-line

if which starship >/dev/null; then
    eval "$(starship init zsh)"
else
    source ${ZSH}/oh-my-zsh.sh
fi
PATH=${PATH}:~/.local/bin/
PATH=${PATH}:~/.local/go/bin/
PATH=${PATH}:~/go/bin/
PATH=${PATH}:~/.gotools/
PATH=${PATH}:/snap/bin/


# Oh-my-zsh will overwrite some of these aliases if we put them before it, so
# they need to go here
alias vi="NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim"
alias vim=nvim
alias cleanpy="find . \( -name '*.pyc' -o -name '*.pyo' \) -exec rm -f {} +"
if which kitty > /dev/null; then
    alias ssh="kitty +kitten ssh"
fi

if which lsd > /dev/null; then
    alias ls='lsd'
    alias l='lsd -l'
    alias la='lsd -a'
    alias lla='lsd -la'
    alias lt='lsd --tree'
fi

# Hidden creds
# creds needed for rcfile functionality
# * JENKINS_URL
# * JENKINS_USER
# * JENKINS_TOKEN
CREDSFILE=~/.config/.creds
if [ -e ${CREDSFILE} ]; then
    source ${CREDSFILE}
else
    echo "No creds file found at ${CREDSFILE}"
fi
