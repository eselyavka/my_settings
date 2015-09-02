"General settings
set nocompatible  "No vi compatible
set softtabstop=4 
set shiftwidth=4 
set expandtab 
set list
set backspace=indent,eol,start
syntax on
set number
set nobackup
set nowritebackup
set noswapfile
set enc=utf-8
set ls=2

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

"Vundle settings
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'

Plugin 'scrooloose/nerdtree.git'

call vundle#end()
filetype plugin indent on
