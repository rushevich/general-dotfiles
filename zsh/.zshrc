# Created by `pipx` on 2026-05-19 01:03:16
export PATH="/opt/X11/bin:/opt/homebrew/opt/llvm/bin:$PATH:/Users/rushevichg/.local/bin:/Users/rushevichg/scripts"
export CPPFLAGS="I/opt/homebrew/opt/llvm/include"
export LDFLAGS="L/opt/homebrew/opt/llvm/lib"

ghostty-theme() {
  local tf="$HOME/Library/Application Support/com.mitchellh.ghostty/theme.conf"
  if [[ -z "$1" ]]; then
    ghostty +list-themes
    return
  fi
  echo "theme = $1" > "$tf"
  pkill -USR2 ghostty
}

ghostty-theme-pick() {
  local tf="$HOME/Library/Application Support/com.mitchellh.ghostty/theme.conf"
  local choice
  choice=$(ghostty +list-themes | fzf --prompt="theme> " | awk '{print $1}')
  [[ -z "$choice" ]] && return
  echo "theme = $choice" > "$tf"
  pkill -USR2 ghostty
}

function _welcome() {
    local hour=$(date +%H)
    local greeting icon
    if   (( hour < 6 ));  then greeting="Burning the midnight oil"; icon=""
    elif (( hour < 12 )); then greeting="Good morning";             icon=""
    elif (( hour < 18 )); then greeting="Good afternoon";           icon=""
    else                       greeting="Good evening";             icon=""
    fi

    # uptime, load, and git-aware cwd flavor
    local up=$(uptime | sed -E 's/.*up ([^,]*,?[^,]*),.*users.*/\1/' | xargs)
    local host=$(scutil --get ComputerName 2>/dev/null || hostname -s)

    print -P "%F{${TOKEN_ACCENT}}${icon}  %F{${TOKEN_FG}}${greeting}, %B%n%b%f"
    print -P "%F{${TOKEN_BLUE}}$(date '+%A, %B %d %Y')  %F{${TOKEN_MUTED}}·  %F{${TOKEN_BLUE}}$(date '+%H:%M')%f"
    print -P "%F{${TOKEN_GREEN}}${host}%F{${TOKEN_MUTED}} · %F{${TOKEN_PURPLE}}$(uname -sm)%F{${TOKEN_MUTED}} · up ${up}%f"
    echo
}


autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi


eval "$(zoxide init zsh)"
# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/token-dark.zsh
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' on %F{#e0af68}%b%f'
setopt prompt_subst   # required so ${vcs_info_msg_0_} expands each prompt

PROMPT='%F{${TOKEN_MUTED}}%n %F{${TOKEN_BLUE}}%~%f${vcs_info_msg_0_} %F{${TOKEN_BLUE}}%f%F{${TOKEN_GREEN}} '
_welcome
