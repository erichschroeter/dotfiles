# aliases to help with builds
alias build='mkdir build && cd build'
alias rbuild='cd .. && rm -r build'
alias cloc="find . -name '*.cpp' -o -name '*.h' -o -name '*.c' | xargs wc -l"

# Bitbake aliases
bb_working_directory() {
	bitbake -e $1 | grep "^WORKDIR="
}
alias bitbakeworkdir=bb_working_directory
bb_source_directory() {
	bitbake -e $1 | grep "^S="
}
alias bitbakesrcdir=bb_source_directory
alias bitbakeclean='bitbake -c clean linux-ti-staging u-boot-ti-staging && rm tmp/deploy/images/gmcm/gmcm-image-*'
bb_dependencies() {
	bitbake -g $1 && cat pn-depends.dot | grep -v -e '-native' | \
	grep -v digraph | grep -v -e '-image' | awk '{print $1}' | sort | uniq
}
alias bitbakedependencies=bb_dependencies

ipk_extract() {
	 ar x $1 && mkdir $1.dir && tar -xzf control.tar.gz -C $1.dir && tar -xzf data.tar.gz -C $1.dir
}
ipk_clean() {
	 rm -r control.tar.gz data.tar.gz debian-binary $1.dir
}

# Extract mp3 from youtube URL
alias youtube-dl-mp3='youtube-dl -o "%(title)s-%(id)s.%(ext)s" -x --audio-quality 0 --audio-format mp3'

# vlc
# version <= 2.0.8 edit /usr/share/vlc/lua/http/.hosts
alias vlchttp='nohup vlc --extraintf=luahttp --fullscreen &'

# Handbrake CLI
alias HandBrakeCLI-scan='HandBrakeCLI --scan -t 0 -i /dev/dvd'
alias HandBrakeCLI-rip-dvd='HandBrakeCLI -m --main-feature -i /dev/dvd'

# avconv aliases
alias record='avconv -f x11grab -s 1920x1080 -r 25 -i :0.0'

# ISO 8601 date format
alias date='date +"%Y-%m-%dT%H:%M:%SZ"'

# Git
alias gl='git log --oneline --graph --color'
