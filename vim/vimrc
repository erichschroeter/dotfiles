""""""
" UI "
""""""

" disable vi compatibility
set nocompatible

" automatically load changed files
set autoread

" auto-reload vimrc
autocmd! bufwritepost vimrc source ~/.vim/vimrc
"autocmd! bufwritepost gvimrc source ~/.vim/gvimrc

" show the filename in the window titlebar
set title

" set encoding
set encoding=utf-8

" directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backupf
set nobackup                    " Don't pollute file system with duplicate files

" mouse support
set mouse=a

" wrapping stuff
set textwidth=80
set colorcolumn=80

" ignore whitespace in diff mode
set diffopt+=iwhite

" Be able to arrow key and backspace across newlines
set whichwrap=bs<>[]

" Status bar
set laststatus=2

" remember last cursor position
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\ 	exe "normal g`\"" |
	\ endif

" show '>   ' at the beginning of lines that are automatically wrapped
set showbreak=>\ \ \ 

" enable completion
set ofu=syntaxcomplete#Complete

" make laggy connections work faster
set ttyfast

" let vim open up to 100 tabs at once
set tabpagemax=100

" case-insensitive filename completion
set wildignorecase


" General
set nocompatible                " Use Vim defaults (much better!)
set number                      " Show line numbers
set relativenumber
setglobal relativenumber
set linebreak                   " Break lines at word (requires Wrap lines)
set showbreak=+++               " Wrap-broken line prefix
set textwidth=100               " Line wrap (number of cols)
set showmatch                   " Highlight matching brace
set showcmd                     " display incomplete commands at the bottom
set visualbell                  " Use visual bell (no beeping)
set cursorline                  " highlight cursor line

"""""""""""""
" Searching "
"""""""""""""

set hlsearch    " when there is a previous search pattern, highlight all its matches
set incsearch   " while typing a search command, show immediately where the so far typed pattern matches
set ignorecase  " ignore case in search patterns
set smartcase   " override the 'ignorecase' option if the search pattern contains uppercase characters
set gdefault    " imply global for new searches


"""""""""""""
" Indenting "
"""""""""""""

" When auto-indenting, use the indenting format of the previous line
set copyindent
" When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'.
" 'tabstop' is used in other places. A <BS> will delete a 'shiftwidth' worth of
" space at the start of the line.
set smarttab
" Copy indent from current line when starting a new line (typing <CR> in Insert
" mode or when using the "o" or "O" command)
set autoindent
" Automatically inserts one extra level of indentation in some cases, and works
" for C-like files
set smartindent

 
" Advanced
set ruler                       " Show row and column ruler information
set history=50                  " keep 50 lines of command line history
set undolevels=1000             " Number of undo levels
set backspace=indent,eol,start  " allow backspacing over everything in insert mode

" make laggy connections work faster
set ttyfast

" let vim open up to 100 tabs at once
set tabpagemax=100

" case-insensitive filename completion
set wildignorecase
 

"""""""""
" Theme "
"""""""""

syntax enable
"set background=dark " uncomment this if your terminal has a dark background
let g:solarized_termcolors=256
"colorscheme solarized
"colorscheme cobalt2
"colorscheme vividchalk
colorscheme railscasts

" Change color after 80 characters
"match Error '\%>80v.\+'

""""""""
" GVim "
""""""""

"disable cursor blinking
set gcr=n:blinkon0
" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
" let &guicursor = &guicursor . ",a:blinkon0"

"remove menu bar
set guioptions-=m


" Folding
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=256
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Map Ctrl + hjkl keys to navigate between split windows
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" Whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
" Show trailing whitespace:
match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()

" Show highlighting groups for current word
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
