return {
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- calling `setup` is optional for customization
            local actions = require("fzf-lua.actions")
            require("fzf-lua").setup({
                -- fzf_bin         = 'sk',            -- use skim instead of fzf?
                -- https://github.com/skim-rs/skim
                -- can also be set to 'fzf-tmux'
                winopts = {
                    -- split         = "belowright new",-- open in a split instead?
                    -- "belowright new"  : split below
                    -- "aboveleft new"   : split above
                    -- "belowright vnew" : split right
                    -- "aboveleft vnew   : split left
                    -- Only valid when using a float window
                    -- (i.e. when 'split' is not defined, default)
                    height           = 0.85,            -- window height
                    width            = 0.80,            -- window width
                    row              = 0.35,            -- window row position (0=top, 1=bottom)
                    col              = 0.50,            -- window col position (0=left, 1=right)
                    -- border argument passthrough to nvim_open_win(), also used
                    -- to manually draw the border characters around the preview
                    -- window, can be set to 'false' to remove all borders or to
                    -- 'none', 'single', 'double', 'thicc' (+cc) or 'rounded' (default)
                    border           = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
                    -- Backdrop opacity, 0 is fully opaque, 100 is fully transparent (i.e. disabled)
                    backdrop         = 60,
                    -- requires neovim > v0.9.0, passed as is to `nvim_open_win`
                    -- can be sent individually to any provider to set the win title
                    -- title         = "Title",
                    -- title_pos     = "center",    -- 'left', 'center' or 'right'
                    fullscreen       = false,           -- start fullscreen?
                    -- enable treesitter highlighting for the main fzf window will only have
                    -- effect where grep like results are present, i.e. "file:line:col:text"
                    -- due to highlight color collisions will also override `fzf_colors`
                    -- set `fzf_colors=false` or `fzf_colors.hl=...` to override
                    treesitter       = {
                        enabled    = false,
                        fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" }
                    },
                    preview = {
                        -- default     = 'bat',           -- override the default previewer?
                        -- default uses the 'builtin' previewer
                        border         = 'border',        -- border|noborder, applies only to
                        -- native fzf previewers (bat/cat/git/etc)
                        wrap           = 'nowrap',        -- wrap|nowrap
                        hidden         = 'nohidden',      -- hidden|nohidden
                        vertical       = 'down:45%',      -- up|down:size
                        horizontal     = 'right:60%',     -- right|left:size
                        layout         = 'flex',          -- horizontal|vertical|flex
                        flip_columns   = 100,             -- #cols to switch to horizontal on flex
                        -- Only used with the builtin previewer:
                        title          = true,            -- preview border title (file/buf)?
                        title_pos      = "center",        -- left|center|right, title alignment
                        scrollbar      = 'float',         -- `false` or string:'float|border'
                        -- float:  in-window floating border
                        -- border: in-border "block" marker
                        scrolloff      = '-2',            -- float scrollbar offset from right
                        -- applies only when scrollbar = 'float'
                        delay          = 20,              -- delay(ms) displaying the preview
                        -- prevents lag on fast scrolling
                        winopts = {                       -- builtin previewer window options
                            number            = true,
                            relativenumber    = false,
                            cursorline        = true,
                            cursorlineopt     = 'both',
                            cursorcolumn      = false,
                            signcolumn        = 'no',
                            list              = false,
                            foldenable        = false,
                            foldmethod        = 'manual',
                        },
                    },
                    on_create = function()
                        -- called once upon creation of the fzf main window
                        -- can be used to add custom fzf-lua mappings, e.g:
                        vim.keymap.set("t", "<M-j>", "<Down>", { silent = true, buffer = true })
                        vim.keymap.set("t", "<M-k>", "<Up>", { silent = true, buffer = true })
                    end,
                    -- called once _after_ the fzf interface is closed
                    -- on_close = function() ... end
                },
                keymap = {
                    -- Below are the default binds, setting any value in these tables will override
                    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
                    builtin = {
                        false,          -- do not inherit from defaults
                        -- neovim `:tmap` mappings for the fzf win
                        ["<M-Esc>"]     = "hide",     -- hide fzf-lua, `:FzfLua resume` to continue
                        ["<F1>"]        = "toggle-help",
                        ["<F2>"]        = "toggle-fullscreen",
                        -- Only valid with the 'builtin' previewer
                        ["<F3>"]        = "toggle-preview-wrap",
                        ["<F4>"]        = "toggle-preview",
                        -- Rotate preview clockwise/counter-clockwise
                        ["<F5>"]        = "toggle-preview-ccw",
                        ["<F6>"]        = "toggle-preview-cw",
                        -- `ts-ctx` binds require `nvim-treesitter-context`
                        ["<F7>"]        = "toggle-preview-ts-ctx",
                        ["<F8>"]        = "preview-ts-ctx-dec",
                        ["<F9>"]        = "preview-ts-ctx-inc",
                        ["<S-Left>"]    = "preview-reset",
                        ["<S-down>"]    = "preview-page-down",
                        ["<S-up>"]      = "preview-page-up",
                        ["<M-S-down>"]  = "preview-down",
                        ["<M-S-up>"]    = "preview-up",
                    },
                    fzf = {
                        false,          -- do not inherit from defaults
                        -- fzf '--bind=' options
                        ["ctrl-z"]      = "abort",
                        ["ctrl-u"]      = "unix-line-discard",
                        ["ctrl-f"]      = "half-page-down",
                        ["ctrl-b"]      = "half-page-up",
                        ["ctrl-a"]      = "beginning-of-line",
                        ["ctrl-e"]      = "end-of-line",
                        ["alt-a"]       = "toggle-all",
                        ["alt-g"]       = "first",
                        ["alt-G"]       = "last",
                        -- Only valid with fzf previewers (bat/cat/git/etc)
                        ["f3"]          = "toggle-preview-wrap",
                        ["f4"]          = "toggle-preview",
                        ["shift-down"]  = "preview-page-down",
                        ["shift-up"]    = "preview-page-up",
                    },
                },
                actions = {
                    -- Below are the default actions, setting any value in these tables will override
                    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
                    files = {
                        false,          -- do not inherit from defaults
                        -- Pickers inheriting these actions:
                        --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
                        --   tags, btags, args, buffers, tabs, lines, blines
                        -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
                        -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
                        -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
                        ["enter"]       = actions.file_edit_or_qf,
                        ["ctrl-x"]      = actions.file_split,
                        ["ctrl-v"]      = actions.file_vsplit,
                        ["ctrl-t"]      = actions.file_tabedit,
                        ["alt-q"]       = actions.file_sel_to_qf,
                        ["alt-Q"]       = actions.file_sel_to_ll,
                    },
                },
                fzf_opts = {
                    -- options are sent as `<left>=<right>`
                    -- set to `false` to remove a flag
                    -- set to `true` for a no-value flag
                    -- for raw args use `fzf_args` instead
                    ["--ansi"]           = true,
                    ["--info"]           = "inline-right", -- fzf < v0.42 = "inline"
                    ["--height"]         = "100%",
                    ["--layout"]         = "reverse",
                    ["--border"]         = "none",
                    ["--highlight-line"] = true,           -- fzf >= v0.53
                },
                -- Only used when fzf_bin = "fzf-tmux", by default opens as a
                -- popup 80% width, 80% height (note `-p` requires tmux > 3.2)
                -- and removes the sides margin added by `fzf-tmux` (fzf#3162)
                -- for more options run `fzf-tmux --help`
                fzf_tmux_opts       = { ["-p"] = "80%,80%", ["--margin"] = "0,0" },
                -- 
                -- Set fzf's terminal colorscheme (optional)
                --
                -- Set to `true` to automatically generate an fzf's colorscheme from
                -- Neovim's current colorscheme:
                -- fzf_colors       = true,
                -- 
                -- Building a custom colorscheme, has the below specifications:
                -- If rhs is of type "string" rhs will be passed raw, e.g.:
                --   `["fg"] = "underline"` will be translated to `--color fg:underline`
                -- If rhs is of type "table", the following convention is used:
                --   [1] "what" field to extract from the hlgroup, i.e "fg", "bg", etc.
                --   [2] Neovim highlight group(s), can be either "string" or "table"
                --       when type is "table" the first existing highlight group is used
                --   [3+] any additional fields are passed raw to fzf's command line args
                -- Example of a "fully loaded" color option:
                --   `["fg"] = { "fg", { "NonExistentHl", "Comment" }, "underline", "bold" }`
                -- Assuming `Comment.fg=#010101` the resulting fzf command line will be:
                --   `--color fg:#010101:underline:bold`
                -- NOTE: to pass raw arguments `fzf_opts["--color"]` or `fzf_args`
                --[[ fzf_colors = {
                true,   -- inherit fzf colors that aren't specified below from
                -- the auto-generated theme similar to `fzf_colors=true`
                ["fg"]          = { "fg", "CursorLine" },
                ["bg"]          = { "bg", "Normal" },
                ["hl"]          = { "fg", "Comment" },
                ["fg+"]         = { "fg", "Normal" },
                ["bg+"]         = { "bg", "CursorLine" },
                ["hl+"]         = { "fg", "Statement" },
                ["info"]        = { "fg", "PreProc" },
                ["prompt"]      = { "fg", "Conditional" },
                ["pointer"]     = { "fg", "Exception" },
                ["marker"]      = { "fg", "Keyword" },
                ["spinner"]     = { "fg", "Label" },
                ["header"]      = { "fg", "Comment" },
                ["gutter"]      = "-1",
                }, ]]
                previewers = {
                    cat = {
                        cmd             = "cat",
                        args            = "-n",
                    },
                    bat = {
                        cmd             = "bat",
                        args            = "--color=always --style=numbers,changes",
                        -- uncomment to set a bat theme, `bat --list-themes`
                        -- theme           = 'Coldark-Dark',
                    },
                    head = {
                        cmd             = "head",
                        args            = nil,
                    },
                    git_diff = {
                        -- if required, use `{file}` for argument positioning
                        -- e.g. `cmd_modified = "git diff --color HEAD {file} | cut -c -30"`
                        cmd_deleted     = "git diff --color HEAD --",
                        cmd_modified    = "git diff --color HEAD",
                        cmd_untracked   = "git diff --color --no-index /dev/null",
                        -- git-delta is automatically detected as pager, set `pager=false`
                        -- to disable, can also be set under 'git.status.preview_pager'
                    },
                    man = {
                        -- NOTE: remove the `-c` flag when using man-db
                        -- replace with `man -P cat %s | col -bx` on OSX
                        cmd             = "man -c %s | col -bx",
                    },
                    builtin = {
                        syntax          = true,         -- preview syntax highlight?
                        syntax_limit_l  = 0,            -- syntax limit (lines), 0=nolimit
                        syntax_limit_b  = 1024*1024,    -- syntax limit (bytes), 0=nolimit
                        limit_b         = 1024*1024*10, -- preview limit (bytes), 0=nolimit
                        -- previewer treesitter options:
                        -- enable specific filetypes with: `{ enabled = { "lua" } }
                        -- exclude specific filetypes with: `{ disabled = { "lua" } }
                        -- disable `nvim-treesitter-context` with `context = false`
                        -- disable fully with: `treesitter = false` or `{ enabled = false }`
                        treesitter      = {
                            enabled = true,
                            disabled = {},
                            -- nvim-treesitter-context config options
                            context = { max_lines = 1, trim_scope = "inner" }
                        },
                        -- By default, the main window dimensions are calculated as if the
                        -- preview is visible, when hidden the main window will extend to
                        -- full size. Set the below to "extend" to prevent the main window
                        -- from being modified when toggling the preview.
                        toggle_behavior = "default",
                        -- Title transform function, by default only displays the tail
                        -- title_fnamemodify = function(s) vim.fn.fnamemodify(s, ":t") end,
                        -- preview extensions using a custom shell command:
                        -- for example, use `viu` for image previews
                        -- will do nothing if `viu` isn't executable
                        extensions      = {
                            -- neovim terminal only supports `viu` block output
                            ["png"]       = { "viu", "-b" },
                            -- by default the filename is added as last argument
                            -- if required, use `{file}` for argument positioning
                            ["svg"]       = { "chafa", "{file}" },
                            ["jpg"]       = { "ueberzug" },
                        },
                        -- if using `ueberzug` in the above extensions map
                        -- set the default image scaler, possible scalers:
                        --   false (none), "crop", "distort", "fit_contain",
                        --   "contain", "forced_cover", "cover"
                        -- https://github.com/seebye/ueberzug
                        ueberzug_scaler = "cover",
                        -- Custom filetype autocmds aren't triggered on
                        -- the preview buffer, define them here instead
                        -- ext_ft_override = { ["ksql"] = "sql", ... },
                        -- render_markdown.nvim integration, enabled by default for markdown
                        render_markdown = { enabled = true, filetypes = { ["markdown"] = true } },
                    },
                    -- Code Action previewers, default is "codeaction" (set via `lsp.code_actions.previewer`)
                    -- "codeaction_native" uses fzf's native previewer, recommended when combined with git-delta
                    codeaction = {
                        -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
                        diff_opts = { ctxlen = 3 },
                    },
                    codeaction_native = {
                        diff_opts = { ctxlen = 3 },
                        -- git-delta is automatically detected as pager, set `pager=false`
                        -- to disable, can also be set under 'lsp.code_actions.preview_pager'
                        -- recommended styling for delta
                        --pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
                    },
                },
                -- PROVIDERS SETUP
                -- use `defaults` (table or function) if you wish to set "global-provider" defaults
                -- for example, using "mini.icons" globally and open the quickfix list at the top
                --   defaults = {
                --     file_icons   = "mini",
                --     copen        = "topleft copen",
                --   },
                files = {
                    -- previewer      = "bat",          -- uncomment to override previewer
                    -- (name from 'previewers' table)
                    -- set to 'false' to disable
                    prompt            = 'Files❯ ',
                    multiprocess      = true,           -- run command in a separate process
                    git_icons         = true,           -- show git icons?
                    file_icons        = true,           -- show file icons (true|"devicons"|"mini")?
                    color_icons       = true,           -- colorize file|git icons
                    -- path_shorten   = 1,              -- 'true' or number, shorten path?
                    -- Uncomment for custom vscode-like formatter where the filename is first:
                    -- e.g. "fzf-lua/previewer/fzf.lua" => "fzf.lua previewer/fzf-lua"
                    formatter      = "path.filename_first",
                    -- executed command priority is 'cmd' (if exists)
                    -- otherwise auto-detect prioritizes `fd`:`rg`:`find`
                    -- default options are controlled by 'fd|rg|find|_opts'
                    -- NOTE: 'find -printf' requires GNU find
                    -- cmd            = "find . -type f -printf '%P\n'",
                    find_opts         = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
                    rg_opts           = [[--color=never --files --hidden --follow -g "!.git"]],
                    fd_opts           = [[--color=never --type f --hidden --follow --exclude .git]],
                    -- by default, cwd appears in the header only if {opts} contain a cwd
                    -- parameter to a different folder than the current working directory
                    -- uncomment if you wish to force display of the cwd as part of the
                    -- query prompt string (fzf.vim style), header line or both
                    -- cwd_header = true,
                    cwd_prompt             = false,
                    cwd_prompt_shorten_len = 32,        -- shorten prompt beyond this length
                    cwd_prompt_shorten_val = 0,         -- shortened path parts length
                    toggle_ignore_flag = "--no-ignore", -- flag toggled in `actions.toggle_ignore`
                    toggle_hidden_flag = "--hidden",    -- flag toggled in `actions.toggle_hidden`
                    actions = {
                        -- inherits from 'actions.files', here we can override
                        -- or set bind to 'false' to disable a default action
                        -- action to toggle `--no-ignore`, requires fd or rg installed
                        ["ctrl-g"]         = { actions.toggle_ignore },
                        -- uncomment to override `actions.file_edit_or_qf`
                        --   ["enter"]     = actions.file_edit,
                        -- custom actions are available too
                        --   ["ctrl-y"]    = function(selected) print(selected[1]) end,
                    }
                },
                git = {
                    files = {
                        prompt        = 'GitFiles❯ ',
                        cmd           = 'git ls-files --exclude-standard',
                        multiprocess  = true,           -- run command in a separate process
                        git_icons     = true,           -- show git icons?
                        file_icons    = true,           -- show file icons (true|"devicons"|"mini")?
                        color_icons   = true,           -- colorize file|git icons
                        -- force display the cwd header line regardless of your current working
                        -- directory can also be used to hide the header when not wanted
                        -- cwd_header = true
                    },
                    status = {
                        prompt        = 'GitStatus❯ ',
                        cmd           = "git -c color.status=false --no-optional-locks status --porcelain=v1 -u",
                        multiprocess  = true,           -- run command in a separate process
                        file_icons    = true,
                        git_icons     = true,
                        color_icons   = true,
                        previewer     = "git_diff",
                        -- git-delta is automatically detected as pager, uncomment to disable
                        -- preview_pager = false,
                        actions = {
                            -- actions inherit from 'actions.files' and merge
                            ["right"]  = { fn = actions.git_unstage, reload = true },
                            ["left"]   = { fn = actions.git_stage, reload = true },
                            ["ctrl-x"] = { fn = actions.git_reset, reload = true },
                        },
                        -- If you wish to use a single stage|unstage toggle instead
                        -- using 'ctrl-s' modify the 'actions' table as shown below
                        -- actions = {
                        --   ["right"]   = false,
                        --   ["left"]    = false,
                        --   ["ctrl-x"]  = { fn = actions.git_reset, reload = true },
                        --   ["ctrl-s"]  = { fn = actions.git_stage_unstage, reload = true },
                        -- },
                    },
                    commits = {
                        prompt        = 'Commits❯ ',
                        cmd           = [[git log --color --pretty=format:"%C(yellow)%h%Creset ]]
                        .. [[%Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset"]],
                        preview       = "git show --color {1}",
                        -- git-delta is automatically detected as pager, uncomment to disable
                        -- preview_pager = false,
                        actions = {
                            ["enter"]   = actions.git_checkout,
                            -- remove `exec_silent` or set to `false` to exit after yank
                            ["ctrl-y"]  = { fn = actions.git_yank_commit, exec_silent = true },
                        },
                    },
                    bcommits = {
                        prompt        = 'BCommits❯ ',
                        -- default preview shows a git diff vs the previous commit
                        -- if you prefer to see the entire commit you can use:
                        --   git show --color {1} --rotate-to={file}
                        --   {1}    : commit SHA (fzf field index expression)
                        --   {file} : filepath placement within the commands
                        cmd           = [[git log --color --pretty=format:"%C(yellow)%h%Creset ]]
                        .. [[%Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset" {file}]],
                        preview       = "git show --color {1} -- {file}",
                        -- git-delta is automatically detected as pager, uncomment to disable
                        -- preview_pager = false,
                        actions = {
                            ["enter"]   = actions.git_buf_edit,
                            ["ctrl-s"]  = actions.git_buf_split,
                            ["ctrl-v"]  = actions.git_buf_vsplit,
                            ["ctrl-t"]  = actions.git_buf_tabedit,
                            ["ctrl-y"]  = { fn = actions.git_yank_commit, exec_silent = true },
                        },
                    },
                    blame = {
                        prompt        = "Blame> ",
                        cmd           = [[git blame --color-lines {file}]],
                        preview       = "git show --color {1} -- {file}",
                        -- git-delta is automatically detected as pager, uncomment to disable
                        -- preview_pager = false,
                        actions = {
                            ["enter"]  = actions.git_goto_line,
                            ["ctrl-s"] = actions.git_buf_split,
                            ["ctrl-v"] = actions.git_buf_vsplit,
                            ["ctrl-t"] = actions.git_buf_tabedit,
                            ["ctrl-y"] = { fn = actions.git_yank_commit, exec_silent = true },
                        },
                    },
                    branches = {
                        prompt   = 'Branches❯ ',
                        cmd      = "git branch --all --color",
                        preview  = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
                        actions  = {
                            ["enter"]   = actions.git_switch,
                            ["ctrl-x"]  = { fn = actions.git_branch_del, reload = true },
                            ["ctrl-a"]  = { fn = actions.git_branch_add, field_index = "{q}", reload = true },
                        },
                        -- If you wish to add branch and switch immediately
                        -- cmd_add  = { "git", "checkout", "-b" },
                        cmd_add  = { "git", "branch" },
                        -- If you wish to delete unmerged branches add "--force"
                        -- cmd_del  = { "git", "branch", "--delete", "--force" },
                        cmd_del  = { "git", "branch", "--delete" },
                    },
                    tags = {
                        prompt   = "Tags> ",
                        cmd      = [[git for-each-ref --color --sort="-taggerdate" --format ]]
                        .. [["%(color:yellow)%(refname:short)%(color:reset) ]]
                        .. [[%(color:green)(%(taggerdate:relative))%(color:reset)]]
                        .. [[ %(subject) %(color:blue)%(taggername)%(color:reset)" refs/tags]],
                        preview  = [[git log --graph --color --pretty=format:"%C(yellow)%h%Creset ]]
                        .. [[%Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset" {1}]],
                        actions  = { ["enter"] = actions.git_checkout },
                    },
                    stash = {
                        prompt          = 'Stash> ',
                        cmd             = "git --no-pager stash list",
                        preview         = "git --no-pager stash show --patch --color {1}",
                        actions = {
                            ["enter"]     = actions.git_stash_apply,
                            ["ctrl-x"]    = { fn = actions.git_stash_drop, reload = true },
                        },
                    },
                    icons = {
                        ["M"]           = { icon = "M", color = "yellow" },
                        ["D"]           = { icon = "D", color = "red" },
                        ["A"]           = { icon = "A", color = "green" },
                        ["R"]           = { icon = "R", color = "yellow" },
                        ["C"]           = { icon = "C", color = "yellow" },
                        ["T"]           = { icon = "T", color = "magenta" },
                        ["?"]           = { icon = "?", color = "magenta" },
                        -- override git icons?
                        -- ["M"]        = { icon = "★", color = "red" },
                        -- ["D"]        = { icon = "✗", color = "red" },
                        -- ["A"]        = { icon = "+", color = "green" },
                    },
                },
                grep = {
                    prompt            = 'Rg❯ ',
                    input_prompt      = 'Grep For❯ ',
                    multiprocess      = true,           -- run command in a separate process
                    git_icons         = true,           -- show git icons?
                    file_icons        = true,           -- show file icons (true|"devicons"|"mini")?
                    color_icons       = true,           -- colorize file|git icons
                    -- executed command priority is 'cmd' (if exists)
                    -- otherwise auto-detect prioritizes `rg` over `grep`
                    -- default options are controlled by 'rg|grep_opts'
                    -- cmd            = "rg --vimgrep",
                    grep_opts         = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
                    rg_opts           = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
                    -- Uncomment to use the rg config file `$RIPGREP_CONFIG_PATH`
                    -- RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH
                    --
                    -- Set to 'true' to always parse globs in both 'grep' and 'live_grep'
                    -- search strings will be split using the 'glob_separator' and translated
                    -- to '--iglob=' arguments, requires 'rg'
                    -- can still be used when 'false' by calling 'live_grep_glob' directly
                    rg_glob           = false,        -- default to glob parsing?
                    glob_flag         = "--iglob",    -- for case sensitive globs use '--glob'
                    glob_separator    = "%s%-%-",     -- query separator pattern (lua): ' --'
                    -- advanced usage: for custom argument parsing define
                    -- 'rg_glob_fn' to return a pair:
                    --   first returned argument is the new search query
                    --   second returned argument are additional rg flags
                    -- rg_glob_fn = function(query, opts)
                    --   ...
                    --   return new_query, flags
                    -- end,
                    --
                    -- Enable with narrow term width, split results to multiple lines
                    -- NOTE: multiline requires fzf >= v0.53 and is ignored otherwise
                    -- multiline      = 1,      -- Display as: PATH:LINE:COL\nTEXT
                    -- multiline      = 2,      -- Display as: PATH:LINE:COL\nTEXT\n
                    actions = {
                        -- actions inherit from 'actions.files' and merge
                        -- this action toggles between 'grep' and 'live_grep'
                        ["ctrl-g"]      = { actions.grep_lgrep },
                        -- uncomment to enable '.gitignore' toggle for grep
                        ["ctrl-r"]   = { actions.toggle_ignore }
                    },
                    no_header             = false,    -- hide grep|cwd header?
                    no_header_i           = false,    -- hide interactive header?
                },
                args = {
                    prompt            = 'Args❯ ',
                    files_only        = true,
                    -- actions inherit from 'actions.files' and merge
                    actions           = { ["ctrl-x"] = { fn = actions.arg_del, reload = true } },
                },
                oldfiles = {
                    prompt            = 'History❯ ',
                    cwd_only          = false,
                    stat_file         = true,         -- verify files exist on disk
                    -- can also be a lua function, for example:
                    -- stat_file = require("fzf-lua").utils.file_is_readable,
                    -- stat_file = function() return true end,
                    include_current_session = false,  -- include bufs from current session
                },
                buffers = {
                    prompt            = 'Buffers❯ ',
                    file_icons        = true,         -- show file icons (true|"devicons"|"mini")?
                    color_icons       = true,         -- colorize file|git icons
                    sort_lastused     = true,         -- sort buffers() by last used
                    show_unloaded     = true,         -- show unloaded buffers
                    cwd_only          = false,        -- buffers for the cwd only
                    cwd               = nil,          -- buffers list for a given dir
                    actions = {
                        -- actions inherit from 'actions.files' and merge
                        -- by supplying a table of functions we're telling
                        -- fzf-lua to not close the fzf window, this way we
                        -- can resume the buffers picker on the same window
                        -- eliminating an otherwise unaesthetic win "flash"
                        ["ctrl-x"]      = { fn = actions.buf_del, reload = true },
                    }
                },
                tabs = {
                    prompt            = 'Tabs❯ ',
                    tab_title         = "Tab",
                    tab_marker        = "<<",
                    file_icons        = true,         -- show file icons (true|"devicons"|"mini")?
                    color_icons       = true,         -- colorize file|git icons
                    actions = {
                        -- actions inherit from 'actions.files' and merge
                        ["enter"]       = actions.buf_switch,
                        ["ctrl-x"]      = { fn = actions.buf_del, reload = true },
                    },
                    fzf_opts = {
                        -- hide tabnr
                        ["--delimiter"] = "[\\):]",
                        ["--with-nth"]  = '2..',
                    },
                },
                -- `blines` has the same defaults as `lines` aside from prompt and `show_bufname`
                lines = {
                    prompt            = 'Lines❯ ',
                    file_icons        = true,
                    show_bufname      = true,         -- display buffer name
                    show_unloaded     = true,         -- show unloaded buffers
                    show_unlisted     = false,        -- exclude 'help' buffers
                    no_term_buffers   = true,         -- exclude 'term' buffers
                    sort_lastused     = true,         -- sort by most recent
                    winopts  = { treesitter = true }, -- enable TS highlights
                    fzf_opts = {
                        -- do not include bufnr in fuzzy matching
                        -- tiebreak by line no.
                        ["--multi"]     = true,
                        ["--delimiter"] = "[\t]",
                        ["--tabstop"]   = "1",
                        ["--tiebreak"]  = "index",
                        ["--with-nth"]  = "2..",
                        ["--nth"]       = "4..",
                    },
                },
                tags = {
                    prompt                = 'Tags❯ ',
                    ctags_file            = nil,      -- auto-detect from tags-option
                    multiprocess          = true,
                    file_icons            = true,
                    git_icons             = true,
                    color_icons           = true,
                    -- 'tags_live_grep' options, `rg` prioritizes over `grep`
                    rg_opts               = "--no-heading --color=always --smart-case",
                    grep_opts             = "--color=auto --perl-regexp",
                    fzf_opts              = { ["--tiebreak"] = "begin" },
                    actions = {
                        -- actions inherit from 'actions.files' and merge
                        -- this action toggles between 'grep' and 'live_grep'
                        ["ctrl-g"]          = { actions.grep_lgrep }
                    },
                    no_header             = false,    -- hide grep|cwd header?
                    no_header_i           = false,    -- hide interactive header?
                },
                btags = {
                    prompt                = 'BTags❯ ',
                    ctags_file            = nil,      -- auto-detect from tags-option
                    ctags_autogen         = true,     -- dynamically generate ctags each call
                    multiprocess          = true,
                    file_icons            = false,
                    git_icons             = false,
                    rg_opts               = "--color=never --no-heading",
                    grep_opts             = "--color=never --perl-regexp",
                    fzf_opts              = { ["--tiebreak"] = "begin" },
                    -- actions inherit from 'actions.files'
                },
                colorschemes = {
                    prompt            = 'Colorschemes❯ ',
                    live_preview      = true,       -- apply the colorscheme on preview?
                    actions           = { ["enter"] = actions.colorscheme },
                    winopts           = { height = 0.55, width = 0.30, },
                    -- uncomment to ignore colorschemes names (lua patterns)
                    -- ignore_patterns   = { "^delek$", "^blue$" },
                    -- uncomment to execute a callback on preview|close
                    -- e.g. a call to reset statusline highlights
                    -- cb_preview        = function() ... end,
                    -- cb_exit           = function() ... end,
                },
                awesome_colorschemes = {
                    prompt            = 'Colorschemes❯ ',
                    live_preview      = true,       -- apply the colorscheme on preview?
                    max_threads       = 5,          -- max download/update threads
                    winopts           = { row = 0, col = 0.99, width = 0.50 },
                    fzf_opts          = {
                        ["--multi"]     = true,
                        ["--delimiter"] = "[:]",
                        ["--with-nth"]  = "3..",
                        ["--tiebreak"]  = "index",
                    },
                    actions           = {
                        ["enter"]   = actions.colorscheme,
                        ["ctrl-g"]  = { fn = actions.toggle_bg, exec_silent = true },
                        ["ctrl-r"]  = { fn = actions.cs_update, reload = true },
                        ["ctrl-x"]  = { fn = actions.cs_delete, reload = true },
                    },
                    -- uncomment to execute a callback on preview|close
                    -- cb_preview        = function() ... end,
                    -- cb_exit           = function() ... end,
                },
                keymaps = {
                    prompt            = "Keymaps> ",
                    winopts           = { preview = { layout = "vertical" } },
                    fzf_opts          = { ["--tiebreak"] = "index", },
                    -- by default, we ignore <Plug> and <SNR> mappings
                    -- set `ignore_patterns = false` to disable filtering
                    ignore_patterns   = { "^<SNR>", "^<Plug>" },
                    show_desc         = true,
                    show_details      = true,
                    actions           = {
                        ["enter"]       = actions.keymap_apply,
                        ["ctrl-s"]      = actions.keymap_split,
                        ["ctrl-v"]      = actions.keymap_vsplit,
                        ["ctrl-t"]      = actions.keymap_tabedit,
                    },
                },
                quickfix = {
                    file_icons        = true,
                    git_icons         = true,
                    only_valid        = false, -- select among only the valid quickfix entries
                },
                quickfix_stack = {
                    prompt = "Quickfix Stack> ",
                    marker = ">",                   -- current list marker
                },
                lsp = {
                    prompt_postfix    = '❯ ',       -- will be appended to the LSP label
                    -- to override use 'prompt' instead
                    cwd_only          = false,      -- LSP/diagnostics for cwd only?
                    async_or_timeout  = 5000,       -- timeout(ms) or 'true' for async calls
                    file_icons        = true,
                    git_icons         = false,
                    -- The equivalent of using `includeDeclaration` in lsp buf calls, e.g:
                    -- :lua vim.lsp.buf.references({includeDeclaration = false})
                    includeDeclaration = true,      -- include current declaration in LSP context
                    -- settings for 'lsp_{document|workspace|lsp_live_workspace}_symbols'
                    symbols = {
                        async_or_timeout  = true,       -- symbols are async by default
                        symbol_style      = 1,          -- style for document/workspace symbols
                        -- false: disable,    1: icon+kind
                        --     2: icon only,  3: kind only
                        -- NOTE: icons are extracted from
                        -- vim.lsp.protocol.CompletionItemKind
                        -- icons for symbol kind
                        -- see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
                        -- see https://github.com/neovim/neovim/blob/829d92eca3d72a701adc6e6aa17ccd9fe2082479/runtime/lua/vim/lsp/protocol.lua#L117
                        symbol_icons     = {
                            File          = "󰈙",
                            Module        = "",
                            Namespace     = "󰦮",
                            Package       = "",
                            Class         = "󰆧",
                            Method        = "󰊕",
                            Property      = "",
                            Field         = "",
                            Constructor   = "",
                            Enum          = "",
                            Interface     = "",
                            Function      = "󰊕",
                            Variable      = "󰀫",
                            Constant      = "󰏿",
                            String        = "",
                            Number        = "󰎠",
                            Boolean       = "󰨙",
                            Array         = "󱡠",
                            Object        = "",
                            Key           = "󰌋",
                            Null          = "󰟢",
                            EnumMember    = "",
                            Struct        = "󰆼",
                            Event         = "",
                            Operator      = "󰆕",
                            TypeParameter = "󰗴",
                        },
                        -- colorize using Treesitter '@' highlight groups ("@function", etc).
                        -- or 'false' to disable highlighting
                        symbol_hl         = function(s) return "@" .. s:lower() end,
                        -- additional symbol formatting, works with or without style
                        symbol_fmt        = function(s, opts) return "[" .. s .. "]" end,
                        -- prefix child symbols. set to any string or `false` to disable
                        child_prefix      = true,
                        fzf_opts          = { ["--tiebreak"] = "begin" },
                    },
                    code_actions = {
                        prompt            = 'Code Actions> ',
                        async_or_timeout  = 5000,
                        -- when git-delta is installed use "codeaction_native" for beautiful diffs
                        -- try it out with `:FzfLua lsp_code_actions previewer=codeaction_native`
                        -- scroll up to `previewers.codeaction{_native}` for more previewer options
                        previewer        = "codeaction",
                    },
                    finder = {
                        prompt      = "LSP Finder> ",
                        file_icons  = true,
                        color_icons = true,
                        git_icons   = false,
                        async       = true,         -- async by default
                        silent      = true,         -- suppress "not found" 
                        separator   = "| ",         -- separator after provider prefix, `false` to disable
                        includeDeclaration = true,  -- include current declaration in LSP context
                        -- by default display all LSP locations
                        -- to customize, duplicate table and delete unwanted providers
                        providers   = {
                            { "references",      prefix = require("fzf-lua").utils.ansi_codes.blue("ref ") },
                            { "definitions",     prefix = require("fzf-lua").utils.ansi_codes.green("def ") },
                            { "declarations",    prefix = require("fzf-lua").utils.ansi_codes.magenta("decl") },
                            { "typedefs",        prefix = require("fzf-lua").utils.ansi_codes.red("tdef") },
                            { "implementations", prefix = require("fzf-lua").utils.ansi_codes.green("impl") },
                            { "incoming_calls",  prefix = require("fzf-lua").utils.ansi_codes.cyan("in  ") },
                            { "outgoing_calls",  prefix = require("fzf-lua").utils.ansi_codes.yellow("out ") },
                        },
                    }
                },
                diagnostics ={
                    prompt            = 'Diagnostics❯ ',
                    cwd_only          = false,
                    file_icons        = true,
                    git_icons         = false,
                    diag_icons        = true,
                    diag_source       = true,   -- display diag source (e.g. [pycodestyle])
                    icon_padding      = '',     -- add padding for wide diagnostics signs
                    multiline         = true,   -- concatenate multi-line diags into a single line
                    -- set to `false` to display the first line only
                    -- by default icons and highlights are extracted from 'DiagnosticSignXXX'
                    -- and highlighted by a highlight group of the same name (which is usually
                    -- set by your colorscheme, for more info see:
                    --   :help DiagnosticSignHint'
                    --   :help hl-DiagnosticSignHint'
                    -- only uncomment below if you wish to override the signs/highlights
                    -- define only text, texthl or both (':help sign_define()' for more info)
                    -- signs = {
                    --   ["Error"] = { text = "", texthl = "DiagnosticError" },
                    --   ["Warn"]  = { text = "", texthl = "DiagnosticWarn" },
                    --   ["Info"]  = { text = "", texthl = "DiagnosticInfo" },
                    --   ["Hint"]  = { text = "󰌵", texthl = "DiagnosticHint" },
                    -- },
                    -- limit to specific severity, use either a string or num:
                    --   1 or "hint"
                    --   2 or "information"
                    --   3 or "warning"
                    --   4 or "error"
                    -- severity_only:   keep any matching exact severity
                    -- severity_limit:  keep any equal or more severe (lower)
                    -- severity_bound:  keep any equal or less severe (higher)
                },
                marks = {
                    marks = "", -- filter vim marks with a lua pattern
                    -- for example if you want to only show user defined marks
                    -- you would set this option as %a this would match characters from [A-Za-z]
                    -- or if you want to show only numbers you would set the pattern to %d (0-9).
                },
                complete_path = {
                    cmd          = nil, -- default: auto detect fd|rg|find
                    complete     = { ["enter"] = actions.complete },
                },
                complete_file = {
                    cmd          = nil, -- default: auto detect rg|fd|find
                    file_icons   = true,
                    color_icons  = true,
                    git_icons    = false,
                    -- actions inherit from 'actions.files' and merge
                    actions      = { ["enter"] = actions.complete },
                    -- previewer hidden by default
                    winopts      = { preview = { hidden = "hidden" } },
                },
                -- uncomment to use fzf native previewers
                -- (instead of using a neovim floating window)
                -- manpages = { previewer = "man_native" },
                -- helptags = { previewer = "help_native" },
                -- 
                -- padding can help kitty term users with double-width icon rendering
                file_icon_padding = '',
                -- uncomment if your terminal/font does not support unicode character
                -- 'EN SPACE' (U+2002), the below sets it to 'NBSP' (U+00A0) instead
                -- nbsp = '\xc2\xa0',
            })
        end
    }
}
