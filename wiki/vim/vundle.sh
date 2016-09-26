#!/bin/bash

yum -y install git

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cat > ~/.vimrc << EOF
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'

call vundle#end()

filetype plugin indent on
EOF

vim +PluginInstall +qall
