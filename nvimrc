
filetype off                  " required

set sidescroll=1        " Make side scrolling reasonable
set tabstop=4           " Set number of spaces that tabs count for
set shiftwidth=4        " Set autoindent level to 4 spaces
set expandtab           " Change all tabs to spaces
set lazyredraw          " Redraw screen only when typing
set ttyfast             " Setting to ensure tmux is drawing quickly

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

" Force `Y` behavior to match that of `C` and `D`
nnoremap Y y$

"""""""""""""""""""""""""""""""""""
""""""Neovim Specific Settings""""""
"""""""""""""""""""""""""""""""""""
function! Gf()
    if &buftype ==# "terminal"
        :e <cfile>
    else
        normal! gf
    endif
endfunction

function! OpenMyFile(f)
    let a:folder=$HOME . '/Code/' . a:f
    echo a:folder
    execute 'tabe' a:folder
    execute 'lcd' a:folder
    execute 'vsp term://zsh'
endfunction

if has('nvim')
    " Increase terminal buffer 10x
    let g:terminal_scrollback_buffer_size = 10000
    let g:python_host_prog=$HOME . "/venvs/neovim/bin/python"     " Ensure neovim is always using its own virtualenv
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1     " Force use of I-bar for insert mode
    let $TMUX_TUI_ENABLE_SHELL_CURSOR=1
    " Workaround for bug #4299
    nnoremap gf :call Gf()<CR>
endif

if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
endif
" Fixing Neovim Meta Character Terminal Word Jumping
tnoremap <A-b> <Esc>b
tnoremap <A-f> <Esc>f
tnoremap <A-.> <Esc>.
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
noremap <Leader>s :set spell!<CR>
" Quick Search
noremap <Leader>K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" Delete all trailing whitespace
noremap <Leader>ds :try<CR> :%s/\s\+$//<CR> :let @/ = ''<CR> :catch<CR> :let @/ = ''<CR> :endtry<CR><CR>
" Easy Reload nvimrc
noremap <Leader>rv :source $MYVIMRC<CR>
" Easy Clear Last Search Highlight
noremap <Leader>c :let @/ = ''<CR>
" Easy Neovim Terminal Split
noremap <Leader>gt :vsp term://zsh<CR> i
" Easy Split Switch From Neovim Terminal Insert Mode
tnoremap <Leader>e <C-\><C-n><C-w><C-w>
" Easy Pylinting mnemonic "Python Code"
noremap <Leader>,pc !pylint %

""""
" Rust keymappings
""""
noremap <Leader>rp i println!("{:?}"

noremap <Leader>rf i .fold(0, \|acc, item\| acc + item)


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

" Easier Tabline Modification
Plug 'gcmt/taboo.vim'
let g:taboo_tab_format = ' %N : %P '

" Better python syntax highlighting
Plug 'msmith491/python-syntax'
let g:python_highlight_all = 1

" YouCompleteMe Autocompletion plugin
" Requires cmake package
" You will need to run the install.py file in ~/.nvim/plugged/YouCompleteMe
Plug 'Valloric/YouCompleteMe'
let g:ycm_path_to_python_interpreter=$HOME . "/venvs/neovim/bin/python"
let g:ycm_global_ycm_extra_conf=$HOME . "/ycm.py"
let g:ycm_server_use_vim_stdout = 0
let g:ycm_server_keep_logfiles = 1
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
let g:gitgutter_max_signs = 1000

" " Amazing ctrl-p fuzzy searching plugin with better engine
" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'FelikZ/ctrlp-py-matcher'
" let g:ctrlp_max_files=0
" let g:ctrlp_follow_symlinks=1
" if has('python') || has('python3')
"     let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
" endif

" FuzzyFinder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
nnoremap <C-p> :FZF<CR>

" " If ag search is available, use that.  It's much faster than grep
" if executable('ag')
"     set grepprg=ag\ --nogroup\ --nocolor
"     " Set ctrlp to use ag instead of grep
"     " Using the `-u` flag to search in hidden files as well
"     let g:ctrlp_user_command = 'ag %s -l -u --nocolor -g "" | ag -v "\.git" | ag -v "\.pyc"'
"     let g:ctrlp_use_caching = 0
" endif

" Better file browser
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']

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

Plug 'scrooloose/syntastic'
set laststatus=2
set statusline+=%f
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Python checker settings
let g:syntastic_python_checkers = ["flake8"]
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

Plug 'Glench/Vim-Jinja2-Syntax'

Plug 'kshenoy/vim-signature'

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
    " Rust
    Plug 'rust-lang/rust.vim'
    let g:ycm_rust_src_path = '/usr/local/bin/rust/src'
    Plug 'zah/nim.vim'
    set tabstop=4
    set shiftwidth=4
    Plug 'fatih/vim-go'
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
    let g:go_play_open_browser = 0
    let g:go_bin_path = expand("~/.gotools")
    let g:go_list_type = "quickfix"
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


""""""""""""""""""""""""""""""""""""""""
""""""  Golang Settings and Stuff """"""
""""""""""""""""""""""""""""""""""""""""

autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal listchars=tab:>·,trail:-,extends:>,precedes:<,nbsp:+   " Show visible characters for whitespace
autocmd FileType go setlocal nolist

""""""""""""""""""""""""""""""""""""""""
""""""""" Mutt Email Settings  """""""""
""""""""""""""""""""""""""""""""""""""""
augroup filetypedetect
  autocmd BufRead,BufNewFile *mutt-*              setfiletype mail
augroup END
