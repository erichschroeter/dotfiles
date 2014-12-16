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
