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

"Vundle settings
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'

call vundle#end()
filetype plugin indent on
