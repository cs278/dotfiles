##
## Run by the login session.
##
## Allows environment variables to be set for the whole session, rather than
## per terminal as .bashrc creates.
##
## Script must be POSIX shell compatible.
##

# Provide a sane default PATH for initial setup
PATH_DEFAULT="${PATH:-/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin}"
export PATH="$PATH_DEFAULT"

path_unshift()
{
	# Adds the supplied path to the start of the PATH

	case "$1" in
		/*)
			# Absolute path, that does not exist,
			# keep the path clean by not adding it.
			[ ! -d "${1}" ] && return
		;;
	esac

	if [ -z "$PATH" ];
	then
		PATH="$1"
	else
		PATH="$1:$PATH"
	fi
}

path_push()
{
	# Adds the supplied path to the end of the PATH

	case "$1" in
		/*)
			# Absolute path, that does not exist,
			# keep the path clean by not adding it.
			[ ! -d "${1}" ] && return
		;;
	esac

	if [ -z "$PATH" ];
	then
		PATH="$1"
	else
		PATH="$PATH:$1"
	fi
}

# Standard environment settings

case $(hostname --domain) in
	*.kv-is.local|kv-is.local)
		EMAIL="chris.smith@widerplan.com"
	;;
	*.cs278.org|cs278.org)
		EMAIL="chris@cs278.org"
	;;
	*)
		echo "Unknown machine." >&2
	;;
esac

export NAME="Chris Smith";
export EMAIL;

# I'm a simpleton
export EDITOR="nano";

if [ -n "$DISPLAY" ];
then
	# If running inside a graphical session adjust some settings.

	if which google-chrome >/dev/null 2>&1;
	then
		# I prefer Chrome
		BROWSER=google-chrome
	elif which x-www-browser >/dev/null 2>&1;
	then
		# Fallback to system default
		BROWSER=x-www-browser
	fi
fi

if [ -n "$VISUAL" ];
then
	export VISUAL
fi

if [ -n "$BROWSER" ];
then
	export BROWSER
fi

# Set up language environment
export LANG=${LANG:-en_GB.UTF-8}

# Set up a safe TMPDIR
export TMPDIR="/tmp/$USER"

if [ ! -d "$TMPDIR" ];
then
	mkdir --mode=0700 --parents "$TMPDIR"
else
	chmod 0700 "$TMPDIR"
fi

# A number of programs create a $TMPDIR/$USER directory themselves
# create a symlink so they use the correct location.
if [ ! -s "$TMPDIR/$USER" ];
then
	ln -s . "$TMPDIR/$USER"
fi

# Pager settings
export LESS="--tabs=4 --RAW-CONTROL-CHARS"

# Make settings
if command -v cpu-cores > /dev/null 2>&1;
then
	export MAKEFLAGS="--jobs=$(( `cpu-cores` + 1 ))"
fi

# Composer settings
export COMPOSER_HOME=${XDG_CONFIG_HOME:-$HOME/.config}/composer
export COMPOSER_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/composer

# Default GnuPG keys
export GPG_SIGN=4EDDF2C7
export GPG_ENCRPYT=D4AA8EB1

# Set a fairly basic PATH interactive shells overload this.
#export PATH="$HOME/bin:$PATH"

# Cleanout
PATH=""

# TODO: Check for gaining root before adding sbin
path_unshift /sbin
path_unshift /bin
path_unshift /usr/sbin
path_unshift /usr/bin
path_unshift /usr/local/sbin
path_unshift /usr/local/bin

# Ubuntu/Debian things
if [ -f /etc/debian_version ];
then
	path_unshift /usr/lib/lightdm/lightdm
	path_push /usr/games
fi

# RHEL
if [ -f /etc/redhat-release ];
then
	push_unshift /usr/kerberos/bin
fi

# Rackspace
if [ -d ~rack ];
then
	path_push /opt/dell/srvadmin/bin
fi

path_unshift "$HOME/bin"

# Bleeding ruby
if [ -d /var/lib/gems ];
then
	for dir in /var/lib/gems/*/bin; do
		path_push "${dir}"
	done
fi

if [ $(id -u) -gt 0 ];
then
	# Not root add $PWD/bin as an executable path
	path_unshift "bin"
fi

if [ -z "$PATH" ];
then
	echo "Failed to configure a valid PATH, falling back to default." >&2
	PATH=$PATH_DEFAULT
fi

# Cleanup locale environment variables
# Removes pointless LC_ variables from the environment.

# Normalise UTF-8 encoding in locales.
for line in `env | grep ^LC_..*=..*\.utf8$`;
do
	var=$(echo "$line" | cut -f1 -d=)
	value=$(echo "$line" | cut -f2- -d= | sed 's/\.utf8$/\.UTF-8/')

	eval `echo "$var=$value"`

	export $var
done

for line in `env | grep ^LC_..*=$LANG$`;
do
	var=$(echo "$line" | cut -f1 -d=)

	unset $var
done

# Include per-shell login file if required.
case "$SHELL" in
	bash)
		[ -f ~/.bash_profile ] && . ~/.bash_profile
	;;
esac
