# If not running interactively, don't do anything
[ -z "$PS1" ] && return

################################################################################
# EXPORTS
################################################################################

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# Expand the history size
export HISTSIZE=1000
export HISTFILESIZE=4000

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

################################################################################
# ALIASES
################################################################################

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

WINHOME="/mnt/c/Users/erich"
# Check if the directory /mnt/c/User/erich exists
if [ -d "$WINHOME" ]; then
  # Export a WINHOME variable equal to the directory path
  export WINHOME
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

################################################################################
# Starship
################################################################################

# check if starship exists on PATH before executing it
if command -v starship &> /dev/null
then
	eval "$(starship init bash)"
fi

