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
