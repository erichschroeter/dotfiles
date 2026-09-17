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
alias cpcb='xclip -selection clipboard'
alias tree='eza --tree'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ISO 8601 date format
alias date-iso8601='date +"%Y-%m-%dT%H:%M:%SZ"'

# Ubuntu toggle mute
alias mute='pactl set-sink-mute @DEFAULT_SINK@ toggle'
alias volume='pactl set-sink-volume @DEFAULT_SINK@'

# -----------------------------------------------------------------------------
# Devcontainer Build Helpers (AEPP & Hydra)
# -----------------------------------------------------------------------------
export AEPP_DIR="${AEPP_DIR:-/opt/BradyRD/AEPP-git}"
export HYDRA_DIR="${HYDRA_DIR:-/opt/BradyRD/hydra}"

# Helper: resolve workspace root from current directory, or fall back to default.
# Usage: _resolve_workspace <fallback_dir> <file_to_detect>
_resolve_workspace() {
    local fallback="$1"
    local indicator="$2"
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$git_root" && -e "$git_root/$indicator" ]]; then
        echo "$git_root"
    else
        echo "$fallback"
    fi
}

# Helper: ensure the devcontainer is running before executing a command inside it.
# Usage: _ensure_devcontainer <workspace_folder> <config_path>
_ensure_devcontainer() {
    local ws="$1"
    local cfg="$2"
    if ! devcontainer exec --workspace-folder "$ws" --config "$cfg" true 2>/dev/null; then
        echo "==> Starting devcontainer for $(basename "$ws") ($(basename "$(dirname "$cfg")"))..."
        devcontainer up --workspace-folder "$ws" --config "$cfg" || return 1
    fi
}

# -----------------------------------------------------------------------------
# aepp-build: Build AEPP targets inside a devcontainer.
#
# Usage:
#   aepp-build [OPTIONS] [TARGET...]
#
# Options:
#   -c, --container  FLAVOR    Devcontainer to use. One of:
#                                aarch64    (default, alias: linux-aarch64)
#                                linuxaepp  (alias: linux)
#                                m33        (alias: freertos_m33)
#   -p, --preset     PRESET    CMake build preset (default: developer)
#       --configure            Only run cmake configure step, skip build
#       --clean                Pass --clean-first to cmake --build
#       --                     Pass remaining args directly to cmake --build
#
# Examples:
#   aepp-build                            # configure + build all (aarch64/developer)
#   aepp-build HydraSandbox               # build a single target
#   aepp-build -c linuxaepp IppServer     # build IppServer in the linuxaepp container
#   aepp-build -c m33                     # build all M33 targets
#   aepp-build --configure                # cmake configure only
#   aepp-build --clean HydraSandbox       # clean + build target
#   aepp-build -- -j4                     # pass extra flags to cmake --build
# -----------------------------------------------------------------------------
aepp-build() {
    # Map container flavors to devcontainer folder and CMake configure preset names
    local container_flavor configure_preset
    local preset="developer"
    local configure_only=0
    local clean_build=0
    local -a targets=()
    local -a extra_cmake_args=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c|--container)
                case "$2" in
                    aarch64|linux-aarch64|linuxaarch64)
                        container_flavor="linuxaarch64"
                        configure_preset="linux-aarch64"
                        ;;
                    linuxaepp|linux)
                        container_flavor="linuxaepp"
                        configure_preset="linux"
                        ;;
                    m33|freertos_m33|freertos-m33)
                        container_flavor="freertos_m33"
                        configure_preset="freertos_m33"
                        ;;
                    *)
                        echo "Error: Unknown container '$2'. Use: aarch64, linuxaepp, m33" >&2
                        return 1
                        ;;
                esac
                shift 2
                ;;
            -p|--preset)
                preset="$2"
                shift 2
                ;;
            --configure)
                configure_only=1
                shift
                ;;
            --clean)
                clean_build=1
                shift
                ;;
            --)
                shift
                extra_cmake_args+=("$@")
                break
                ;;
            -*)
                extra_cmake_args+=("$1")
                shift
                ;;
            *)
                targets+=("$1")
                shift
                ;;
        esac
    done

    # Default container: linuxaarch64
    container_flavor="${container_flavor:-linuxaarch64}"
    configure_preset="${configure_preset:-linux-aarch64}"

    local ws
    ws=$(_resolve_workspace "$AEPP_DIR" "cmake/BuildList.cmake")
    local cfg="$ws/.devcontainer/${container_flavor}/devcontainer.json"

    if [[ ! -f "$cfg" ]]; then
        echo "Error: Devcontainer config not found: $cfg" >&2
        return 1
    fi

    _ensure_devcontainer "$ws" "$cfg" || return 1

    # CMake configure
    echo "==> Configuring AEPP [$ws] (configure preset: $configure_preset)..."
    devcontainer exec --workspace-folder "$ws" --config "$cfg" \
        cmake --preset "$configure_preset" || return 1

    [[ "$configure_only" -eq 1 ]] && return 0

    # CMake build
    local -a target_args=()
    for t in "${targets[@]}"; do
        target_args+=(--target "$t")
    done

    local -a clean_arg=()
    [[ "$clean_build" -eq 1 ]] && clean_arg=(--clean-first)

    local preset_arg="${container_flavor}_${configure_preset}_${preset}"
    # Build presets in buildPresets.json follow pattern: <platform>_<config>
    # e.g. linux-aarch64_developer, freertos_m33_developer, linux_developer
    local build_preset="${configure_preset}_${preset}"

    echo "==> Building AEPP [$ws] (build preset: $build_preset, targets: ${targets[*]:-all})..."
    devcontainer exec --workspace-folder "$ws" --config "$cfg" \
        cmake --build --preset "$build_preset" \
            "${target_args[@]}" "${clean_arg[@]}" "${extra_cmake_args[@]}"
}

