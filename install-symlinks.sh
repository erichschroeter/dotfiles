#/bin/bash

usage() {
	cat << EOF
Usage: $(basename $0) [OPTIONS]

Installs symlinks for files in this repo into '$HOME'.

Options:
  -h, --help                     Print this menu and exit.
  -v, --verbose                  Print verbose info.
EOF
}

SHORT=v,h
LONG=verbose,help
OPTS=$(getopt -a -n install-symlinks.sh --options $SHORT --longoptions $LONG -- "$@")
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
BACKUP_EXT=.bak

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

#if [ "$VALID_ARGUMENTS" -eq 0 ]; then
#  usage
#fi

eval set -- "$OPTS"

while :
do
  case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      ;;
  esac
done

## @brief Checks if the destination file exists and prompts the user to create a backup.
##
## @param $1 path to source file in this repo
## @param $2 (optional) destintation filename of the symlink [default: $(basename $1)]
install_with_backup_check() {
	SRC_PATH="$SCRIPT_DIR/$1"
	SRC_FILENAME=$(basename $1)
	DEST_FILENAME="${2:-$SRC_FILENAME}"
	INSTALL_PATH=$HOME/$DEST_FILENAME
	# -L    file exists and is a symbolic link (linked file may or may not exist)
	# -f    file exists and is regular file
	# -e    file exists regardless of type
	if [ -e "$INSTALL_PATH" ]; then
		read -p "$INSTALL_PATH already exists. Create backup? [yN] " -n 1 -r
		echo # move to new line
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			mv $INSTALL_PATH $INSTALL_PATH$BACKUP_EXT
			ln -s $SRC_PATH $INSTALL_PATH
		fi
	else
		ln -s $SRC_PATH $INSTALL_PATH
	fi
}

install_with_backup_check bashrc .bashrc
install_with_backup_check bash_aliases .bash_aliases
install_with_backup_check profile .profile
install_with_backup_check git/.gitconfig

