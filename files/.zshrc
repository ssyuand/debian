#edit by my own!!!
# Load zinit plugin manager
source "${HOME}/.local/share/zinit/zinit.git/zinit.zsh"

# Add Neovim binary to system PATH
export PATH="$PATH:/opt/nvim-linux64/bin"

## zoxide configuration
# Initialize zoxide and set the prefix command to 'c'
eval "$(zoxide init zsh --cmd c)"

# Install zoxide using zinit with silent loading
zinit ice wait"2" as"command" from"gh-r" \
    mv"zoxide* -> zoxide" \
    atclone"./zoxide init zsh > init.zsh" \
    silent

## Plugin configuration
# Load zoxide and powerlevel10k plugins
zinit light ajeetdsouza/zoxide
zinit light romkatv/powerlevel10k

## Command aliases
alias ll='exa -al --color always --group-directories-first'  # List files with details, grouped by directories
alias ls='exa -a --color always --group-directories-first'   # List all files, grouped by directories
alias v=nvim                                                # Shortcut for nvim
alias vi=nvim                                               # Replace 'vi' with nvim

## Keybindings
bindkey -e                           # Use Emacs-style keybindings
bindkey '^p' history-search-backward # Search command history (backward)
bindkey '^n' history-search-forward  # Search command history (forward)

## History configuration
HISTSIZE=10000             # Number of commands stored in memory
SAVEHIST=10000             # Number of commands saved in the .zsh_history file
HISTFILE=~/.zsh_history    # Location of the history file

# History options
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands in the current session
setopt HIST_IGNORE_ALL_DUPS     # Remove older duplicate commands from the history
setopt INC_APPEND_HISTORY       # Append commands to .zsh_history immediately
setopt SHARE_HISTORY            # Share history across multiple shells
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands in the current session
setopt HIST_REDUCE_BLANKS       # Remove unnecessary spaces from commands
setopt autocd                   # Allow automatic directory changes

## Use fzf to search history
export FZF_DEFAULT_OPTS="--height=100% --multi" # Configure fzf options
hist_fzf() {
  # Read and format history from .zsh_history using fzf
  local selected=$(cat ~/.zsh_history | sed -E 's/^: [0-9]+:0;//' | fzf --tac)

  # Insert the selected command into the current command line if any
  if [[ -n $selected ]]; then
    LBUFFER+="$selected"
    zle reset-prompt
  fi
}
zle -N hist_fzf
bindkey '^R' hist_fzf          # Bind Ctrl+R to fzf-based history search