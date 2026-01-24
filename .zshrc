# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
		git
		fzf
		zsh-syntax-highlighting
		zsh-autosuggestions
	)




source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# path
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export NVM_DIR="$HOME/.nvm"
export PATH="$HOME/.local/bin:$PATH"

# alias
alias v=nvim
alias vi=nvim
alias vim=nvim
alias lg=lazygit
alias ld=lazydocker
alias cpai='f() { TARGET_DIR="${1:-.}"; cp -r .github .claude .agent .gemini CLAUDE.md CLAUDE.local.md AGENTS.md GEMINI.md "$TARGET_DIR/" 2>/dev/null && echo "AI config files copied to $TARGET_DIR" || echo "Some files may not exist"; }; f'
alias z=zellij
alias za="zellij attach --create"
alias zd="zellij delete-session --force"
alias zwn='f() { CURRENT_DIR=$(basename "$(dirname "$PWD")"); ZNAME="$1"; DIRNAME="${CURRENT_DIR}-${ZNAME//\//-}"; SESSION_NAME="${CURRENT_DIR}-${ZNAME//\//-}"; git worktree add -b $ZNAME ../$DIRNAME && cpai ../$DIRNAME && cd ../$DIRNAME && za $SESSION_NAME; }; f'
# 새로운 워크트리 생성
alias gwn='f() { CURRENT_DIR=$(basename "$(dirname "$PWD")"); ZNAME="$1"; DIRNAME="${CURRENT_DIR}-${ZNAME//\//-}"; SESSION_NAME="${CURRENT_DIR}-${ZNAME//\//-}"; git worktree add -b $ZNAME ../$DIRNAME && cd ../$DIRNAME; }; f'
# 원격 브랜치로부터 워크트리 생성
alias gwp='f() { CURRENT_DIR=$(basename "$(dirname "$PWD")"); REMOTE_BRANCH="$1"; LOCAL_BRANCH="${REMOTE_BRANCH#*/}"; DIRNAME="${CURRENT_DIR}-${LOCAL_BRANCH//\//-}"; git worktree add -b "$LOCAL_BRANCH" "../$DIRNAME" "$REMOTE_BRANCH" && cd "../$DIRNAME"; }; f'
alias myip='curl http://ipecho.net/plain'
alias python="uv run python"
alias anki-iframe='f() { INPUT="$1"; if [[ "$INPUT" == http://* ]] || [[ "$INPUT" == https://* ]]; then URL="$INPUT"; else URL="https://blog.rookedsysc.com$INPUT"; fi; printf "[Link](%s)\n\n<iframe width=\"100%%\" height=\"2000\" src=\"%s\"></iframe>" "$URL" "$URL" | pbcopy; echo "Copied to clipboard!"; }; f'

# terminal에서 option + 방향키 동작 안함
# 참조 https://edykim.com/ko/post/setting-opt-direction-keys-when-using-zsh-in-iterm/
bindkey -e
bindkey "[D" backward-word
bindkey "[C" forward-word

# 파이썬 설정
source $HOME/.local/bin/env
alias python=python3
alias pip=pip3

# Rust Cargo 환경 설정
source "$HOME/.cargo/env"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ENV
export ENVIRONMENT="production" # labs


. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/dev/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
