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
match ErrorMsg '\s\+$'

" Fix backspace/delete key issues
set backspace=indent,eol,start      " Setting backspace to behave in a sane fashion
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+   " Show visible characters for whitespace
set list    " Also necessary for visible trailing whitespace

" Esc alternative for Dvorak users.  QWERTY folks should use jk or kj
inoremap tn <Esc>
set timeoutlen=300

" Force `Y` behavior to match that of `C` and `D`
nnoremap Y y$

" Remap :W and :X to :w and :x because half the time I accidentally type them
ca W w
ca X x

" Move right 15 characters
nnoremap <C-l> 15zl
" Move left 15 characters
nnoremap <C-h> 15zh

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

function! OpenGoDatDual(fl)
    let l:folder=$HOME . '/go/src/github.com/Datera/' . a:fl
    exe 'tabe' . l:folder
    exe 'tcd' . l:folder
    vsp term://zsh
    sp term://zsh
    wincmd w
endfunction

function! OpenGoDatDuals(fs)
    for fl in split(a:fs)
        call OpenGoDual(fl)
    endfor
endfunction

function! OpenGoDual(fl)
    let l:folder=$HOME . '/go/src/github.com/' . a:fl
    exe 'tabe' . l:folder
    exe 'tcd' . l:folder
    vsp term://zsh
    sp term://zsh
    wincmd w
endfunction

function! OpenGoDuals(fs)
    for fl in split(a:fs)
        call OpenGoDual(fl)
    endfor
endfunction

function! OpenDual(fl)
    let l:folder=$HOME . '/Code/' . a:fl
    exe 'tabe' . l:folder
    exe 'tcd' . l:folder
    vsp term://zsh
    sp term://zsh
    wincmd w
endfunction

function! OpenDuals(fs)
    for fl in split(a:fs)
        call OpenDual(fl)
    endfor
endfunction

function! OpenTrip(fl)
    let l:folder=$HOME . '/Code/' . a:fl
    exe 'tabe' . l:folder
    exe 'tcd' . l:folder
    exe 'vsp' . l:folder
    vsp term://zsh
    sp term://zsh
    wincmd w
endfunction

function! OpenTrips(fs)
    for fl in split(a:fs)
        call OpenTrip(fl)
    endfor
endfunction

function! OpenPlz(fs)
    let l:gofolder=$HOME . '/go/src/github.com/'
    let l:godatfolder=l:gofolder . 'Datera/'
    let l:codefolder=$HOME . '/Code/'
    for fl in split(a:fs)
        if !empty(glob(l:codefolder . fl))
            call OpenTrip(fl)
            continue
        endif
        let l:ffolder=glob(l:gofolder . '*/' . fl)
        if !empty(l:ffolder)
            let l:p=split(l:ffolder, '/')
            call OpenGoDual(join([l:p[-2], l:p[-1]], '/'))
            continue
        endif
    endfor
endfunction

let g:plz_save=$HOME . '/plz_save.session'

function! PlzSave()
    let l:origbuff=nvim_get_current_buf()
    let l:origtab=nvim_get_current_tabpage()
    let l:session=[]
    " Iterate through open tabs
    for l:tnum in nvim_list_tabpages()
        " Switch to the tab
        call nvim_set_current_tabpage(l:tnum)
        let l:buffs=[]
        let l:terms=0
        " Iterate through the buffers for this tab
        for l:tb in tabpagebuflist()
            " Save the buffer filepath
            let l:bi=getbufinfo(l:tb)[0]
            let l:f=l:bi['name']
            let l:n=l:bi['lnum']
            " Count terminal windows
            if l:f =~ 'term:'
                let l:terms += 1
            " Normalize NERDtree entries to be parent directories
            elseif l:f =~ 'NERD_tree'
                let l:f='/' . join(split(l:f, '/')[0:-2], '/')
                call add(l:buffs, [l:f, l:n])
            else
                call add(l:buffs, [l:f, l:n])
            endif
        endfor
        " Key everything by the working directory
        call add(l:session, [getcwd(), {'buffs': l:buffs, 'terms': l:terms}])
    endfor
    call nvim_set_current_tabpage(l:origtab)
    call nvim_set_current_buf(l:origbuff)
    echo 'Saving session to ' . g:plz_save
    " Write session info to file
    call SaveVar(l:session, g:plz_save)
