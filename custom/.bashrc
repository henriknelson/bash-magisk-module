echo "/sdcard/.bashrc as $(whoami)" >> /storage/emulated/0/bash_log;

if [[ $- != *i* ]]
then
	return
fi

if [ "$NELSHH_BASH" = $EUID ]
then
	return
fi

#PARENT_COMMAND=$(ps -o args= $PPID)
#echo $PARENT_COMMAND
#echo $PARENT_COMMAND >> /sdcard/bash_log

export NELSHH_BASH=$EUID
export HOME=/sdcard
mkdir -p $HOME/tmp
export TMPDIR=$HOME/tmp

if [[ ${EUID} == 0 ]] ; then
        export USER="root"
	export HISTFILE=$HOME/.root_history
else
        export USER="henrik"
	export HISTFILE=$HOME/.history
fi

export SHELL=/system/bin/bash
export host=android
export HOSTNAME="oneplus"
export TERM=xterm
export TERMINFO="/sdcard/.terminfo:/system/usr/share/terminfo"
export MANPAGER="bat --pager='less_raw' -p --language=man"
export PATH="$HOME/.local/bin:$PATH:/system/xbin"

export HISTTIMEFORMAT="$USER %F %T "
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export PROMPT_COMMAND='history -a'
shopt -s histappend
shopt -s cmdhist

clear
cd /sdcard

# Print custom logo and system information
if [[ $- == *i* ]]
then
  [[ -s "/sdcard/.motd" ]] && cat /sdcard/.motd
  [[ -s "/system/bin/neofetch" ]] &&  neofetch --ascii_distro Lubuntu --off --color_blocks off --underline off --disable title packages icons theme gpu
fi

[[ -s "/sdcard/.bash_aliases" ]] && source /sdcard/.bash_aliases
[[ -s "/system/etc/profile.d/bash_completion.sh" ]] && source /system/etc/profile.d/bash_completion.sh

shopt -q -s checkwinsize
[[ -s "resize" ]] && resize > /dev/null

BLUE='\033[34m'
WHITE='\033[38;5;15m'
THIN='\033[m'
BOLD='\033[1m'
PS1="\[$BOLD\]\[$BLUE\]$USER\[$THIN\]\[$WHITE\]@\[$THIN\]\[$BOLD\]$HOSTNAME\[$THIN\]\[$BOLD\][\W\[$THIN\]]:\[$BOLD\]"

export PYTHONSTARTUP=~/.pythonrc

source /sdcard/enhancd/init.sh
export ENHANCD_FILTER=fzf:fzy:peco
export FZF_DEFAULT_OPTS="--ansi --no-info --height 20% --reverse --history=\"$HISTFILE\""
export FZF_DEFAULT_COMMAND="fd -IH -t f"
[ -f /sdcard/.fzf.bash ] && source /sdcard/.fzf.bash
set -o histexpand -o history
