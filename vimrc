"General settings
"
set backspace=indent,eol,start
set enc=utf-8
set expandtab
set ignorecase
set laststatus=2
set list
set ls=2
set nobackup
set nocompatible  "No vi compatible
set noswapfile
set nowritebackup
set number
set shell=/bin/bash
set shiftwidth=4
set smartcase
set softtabstop=4
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

syntax on

"Vundle settings
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'

Plugin 'scrooloose/nerdtree.git'

call vundle#end()

filetype plugin indent on

let NERDTreeAutoDeleteBuffer = 1
let NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 20
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