endfunction

function! PlzRestore()
    let l:session=ReadVar(g:plz_save)
    for l:elem in l:session
        let [l:cwd, l:d]=l:elem
        let l:buffs=l:d['buffs']
        let l:terms=l:d['terms']
        " There should never be more than six files open
        " And we want different window configs depending on number
        exe 'tabe ' . l:buffs[0][0]
        exe 'tcd ' . l:cwd
        for l:b in l:buffs[1:2]
            exe 'sp ' . l:b[0]
        endfor
        for l:b in l:buffs[4:4]
            exe 'vsp ' . l:b[0]
        endif
    endfor
endfunction

function! SaveVar(var, file)
    " turn the var to a string that vimscript understands
    let l:serialized = string(a:var)
    " dump this string to a file
    call writefile([l:serialized], a:file)
endfunction

function! ReadVar(file)
    " retrieve string from the file
    let l:serialized = readfile(a:file)[0]
    " turn it back to a vimscript variable
    exe "let result = " . l:serialized
    return result
endfunction

if has('nvim')
    " Increase terminal buffer 10x
    let g:terminal_scrollback_buffer_size = 10000
    let g:python_host_prog=$HOME . "/venvs/neovim2/bin/python"     " Ensure neovim is always using its own virtualenv
    let g:python3_host_prog=$HOME . "/venvs/neovim3/bin/python"     " Ensure neovim is always using its own virtualenv
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1     " Force use of I-bar for insert mode
    let $TMUX_TUI_ENABLE_SHELL_CURSOR=1
    " Workaround for bug #4299
    nnoremap gf :call Gf()<CR>
    " Neovim-remote for terminal buffers
    let $VISUAL = 'nvr -cc split --remote-wait'
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
noremap <Leader>gt :vsp term://zsh<CR>
" Easy Split Switch From Neovim Terminal Insert Mode
tnoremap <Leader>e <C-\><C-n><C-w><C-w>
" Easy Pylinting mnemonic "Python Code"
noremap <Leader>,pc !pylint %
" Short UUID Generation in quotes
nnoremap <Leader>u mm:r!uuidgen\|cut -c 1-8<CR>dW"_dd`mi""<Esc>hp

