# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

add_to_path() {
	local dir="$1"
	local position="${2:-append}"  # prepend or append (default: append)
	local check_duplicates="${3:-false}"  # true/false (default: false)

	[ ! -d "$dir" ] && return

	if [ "$check_duplicates" = "true" ]; then
		case ":$PATH:" in
			*":$dir:"*) return ;;
		esac
	fi

	if [ "$position" = "prepend" ]; then
		PATH="$dir:$PATH"
	else
		PATH="$PATH:$dir"
	fi
}

source_if_exists() {
	[ -f "$1" ] && . "$1"
}

if [ -n "$BASH_VERSION" ]; then
	source_if_exists "$HOME/.bashrc"
fi

# Add directories to PATH
add_to_path "$HOME/bin" "prepend"
add_to_path "$HOME/.local/bin" "prepend"
add_to_path "/opt/nvim-linux-x86_64/bin"

# NVM setup
export NVM_DIR="$HOME/.nvm"
source_if_exists "$NVM_DIR/nvm.sh"
source_if_exists "$NVM_DIR/bash_completion"

# pnpm setup with duplicate checking
export PNPM_HOME="/home/erich/.local/share/pnpm"
add_to_path "$PNPM_HOME" "prepend" "true"

# Rust environment
source_if_exists "$HOME/.cargo/env"

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
	export TERM='xterm-256color'
else
	export TERM='xterm-color'
fi

# specify monitor positions
#if [ "$XDG_SESSION_DESKTOP" = "dwm" ]; then
#	~/.screenlayout/2-monitors.sh
#fi

# Use same SSH agent session for all terminals.
export SSH_AUTH_SOCK=~/.ssh/ssh-agent.$HOSTNAME.sock
rm -f "$SSH_AUTH_SOCK"
if ! ssh-add -l >/dev/null 2>&1; then
	ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
fi