# -----------------------------------------------------------------------------
# hydra-build: Run Bitbake recipes inside the Hydra devcontainer.
#
# Usage:
#   hydra-build [BITBAKE_ARGS...] [RECIPE...]
#
# Environment overrides:
#   BB_NUMBER_THREADS   Number of bitbake threads (default: nproc)
#   PARALLEL_MAKE       Number of make jobs      (default: nproc)
#   MACHINE             Yocto MACHINE target      (default: stm32mp255d-hydrabadger-mx)
#
# Examples:
#   hydra-build                         # build aepp-image-dev (default)
#   hydra-build aepp-image              # build a specific image
#   hydra-build -c cleansstate dcgen    # clean and rebuild dcgen recipe
#   hydra-build -k aepp-image-dev       # keep going on errors
# -----------------------------------------------------------------------------
hydra-build() {
    local ws
    ws=$(_resolve_workspace "$HYDRA_DIR" "layers/hydra")
    local cfg="$ws/.devcontainer/hydra/devcontainer.json"

    if [[ ! -f "$cfg" ]]; then
        echo "Error: Hydra devcontainer config not found: $cfg" >&2
        return 1
    fi

    _ensure_devcontainer "$ws" "$cfg" || return 1

    local nproc_val
    nproc_val=$(nproc 2>/dev/null || echo 8)
    local threads="${BB_NUMBER_THREADS:-$nproc_val}"
    local parallel_make="${PARALLEL_MAKE:-$nproc_val}"

    local -a bb_args=("$@")
    if [[ ${#bb_args[@]} -eq 0 ]]; then
        bb_args=("aepp-image-dev")
    fi

    echo "==> Building Hydra [$ws]: bitbake ${bb_args[*]} (threads=$threads, jobs=$parallel_make)..."
    devcontainer exec --workspace-folder "$ws" --config "$cfg" \
        bash -i -c "source layers/hydra/meta-hydra-aepp/scripts/aepp-build-env \
            && PARALLEL_MAKE=\"$parallel_make\" BB_NUMBER_THREADS=\"$threads\" \
            bitbake ${bb_args[*]}"
}

# -----------------------------------------------------------------------------
# Tab completions
# -----------------------------------------------------------------------------
_aepp_build_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    case "$prev" in
        -c|--container)
            COMPREPLY=($(compgen -W "aarch64 linuxaepp m33" -- "$cur"))
            return ;;
        -p|--preset)
            COMPREPLY=($(compgen -W "release debug developer relwithdebinfo minsizerel" -- "$cur"))
            return ;;
    esac
    local opts="--container --preset --configure --clean --"
    local aarch64_targets="HydraSandbox IppPerformanceTest AutoUpgradeClient MockPrinter PiSwu EEpromUtil SpartaSwu BabelFishSwu JobBuffer TigerSwu IppServer ElevenSwu NovaSwu RegexValidatorPlugin"
    local linux_targets="InkJet PrintSpooler TinyCmsUtil IppServer TLS DesktopPropertyServer CrossCore NetworkConfigManager PrintJobHandler PrinterAnalytics IotManager SystemManager BlueZDriver PropertyServer BabelFish DataPipeline"
    local m33_targets="Sparta Tiger FmcTest PiHydra Eleven ProtobufProperties Nova"
    local all_targets="all $aarch64_targets $linux_targets $m33_targets"
    COMPREPLY=($(compgen -W "$opts $all_targets" -- "$cur"))
}
complete -F _aepp_build_complete aepp-build

_hydra_build_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local recipes="aepp-image-dev aepp-image aepp-image-dbg aepp-image-compliance aepp-toolchain all dcgen touchtest bradyjson bluez5 fitimage-utils hydra-version"
    local bb_flags="-c -k -e -f -C -D -n -p -S"
    local tasks="clean cleansstate compile configure fetch install listtasks package populate_sysroot"
    COMPREPLY=($(compgen -W "$recipes $bb_flags $tasks" -- "$cur"))
}
complete -F _hydra_build_complete hydra-build
