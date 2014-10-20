##
## Run by the login session.
##
## Allows environment variables to be set for the whole session, rather than
## per terminal as .bashrc creates.
##
## Script must be POSIX shell compatible.
##

if [ -z "$HOME" ];
then
	# What kind of hell hole is this? No home?!
	export HOME=$(getent passwd `id -u` | cut -d: -f6)
fi

. ~/.profile.d/functions

# Include subfiles
for file in ~/.profile.d/??-*; do
	if [ -f $file ]
	then
		. $file
	fi
done

# Include per-shell login file if required.
case "$SHELL" in
	bash)
		[ -f ~/.bash_profile ] && . ~/.bash_profile
	;;
esac
