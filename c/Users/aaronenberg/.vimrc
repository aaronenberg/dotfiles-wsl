set number
set ruler
set hidden
set expandtab
set smarttab
set ignorecase
set smartcase
set shiftwidth=4
set tabstop=4
set softtabstop=4
set ai
set si
set mouse=a
set breakindent
set autoindent nosmartindent
set wrap
set linebreak
set nolist
set numberwidth=1
set textwidth=80
set fo-=t
set nojoinspaces


let mapleader=","
if (has("termguicolors"))
 set termguicolors
endif

" remove highlight after search
"nnoremap <esc> :noh<return><esc>

" move through display lines (single-line wrapped)
vnoremap <C-j> gj
vnoremap <C-k> gk
nnoremap <C-j> gj
nnoremap <C-k> gk


" set indent for these specific filetypes
autocmd FileType html,htmldjango setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript,typescript,css setlocal shiftwidth=4 tabstop=4

" open blank files in insert mode
au BufNewFile * startinsert

" THEME 
syntax enable
colorscheme OceanicNext
set encoding=utf-8
highlight clear LineNr
hi LineNr guifg=grey
hi CursorLineNR cterm=bold term=bold ctermfg=11 gui=bold guifg=cyan 
set cursorline
" remove tilde for empty lines
"hi! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg

