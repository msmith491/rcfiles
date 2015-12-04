set nocompatible              " be iMproved, required
filetype off                  " required

let g:python_host_prog=$HOME . "/venvs/neovim/bin/python"     " Ensure neovim is always using its own virtualenv

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1     " Force use of I-bar for insert mode

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

set backspace=indent,eol,start  " make that backspace key work the way it should
set rtp+=~/.nvim    " Ensure .nvim folder is at the head of the runtime path
set rtp+=$VIMRUNTIME

syntax on               " turn syntax highlighting on by default
filetype on             " detect type of file
filetype indent on      " load indent file for specific file type

colorscheme delek
"set t_RV=               " http://bugs.debian.org/608242, http://groups.google.com/group/vim_dev/browse_thread/thread/9770ea844cec3282et number
" Fix backspace/delete key issues
set backspace=indent,eol,start      " Setting backspace to behave in a sane fashion
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+   " Show visible characters for whitespace
set list    " Also necessary for visible trailing whitespace

" Esc alternative for Dvorak users.  QWERTY folks should use jk or kj
inoremap tn <Esc>

"""""""""""""""""""""""""""""""""""
" Setting leader key based mappings
let mapleader=","
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
" """""""""""""""""""""""""""""""""

if empty(glob('~/.nvim/spell')) " Setup spellcheck for English.  Can be enabled via `:set spell`
    silent !mkdir ~/.nvim/spell
    silent !wget -O ~/.nvim/spell/en.ascii.spl http://ftp.vim.org/vim/runtime/spell/en.ascii.spl
    silent !wget -O ~/.nvim/spell/en.utf-8.spl http://ftp.vim.org/vim/runtime/spell/en.utf-8.spl
endif

" Auto install vim-plug for plugin management
if empty(glob('~/.nvim/autoload/plug.vim'))
      silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.nvim/plugged')

" Better python syntax highlighting
Plug 'hdima/python-syntax'
let g:python_highlight_all = 1

" YouCompleteMe Autocompletion plugin
" Requires cmake package
" You will need to run the install.py file in ~/.nvim/plugged/YouCompleteMe
Plug 'Valloric/YouCompleteMe'
autocmd! User YouCompleteMe call youcompleteme#Enable()
autocmd CompleteDone * pclose
nnoremap <Leader>jd :YcmCompleter GoTo<CR>
nnoremap <Leader>gd :YcmCompleter GetDoc<CR>

" Shows git file changes to the left of line numbers
Plug 'airblade/vim-gitgutter'
let g:gitgutter_sign_column_always = 1

" Amazing ctrl-p fuzzy searching plugin with better engine
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
if has('python') || has('python3')
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

" If ag search is available, use that.  It's much faster than grep
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
    " Set ctrlp to use ag instead of grep
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
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
if empty(glob('~/ctags'))
    silent !mkdir ~/ctags
    silent !wget -O ~/ctags/ctags-5.8.tar.gz sourceforge.net/projects/ctags/files/ctags/5.8/ctags-5.8.tar.gz
    silent !tar -xzvf ~/ctags/ctags-5.8.tar.gz
    echo('You still need to run ./configure, make and sudo make install for ctags in your home directory')
    echo("Otherwise tagbar won't work")
endif
let g:tagbar_ctags_bin='/usr/local/bin/ctags'
let g:tagbar_autofocus=1

" Some useful tpope plugins:
" Git integration
Plug 'tpope/vim-fugitive'
" Multiline comments via `gc` shortcut
Plug 'tpope/vim-commentary'
" Surround helper
Plug 'tpope/vim-surround'

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

Plug 'luochen1990/rainbow'
let g:rainbow_active = 1


Plug 'kovisoft/slimv'

Plug 'Glench/Vim-Jinja2-Syntax'

call plug#end()

