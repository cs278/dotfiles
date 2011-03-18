# If not running interactively, don't do anything
[ -z "$PS1" ] && return

PROMPT_COMMAND=""

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color)
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	;;

	*)
		PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
	;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PROMPT_COMMAND+='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007";'
	;;

	*)
	;;
esac

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
	eval "`dircolors -b`"
	alias ls='ls --color=auto'

	COLOUR=y
else
	COLOUR=
fi

# Ensure tab completion is enabled if it is available.
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# Include personal bin folder in the executable path
if [ -d ~/bin ] ; then
	PATH="~/bin:${PATH}"
fi

# Include subfiles
. ~/.bash/*

local HOSTNAME=$(hostname --short 2> /dev/null || cat /etc/hostname)

if [ -f ~/.bash/$HOSTNAME ]; then
	. ~/.bash/$HOSTNAME
fi

# Reset prompt for now
PS1='${debian_chroot:+($debian_chroot)}\u@\h:$(prompt_cwd)\$ '

unset COLOUR
