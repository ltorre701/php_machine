set nocompatible
syntax on
filetype on
filetype plugin on
filetype indent on
set number
inoremap hh <Esc>

" Plugin section
call plug#begin()
Plug 'mattn/emmet-vim'
call plug#end()

" Basic editing settings
set shiftwidth=4
set tabstop=4
set expandtab
set autoindent
set clipboard=unnamedplus
set mouse=a

" Search and interface settings
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set smartcase
set showcmd
set showmode
set showmatch
set hlsearch
set history=1000
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Comment color and format settings
highlight Comment ctermfg=darkgray
set formatoptions-=cro
set fileformats=unix,dos
set fileformat=unix

" Cursor shape settings for native Linux
if has('gui_running')
    " GUI vim
    set guicursor=n-v-c:block-Cursor
    set guicursor+=i:ver25-Cursor
    set guicursor+=r:hor20-Cursor
else
    " Console vim
    if &term =~ "xterm\\|rxvt"
        " Use an orange cursor in insert mode
        let &t_SI = "\<Esc>]12;orange\x7"
        " Use a red cursor otherwise
        let &t_EI = "\<Esc>]12;red\x7"
        silent !echo -ne "\033]12;red\007"
        " Reset cursor when vim exits
        autocmd VimLeave * silent !echo -ne "\033]112\007"
        let &t_SI .= "\<Esc>[6 q"
        let &t_EI .= "\<Esc>[2 q"
    endif
endif