""""
" Rust keymappings
""""
noremap <Leader>rp i println!("{:?}"

noremap <Leader>rf i .fold(0, \|acc, item\| acc + item)

""""
" Slimv keymappings
""""
noremap <LocalLeader>wp :emenu Slimv.Edit.Paredit-Wrap

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

"Mustache/Handlebars syntax"
Plug 'mustache/vim-mustache-handlebars'

"Powershell syntax"
Plug 'PProvost/vim-ps1'

" Easier Tabline Modification
Plug 'gcmt/taboo.vim'
let g:taboo_tab_format = ' %N : %P '

" Better python syntax highlighting
Plug 'msmith491/python-syntax'
let g:python_highlight_all = 1

if has('nvim')
    Plug 'Shougo/deoplete.nvim'
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1
    let g:deoplete#auto_complete_start_length = 3
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

    Plug 'zchee/deoplete-jedi'
    let deoplete#sources#jedi#show_docstring = 0

    " Forces preview window to close after completion
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
endif

" Theme
Plug 'freeo/vim-kalisi'
set background=dark

" Shows git file changes to the left of line numbers
Plug 'airblade/vim-gitgutter'
set signcolumn=yes
let g:gitgutter_max_signs = 1000

" FuzzyFinder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
let $FZF_DEFAULT_COMMAND = 'rg --files'
nnoremap <C-p> :FZF<CR>

" Easy alignment of lines
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


" Better file browser
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']

" Tag generation
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_cache_dir = $HOME . '/.gutencache'

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
let g:syntastic_python_python_exec = '/usr/local/bin/python3'
let g:syntastic_python_flake8_exe = 'python3 -m flake8'
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go', 'html'] }



Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

Plug 'Glench/Vim-Jinja2-Syntax'

Plug 'kshenoy/vim-signature'

""""""""""""""""""""""""""""""""""""""""
"""""" Plugins Only I Care About """""""
""""""""""""""""""""""""""""""""""""""""
if has('nvim')
    " Lisp plugin
    " Plug 'kovisoft/slimv'
    " let g:slimv_leader = ";"
    " " Dlang Autocomplete/GoTo def
    " Plug 'Hackerpilot/DCD'
    " Plug 'idanarye/vim-dutyl'
    " let g:dutyl_stdImportPaths=['/usr/local/Cellar/dmd/2.069.1/include/d2/']
    " autocmd FileType d nnoremap <Leader>gd :DUddoc<CR>
    " autocmd FileType d nnoremap <Leader>jd :DUjump<CR>
    " Rust
    Plug 'rust-lang/rust.vim'
    let g:rustfmt_autosave = 1
    let g:syntastic_rust_rustc_exe = 'cargo check'
    let g:syntastic_rust_rustc_fname = ''
    let g:syntastic_rust_rustc_args = '--'
    let g:syntastic_rust_checkers = ['rustc']
    Plug 'zah/nim.vim'
    set tabstop=4
    set shiftwidth=4
    " Go
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
    " Scala
    Plug 'derekwyatt/vim-scala'
    " Perl
    " Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }
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
    " call dutyl#register#tool('dcd-client',$HOME . '/.config/nvim/plugged/DCD/bin/dcd-client')
    " call dutyl#register#tool('dcd-server',$HOME . '/.config/nvim/plugged/DCD/bin/dcd-server')

    " function StartDCD()
    "     let testvar = system('ps -ef | grep dcd-server | grep -v grep')
    "     if testvar == ''
    "         let server = 'tmux new -s dcd-server -d "' . $HOME . '/.config/nvim/plugged/DCD/bin/dcd-server -I /usr/local/Cellar/dmd/2.069.1/include/d2/"'
    "         exec "!" . server
    "     endif
    " endfunction

    " autocmd FileType d call StartDCD()

    " Terminal mode autocommands to turn off stuff I don't want
    au TermOpen * setlocal norelativenumber
    au TermOpen * setlocal nonumber
    au TermOpen * setlocal signcolumn=no
endif

""""""""""""""""""""""""""""""""""
""""""  Python AutoCommands """"""
""""""""""""""""""""""""""""""""""
autocmd Filetype python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:

""""""""""""""""""""""""""""""""""
""""""  Yaml AutoCommands """"""
""""""""""""""""""""""""""""""""""
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yaml setlocal indentkeys-=:

""""""""""""""""""""""""""""""""""""""""
""""""  Golang Settings and Stuff """"""
""""""""""""""""""""""""""""""""""""""""

autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal listchars=tab:>·,trail:-,extends:>,precedes:<,nbsp:+   " Show visible characters for whitespace
autocmd FileType go setlocal nolist
autocmd FileType go setlocal colorcolumn=119

""""""""""""""""""""""""""""""""""""""""
""""""""" Mutt Email Settings  """""""""
""""""""""""""""""""""""""""""""""""""""
augroup filetypedetect
  autocmd BufRead,BufNewFile *mutt-*              setfiletype markdown
augroup END
" Add format option 'w' to add trailing white space, indicating that paragraph
" continues on next line. This is to be used with mutt's 'text_flowed' option.
autocmd FileType mail setlocal formatoptions+=w tw=72 fo=watqc nojs nosmartindent
