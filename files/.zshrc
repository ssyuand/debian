#
# need zoxide fd-find exa fzf bat
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#edit by my own!!!
export TERM=xterm-256color
export FZF_DEFAULT_OPTS="--height=100% --multi"

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
