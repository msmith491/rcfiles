set nocompatible              " be iMproved, required
filetype off                  " required

if $TMUX != ""
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  """ Cursor Settings Mac ITerm2 """
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

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
set colorcolumn=79      " Show the 79 character cutoff marker
set nowrap

set hlsearch            " highlight searches
set incsearch           " do incremental searching
set showmatch           " jump to matches when entering regexp
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase char present
 
set visualbell t_vb=    " turn off error beep/flash
set novisualbell        " turn off visual bell
 
set backspace=indent,eol,start  " make that backspace key work the way it should
set rtp+=~/.vim         " Ensure .vim folder is at the head of the runtime path
set rtp+=$VIMRUNTIME    " turn off user scripts, https://github.com/igrigorik/vimgolf/issues/129

syntax on               " turn syntax highlighting on by default
filetype on             " detect type of file
filetype indent on      " load indent file for specific file type

" Fix backspace/delete key issues
set backspace=indent,eol,start

if empty(glob('~/.vim/spell'))
    silent !mkdir ~/.vim/spell
    silent !wget -O ~/.vim/spell/en.ascii.spl http://ftp.vim.org/vim/runtime/spell/en.ascii.spl
    silent !wget -O ~/.vim/spell/en.utf-8.spl http://ftp.vim.org/vim/runtime/spell/en.utf-8.spl
endif

if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

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

Plug 'tpope/vim-fugitive'

Plug 'andviro/flake8-vim'
let g:PyFlakeOnWrite = 1
let g:PyFlakeDisableMessages = ''
let g:PyFlakeCheckers = 'pep8,mccabe,frosted'
let g:PyFlakeDefaultComplexity=10
let g:PyFlakeSigns = 1
let g:PyFlakeMaxLineLength = 79
let g:PyFlakeAggressive = 4

call plug#end()
