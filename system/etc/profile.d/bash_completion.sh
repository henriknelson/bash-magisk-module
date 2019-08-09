if [ -f /system/share/bash-completion/bash_completion ]; then
  source /system/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi
