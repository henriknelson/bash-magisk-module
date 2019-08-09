export host=android
export HOME=/sdcard
mkdir -p $HOME/tmp
export TMPDIR=$HOME/tmp

if [[ ${EUID} == 0 ]] ; then
        export USER="root"
else
        export USER="shell"
fi

if [ -d "/sbin/.magisk/busybox" ]; then
  BBDIR="/sbin/.magisk/busybox"
elif [ -d "/sbin/.core/busybox" ]; then
  BBDIR="/sbin/.core/busybox"
fi

export PATH=$BBDIR:/sbin:$PATH

# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
shopt -q -s checkwinsize

# Enable history appending instead of overwriting
shopt -s histappend

# Expand the history size
HISTFILESIZE=100000
HISTSIZE=10000
# ... and ignore same sucessive entries.
HISTCONTROL=ignoreboth

clear

export PS1="\[\033[1m\]\[\033[38;5;4m\]\$USER\[\033[m\]\[\033[38;5;15m\]@\[\033[m\]\[\033[1m\]\$HOSTNAME\[\033[m\][\W]:\[\033[1m\]"

# Print custom logo and system information
if [[ $- =~ "i" ]]
then
  [[ -s "/sdcard/.motd" ]] && cat /sdcard/.motd
  [[ -s "/system/bin/neofetch" ]] &&  neofetch --ascii_distro Lubuntu --off --color_blocks off --underline off --disable title packages icons theme gpu
fi

source /etc/profile.d/bash_completion.sh
source /sdcard/.bash_aliases
