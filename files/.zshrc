#edit by my own!!!
# 加载 zinit
source "${HOME}/.local/share/zinit/zinit.git/zinit.zsh"
#neovim
export PATH="$PATH:/opt/nvim-linux64/bin"

##zoxide
eval "$(zoxide init zsh --cmd c)"
zinit ice wait"2" as"command" from"gh-r" \
    mv"zoxide* -> zoxide" \
    atclone"./zoxide init zsh > init.zsh" \
    atpull"%atclone" src"init.zsh" nocompile'!'

##Plugin
zinit light ajeetdsouza/zoxide
zinit light romkatv/powerlevel10k

##Aliases
alias ll='exa -al --color always --group-directories-first'
alias ls='exa -a --color always --group-directories-first'
alias v=nvim
alias vi=nvim

##keybinding
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

##HISTORY
HISTSIZE=10000             # 保存在內存中的歷史命令數量
SAVEHIST=10000             # 保存在 .zsh_history 文件中的命令數量
HISTFILE=~/.zsh_history  # 歷史記錄文件
# 儲存歷史記錄到文件
setopt INC_APPEND_HISTORY       # 每次執行命令後立即追加到 .zsh_history
setopt SHARE_HISTORY            # 允許多個 shell 即時同步歷史記錄
setopt HIST_IGNORE_DUPS         # 忽略重複的命令（在當前 session 中）
setopt HIST_REDUCE_BLANKS       # 移除命令中多餘的空格
setopt autocd

# CTRL-R - Paste the selected command from history into the command line
export FZF_DEFAULT_OPTS="--height=100% --multi"
hist_fzf() {
  # 從 .zsh_history 文件中讀取歷史記錄並處理格式
  local selected=$(cat ~/.zsh_history | sed -E 's/^: [0-9]+:0;//' | fzf --tac)

  # 如果有選擇的命令，將其插入到當前命令行
  if [[ -n $selected ]]; then
    LBUFFER+="$selected"
    zle reset-prompt
  fi
}
zle -N hist_fzf
bindkey '^R' hist_fzf
