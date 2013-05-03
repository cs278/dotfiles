##
## Run by the login session.
##
## Allows environment variables to be set for the whole session, rather than
## per terminal as .bashrc creates.
##
## Script must be POSIX shell compatible.
##

# Set up my basic environment
. ~/.bash/00-environment

# Adjust PATH to my liking
# Cannot use my normal .01-path here as it busts Gnome.
export PATH="$HOME/bin:$PATH"

# Cleanup locale environment variables
. ~/.bash/09-lc-cleanup
