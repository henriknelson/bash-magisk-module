export LS_OPTIONS='--color=auto' 
if [ -x "$(command -v dircolors)" ]; then
  eval "`dircolors`" 
  export LS_COLORS
fi 

alias tmux='cd /data/data/com.termux/files' 
alias su='su -s "/system/bin/bash" "$@"'
alias sudo='su -c "$@"'
alias sysro='su -c mount -o ro,remount /system/bin'
alias sysrw='su -c mount -o rw,remount /system/bin' 
alias ls='busybox ls $LS_OPTIONS -lA' 
alias ll='busybox ls $LS_OPTIONS -l' 
alias l='busybox ls $LS_OPTIONS' 
alias logcat='su -c "logcat -v color $@"'
[ -f "/system/bin/bat" ] && alias cat='bat --paging=never -p "$@"'
