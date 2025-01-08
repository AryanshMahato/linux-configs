autoload -Uz compinit
compinit

EDITOR=nvim
alias CW="cd ~/Coding/work"
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Starship
eval "$(starship init zsh)"

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# ZSH
# https://gist.github.com/ikrishagarwal/d6a406d1b00bb637834c88a162bdbce6
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ========== FZF ============= 
source <(fzf --zsh)
source ~/.zsh/fzf-git.sh/fzf-git.sh

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
# ========== FZF ============= 

# BAT
alias cat="bat"

# EZA
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# Brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# thefuck alias
eval $(thefuck --alias)

eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

alias cd="z"

# History
SAVEHIST=1000  # Save most-recent 1000 lines
HISTFILE=~/.zsh_history
HISTSIZE=1000


# Load Angular CLI autocompletion.
source <(ng completion script)
