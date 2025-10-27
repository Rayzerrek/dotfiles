" ========================
" VIMRC
" ========================

" Map leader to space
let mapleader=" "

" PLUGINS
call plug#begin()
Plug 'joshdick/onedark.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'preservim/nerdtree'
Plug 'aluriak/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'haya14busa/vim-easymotion'
" Plug 'evanleck/vim-svelte'
Plug 'yggdroot/indentline'
Plug 'cespare/vim-toml'                " TOML support
Plug 'tomtom/tcomment_vim'
Plug 'dense-analysis/ale'
Plug 'wincent/terminus'
Plug 'sheerun/vim-polyglot'
call plug#end()


" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
" set nocompatible

" Turn on syntax highlighting.
syntax on

"Theme
set termguicolors
colorscheme onedark
let g:airline_theme = 'onedark'

" Disable the default Vim startup message.
set shortmess+=I

" Set line numbers and relative numbers.
set number 
set relativenumber

" Always show status bar.
set laststatus=2
" Better backspace behavior.
set backspace=indent,eol,start

" Default split to right and below instad of left and above
set splitright
set splitbelow

" copy and paste to CLIPBOARD (+) register
noremap <Leader>y "+y
noremap <Leader>p "+p

" Efficient bindings for navigating between splits
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <C-h> <C-w>h

let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
" Toggle hidden buffers.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Bind S to global replace
nnoremap S :%s//g<Left><Left>

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> 
" 'Q' in normal mode enters Ex mode. You almost never want this.

" Do not conceal quotes in JSON files
let g:vim_json_conceal=0
let g:indentLine_fileTypeExclude = ['markdown', 'md']
let g:markdown_fenced_languages = ['python', 'js=javascript', 'ruby']

" NerdTree
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Disable colorization of matching brackets because it's annoying.
set noshowmatch

" Enable mouse support. 
set mouse+=a

" Toggle leading spaces as dots
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_leadingSpaceEnabled = 1

" Some more whitespace handling.
set listchars=tab:›\ ,eol:¬,trail:⋅

" Enable reasonable colors scheme for vimdiff
"if &diff
	"colorscheme diffcolors
"endif

" Disable parentheses highlight: macOS version
function! g:FckThatMatchParen ()
    if exists(":NoMatchParen")
        :NoMatchParen
    endif
endfunction

augroup plugin_initialize
    autocmd!
    autocmd VimEnter * call FckThatMatchParen()
augroup END

" Override language settings
set langmenu=en
let $LANG = 'en'

" Rainbow brackets
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

" Comments indent fix
" set cindent cinkeys-=0#
" set nosmartindent
" set expandtab shiftwidth=4 tabstop=4 softtabstop=4
