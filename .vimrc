" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" use adobe font
" downloaded from https://github.com/fncll/vimstuff as this is the version
" with the correct symbols for airline
set guifont=Source\ Code\ Pro\ Medium:h10

" set syntax highlighting to on
syn on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" keep a backup file
set backup

" keep 50 lines of command line history
set history=50

" show the cursor position all the time
set ruler

" display incomplete commands
set showcmd

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" and also remove menu and toolbar
let &guioptions = substitute(&guioptions, "t", "", "g")
let &guioptions = substitute(&guioptions, "T", "", "g")
let &guioptions = substitute(&guioptions, "m", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq
" add mapping for tag jumping as it is not defined. This works on german
" keyboard layouts. (You must press CTRL-AltGr-9)
nnoremap <C-]> <C-]>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" get rid of the E303 - swap file could not be created
set directory=.,$TEMP

" : should be used in search
set iskeyword+=:

" better characters for non printable characters if you use :set list
set listchars=tab:>-,trail:-

" bugfix for babun console showing wrong cursor in vim
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

" use incremental search
set incsearch

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" set $HOME/vimfiles as addtional runtime path so that pathogen can find
" everything
set rtp+=~/vimfiles

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"------------------------LATEX-----------------------------------------------
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf='pdflatex -synctex=-1 -interaction=nonstopmode $*'
let g:Tex_ViewRuleComplete_pdf = 'start SumatraPDF.exe -reuse-instance $*.pdf'
" next line didn't work - still used Acrobat
"let g:Tex_ViewRule_pdf = 'SumatraPDF -reuse-instance'

" log debug information to user home
let Tex_DebugLog = $USERPROFILE.'\latexsuite.log'
"-----------------------------------------------------------------------------

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

" start addon manager
"-------------------------Vundle-------------------------------------------
" git clone https://github.com/VundleVim/Vundle.vim.git
set rtp+=~/vimfiles/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" git plugin
Plugin 'tpope/vim-fugitive'
" vim-airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" NERDTree plugin
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
" Plugin for markdown support
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

call vundle#end()            " required
filetype plugin indent on    " required
"-------------------------Vundle-------------------------------------------

""""""""""""""""""""""""""""""
" airline
""""""""""""""""""""""""""""""
let g:airline_theme 			        = 'powerlineish'
let g:airline#extensions#branch#enabled 	= 1
let g:airline#extensions#syntastic#enabled  	= 1
let g:airline#extensions#tabline#enabled 	= 1
let g:airline_powerline_fonts			= 1
set encoding=utf-8

"Set the status line options. Make it show more information.
set laststatus=2
set statusline=%F%m%r%h%w%{fugitive#statusline()}\ [FORMAT=%{&ff}]\ [TYPE=%Y]\[POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")} 

