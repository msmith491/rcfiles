set nocompatible              " be iMproved, required
filetype off                  " required

set tabstop=4           " Set number of spaces that tabs count for
set shiftwidth=4        " Set autoindent level to 4 spaces
set expandtab           " Change all tabs to spaces

set scrolloff=3         " keep 3 lines when scrolling
set ai                  " set auto-indenting on for programming

set showcmd             " display incomplete commands
set nobackup            " do not keep a backup file
set number              " show line numbers
set relativenumber      " line numbers are relative to current position
set ruler               " show the current row and column
set colorcolumn=79      " Show the 79 character cutoff marker
set nowrap              " Don't wrap lines by default

set hlsearch            " highlight searches
set incsearch           " do incremental searching
set showmatch           " jump to matches when entering regexp
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase char present

set visualbell t_vb=    " turn off error beep/flash
set novisualbell        " turn off visual bell
set wildignore+=*.pyc,*.swp     " Filter these filetypes from the file search functions
set splitright          " Vertical splits go to the right by default
set splitbelow          " Horizontal splits go below by default

set backspace=indent,eol,start  " make that backspace key work the way it should

syntax on               " turn syntax highlighting on by default
filetype on             " detect type of file
filetype indent on      " load indent file for specific file type

" Fix backspace/delete key issues
set backspace=indent,eol,start      " Setting backspace to behave in a sane fashion
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+   " Show visible characters for whitespace
set list    " Also necessary for visible trailing whitespace

" Esc alternative for Dvorak users.  QWERTY folks should use jk or kj
inoremap tn <Esc>
set timeoutlen=300

"""""""""""""""""""""""""""""""""""
""""""Neovim Specific Settings""""""
"""""""""""""""""""""""""""""""""""
if has('nvim')
    " Increase terminal buffer 10x
    let g:terminal_scrollback_buffer_size = 10000
    let g:python_host_prog=$HOME . "/venvs/neovim/bin/python"     " Ensure neovim is always using its own virtualenv
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1     " Force use of I-bar for insert mode
endif
"""""""""""""""""""""""""""""""""""

" Setting leader key based mappings
let mapleader=","
let maplocalleader=";"
" Easy buffer switching `,b<num>`
noremap <Leader>b :buffers<CR>:buffer<Space>

" Spellcheck shortcuts
" Quick spelling fix
noremap <Leader>f 1z=
" Toggle Highlighting
noremap <Leader>s :set spell!
" Quick Search
noremap <Leader>K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" Delete all trailing whitespace
noremap <Leader>ds :try<CR> :%s/\s\+$//<CR> :let @/ = ''<CR> :catch<CR> :let @/ = ''<CR> :endtry<CR><CR>
" Easy Reload nvimrc
noremap <Leader>rv :source $MYVIMRC<CR>
" Easy Neovim Terminal Split
noremap <Leader>gt :vsp term://zsh<CR> i
" Easy Split Switch From Neovim Terminal Insert Mode
tnoremap <Leader>e <C-\><C-n><C-w><C-w>
" """""""""""""""""""""""""""""""""

" Auto install vim-plug for plugin management
if empty(glob('~/.config/nvim/autoload/plug.vim'))
      silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall
endif

""""""""""""""""""""""""""""""""""""""""
"""""""""" START PLUGINS """""""""""""""
""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')

" Better python syntax highlighting
Plug 'msmith491/python-syntax'
let g:python_highlight_all = 1

" YouCompleteMe Autocompletion plugin
" Requires cmake package
" You will need to run the install.py file in ~/.nvim/plugged/YouCompleteMe
Plug 'Valloric/YouCompleteMe'
autocmd! User YouCompleteMe call youcompleteme#Enable()
autocmd CompleteDone * pclose
nnoremap <Leader>jd :YcmCompleter GoTo<CR>
nnoremap <Leader>gd :YcmCompleter GetDoc<CR>

" Theme
Plug 'freeo/vim-kalisi'
set background=dark

" Shows git file changes to the left of line numbers
Plug 'airblade/vim-gitgutter'
let g:gitgutter_sign_column_always = 1

" Amazing ctrl-p fuzzy searching plugin with better engine
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
let g:ctrlp_max_files=0
let g:ctrlp_follow_symlinks=1
if has('python') || has('python3')
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

