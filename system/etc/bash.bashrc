if [ -x /system/libexec/magisk/command-not-found ]; then
	command_not_found_handle() {
		/system/libexec/magisk/command-not-found "$1"
	}
fi
