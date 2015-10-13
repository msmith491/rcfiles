set nocompatible              " be iMproved, required
filetype off                  " required

let g:python_host_prog="/Users/matt/venvs/neovim/bin/python"     " Ensure neovim is always using its own virtualenv

set tabstop=4
set shiftwidth=4
set expandtab

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
set rtp+=~/.nvim    " Ensure .nvim folder is at the head of the runtime path
set rtp+=$VIMRUNTIME     " turn off user scripts, https://github.com/igrigorik/vimgolf/issues/129

syntax on               " turn syntax highlighting on by default
filetype on             " detect type of file
filetype indent on      " load indent file for specific file type

"set t_RV=               " http://bugs.debian.org/608242, http://groups.google.com/group/vim_dev/browse_thread/thread/9770ea844cec3282et number
" Fix backspace/delete key issues
set backspace=indent,eol,start

if empty(glob('~/.nvim/spell'))
    silent !mkdir ~/.nvim/spell
    silent !wget -O ~/.nvim/spell/en.ascii.spl http://ftp.vim.org/vim/runtime/spell/en.ascii.spl
    silent !wget -O ~/.nvim/spell/en.utf-8.spl http://ftp.vim.org/vim/runtime/spell/en.utf-8.spl
endif
set spell               " Setting spellcheck language to US English


if empty(glob('~/.nvim/autoload/plug.vim'))
      silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.nvim/plugged')

Plug 'Valloric/YouCompleteMe'
autocmd! User YouCompleteMe call youcompleteme#Enable()

Plug 'airblade/vim-gitgutter'
let g:gitgutter_sign_column_always = 1

Plug 'kien/ctrlp.vim'

Plug 'scrooloose/nerdtree'

Plug 'majutsushi/tagbar'
:nnoremap tb :TagbarToggle<CR>
if empty(glob('~/ctags'))
    silent !mkdir ~/ctags
    silent !wget -O ~/ctags/ctags-5.8.tar.gz sourceforge.net/projects/ctags/files/ctags/5.8/ctags-5.8.tar.gz
    silent !tar -xzvf ~/ctags/ctags-5.8.tar.gz
    echo('You still need to run ./configure, make and sudo make install for ctags in your home directory')
    echo("Otherwise tagbar won't work")
endif

let g:tagbar_ctags_bin='/usr/local/bin/ctags'
let g:tagbar_autofocus=1

call plug#end()