" If ag search is available, use that.  It's much faster than grep
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
    " Set ctrlp to use ag instead of grep
    " Using the `-u` flag to search in hidden files as well
    let g:ctrlp_user_command = 'ag %s -l -u --nocolor -g "" | ag -v "\.git"'
    let g:ctrlp_use_caching = 0
endif

" Better file browser
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>

" Function definitions in their own window
Plug 'majutsushi/tagbar'
" Accessible via `tb` shortcut
:nnoremap tb :TagbarToggle<CR>
" Autoinstalling exhuberent ctags so tagbar will function
if !executable('ctags')
    silent !mkdir ~/ctags
    silent !wget -O ~/ctags/ctags-5.8.tar.gz sourceforge.net/projects/ctags/files/ctags/5.8/ctags-5.8.tar.gz
    silent !tar -xzvf ~/ctags/ctags-5.8.tar.gz
    cd ~/ctags/ctags-5.8
    silent !./configure
    silent !make
    silent !sudo make install
    echo('You still need to run ./configure, make and sudo make install for ctags in your home directory')
    echo("Otherwise tagbar won't work")
endif
let g:tagbar_ctags_bin='/usr/local/bin/ctags'
let g:tagbar_autofocus=1

""""""""""""""""""""""""""""""""""""""""
"""""""""" Hail To The Tpope """""""""""
""""""""""""""""""""""""""""""""""""""""
" Git integration
Plug 'tpope/vim-fugitive'
" Multiline comments via `gc` shortcut
Plug 'tpope/vim-commentary'
" Surround helper
Plug 'tpope/vim-surround'
" Date helper
Plug 'tpope/vim-speeddating'
"""""""""""""""""""""""""""""""""""""""

" Auto Flake8 checks on file write
Plug 'andviro/flake8-vim'
let g:PyFlakeOnWrite = 1
let g:PyFlakeDisableMessages = ''
let g:PyFlakeCheckers = 'pep8,mccabe,frosted'
let g:PyFlakeDefaultComplexity=10
let g:PyFlakeSigns = 1
let g:PyFlakeMaxLineLength = 79
let g:PyFlakeAggressive = 5

" Virtualenv integration, useful for YouCompleteMe autocompletion
Plug 'jmcantrell/vim-virtualenv'
let g:virtualenv_directory = '~/venvs'
if !isdirectory(glob('~/venvs')) && has('nvim')
     silent !mkdir ~/venvs
     silent !virtualenv ~/venvs/neovim
     silent !python ~/venvs/neovim/bin/pip install neovim
endif

Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

Plug 'Glench/Vim-Jinja2-Syntax'

""""""""""""""""""""""""""""""""""""""""
"""""" Plugins Only I Care About """""""
""""""""""""""""""""""""""""""""""""""""
if has('nvim')
    " Lisp plugin
    Plug 'kovisoft/slimv'
    " Dlang Autocomplete/GoTo def
    Plug 'Hackerpilot/DCD'
    Plug 'idanarye/vim-dutyl'
    let g:dutyl_stdImportPaths=['/usr/local/Cellar/dmd/2.069.1/include/d2/']
    autocmd FileType d nnoremap <Leader>gd :DUddoc<CR>
    autocmd FileType d nnoremap <Leader>jd :DUjump<CR>
endif

call plug#end()

""""""""""""""""""""""""""""""""""""""""
"""""""""" END PLUGINS  """"""""""""""""
""""""""""""""""""""""""""""""""""""""""
colorscheme kalisi

""""""""""""""""""""""""""""""""""""""""
""""""" Stuff Only I Care About """"""""
""""""""""""""""""""""""""""""""""""""""
" Dlang settings and servers
if has('nvim')
    " Update Dlang autocomplete client/server locations
    call dutyl#register#tool('dcd-client',$HOME . '/.config/nvim/plugged/DCD/bin/dcd-client')
    call dutyl#register#tool('dcd-server',$HOME . '/.config/nvim/plugged/DCD/bin/dcd-server')

    function StartDCD()
        let testvar = system('ps -ef | grep dcd-server | grep -v grep')
        if testvar == ''
            let server = 'tmux new -s dcd-server -d "' . $HOME . '/.config/nvim/plugged/DCD/bin/dcd-server -I /usr/local/Cellar/dmd/2.069.1/include/d2/"'
            exec "!" . server
        endif
    endfunction

    autocmd FileType d call StartDCD()
endif
