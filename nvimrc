set nocompatible              " be iMproved, required
filetype off                  " required

let g:python_host_prog="/Users/matt/venvs/neovim/bin/python"     " Ensure neovim is always using its own virtualenv

set tabstop=4
set shiftwidth=4
set expandtab

set nocompatible        " use vim defaults
set scrolloff=3         " keep 3 lines when scrolling
set ai                  " set auto-indenting on for programming
 
set showcmd             " display incomplete commands
set nobackup            " do not keep a backup file
set number              " show line numbers
set ruler               " show the current row and column
 
set hlsearch            " highlight searches
set incsearch           " do incremental searching
set showmatch           " jump to matches when entering regexp
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase char present
 
set visualbell t_vb=    " turn off error beep/flash
set novisualbell        " turn off visual bell
 
set backspace=indent,eol,start  " make that backspace key work the way it should
set runtimepath=$VIMRUNTIME     " turn off user scripts, https://github.com/igrigorik/vimgolf/issues/129


syntax on               " turn syntax highlighting on by default
filetype on             " detect type of file
filetype indent on      " load indent file for specific file type

set t_RV=               " http://bugs.debian.org/608242, http://groups.google.com/group/vim_dev/browse_thread/thread/9770ea844cec3282et number
" Fix backspace/delete key issues
set backspace=indent,eol,start
set rtp+=~/.nvim/

set spell               " Setting spellcheck language to US English

call plug#begin('~/.nvim/plugged')
" Track the engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-1>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

Plug 'Valloric/YouCompleteMe'

Plug 'kiith-sa/DSnips'

call plug#end()
