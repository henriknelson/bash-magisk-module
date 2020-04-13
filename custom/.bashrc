if [[ $- != *i* ]]
then
	return
fi

if [ "$NELSHH_BASH" = $EUID ]
then
	return
fi

export NELSHH_BASH=$EUID
export HOME=/sdcard
mkdir -p $HOME/tmp
export TMPDIR=$HOME/tmp

if [[ ${EUID} == 0 ]] ; then
        export USER="root"
	export HISTFILE=/sdcard/.root_history
	export SHELL=/system/bin/bash
else
        export USER="henrik"
	export HISTFILE=$HOME/.history
fi

export host=android
export HOSTNAME="oneplus"
export TERM=xterm
export TERMINFO=/system/usr/share/terminfo
export MANPAGER='bat --pager="less" -p --language=man'
export PATH="$PATH:/system/xbin"

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
[[ -s "/etc/profile.d/bash_completion.sh" ]] && source /etc/profile.d/bash_completion.sh

shopt -q -s checkwinsize
[[ -s "resize" ]] && resize > /dev/null

BLUE='\033[38;5;4m'
WHITE='\033[38;5;15m'
THIN='\033[m'
BOLD='\033[1m'
PS1="\[$BOLD\]\[$BLUE\]$USER\[$THIN\]\[$WHITE\]@\[$THIN\]\[$BOLD\]$HOSTNAME\[$THIN\]\[$BOLD\][\W\[$THIN\]]:\[$BOLD\]"
set -o histexpand -o history
