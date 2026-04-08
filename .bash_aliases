# Detect distro
detect_distro() {
    local uname_out distro

    uname_out=$(uname | tr "[:upper:]" "[:lower:]")

    if [ "$uname_out" = "linux" ]; then
        if [ -f /etc/lsb-release ] || [ -d /etc/lsb-release.d ]; then
            distro=$(lsb_release -i 2>/dev/null | cut -d: -f2 | sed 's/^[[:space:]]*//')
        else
            distro=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* 2>/dev/null \
                | grep -v "lsb" \
                | head -n1 \
                | cut -d'/' -f3 \
                | cut -d'-' -f1 \
                | cut -d'_' -f1)
        fi
    fi

    # Fallback: if still empty, use uname result
    [ -z "$distro" ] && distro="$uname_out"

    printf '%s\n' "$distro"
}

if [ "$(detect_distro)" = "Ubuntu" ]; then
    alias fd='fdfind'
fi

ssh-unlock() {
    local conf="${1:-$HOME/.ssh/unlock.conf}"

    if [ ! -f "$conf" ]; then
        echo "Error: Configuration file not found at $conf"
        echo "Format: /path/to/key | Bitwarden Item Name"
        return 1
    fi

    # Ensure rbw is unlocked
    if ! rbw status >/dev/null 2>&1; then
        echo "Unlocking Bitwarden (rbw)..."
        rbw unlock || return 1
    fi

    while IFS='|' read -r key_path bw_name || [ -n "$key_path" ]; do
        # Trim whitespace
        key_path=$(echo "$key_path" | xargs)
        bw_name=$(echo "$bw_name" | xargs)

        # Skip comments and empty lines
        [[ -z "$key_path" || "$key_path" == \#* ]] && continue

        # Expand ~ if present
        eval key_path="$key_path"

        if [ -f "$key_path" ]; then
            local pass
            if pass=$(rbw get "$bw_name" 2>/dev/null); then
                echo "Unlocking $key_path using '$bw_name'..."
                expect <<EOF
                    spawn ssh-add "$key_path"
                    expect "Enter passphrase"
                    send -- "$pass\r"
                    expect eof
EOF
            else
                echo "Warning: Could not find Bitwarden item '$bw_name'"
            fi
        else
            echo "Warning: SSH key not found at $key_path"
        fi
    done < "$conf"
}

m3u8_download() {
	ffmpeg -i "$1" -c:v libx264 -preset ultrafast -crf 20 "$2"
}
# Extract mp3 from youtube URL
alias youtube-dl-mp3='yt-dlp -o "%(title)s-%(id)s.%(ext)s" -x --audio-quality 0 --audio-format mp3'
alias youtube-dl-vid='yt-dlp -o "%(title)s-%(id)s.%(ext)s" --audio-quality 0'
alias m3u8='m3u8_download'

# Rust UNIX tools
alias ll='eza -alh'
alias ls='eza'
alias cat='batcat -p --paging=never'
alias tree='eza --tree'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ISO 8601 date format
alias date-iso8601='date +"%Y-%m-%dT%H:%M:%SZ"'

# Ubuntu toggle mute
alias mute='pactl set-sink-mute @DEFAULT_SINK@ toggle'
alias volume='pactl set-sink-volume @DEFAULT_SINK@'

