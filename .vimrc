" Sources: 
" https://w4118.github.io/workflow
" https://github.com/Howon/Config/blob/master/vimrc
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
 " set nobackup		" do not keep a backup file, use versions instead
"else
 " set backup		" keep a backup file (restore to previous version)
  "set undofile		" keep an undo file (undo changes after closing)
"endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

command W w " map uppercase W to lowercase w for writing

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

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

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
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

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif


" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
packadd matchit


"colorscheme torte "good C theme
colorscheme peachpuff
"colorscheme slate
highlight Normal ctermbg=darkblue

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jae's Vim settings
 "

 " Line numbers
 set number
 
 let mapleader ="\<Space>"

 " Buffer switching using Cmd-arrows in Mac and Alt-arrows in Linux
  ":nnoremap <D-Right> :bnext<CR>
  ":nnoremap <M-Right> :bnext<CR>
  ":nnoremap <D-Left> :bprevious<CR>
  ":nnoremap <M-Left> :bprevious<CR>
 " and don't let MacVim remap them
 if has("gui_macvim")
    let macvim_skip_cmd_opt_movement = 1
    endif

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>q :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Use arrow keys to navigate window splits -- horrible b/c can't use arrow
" nnoremap <silent> <Right> :wincmd l <CR>
" nnoremap <silent> <Left> :wincmd h <CR>
" noremap <silent> <Up> :wincmd k <CR>
" noremap <silent> <Down> :wincmd j <CR>  

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

    " When coding, auto-indent by 4 spaces, just like in K&R
    " Note that this does NOT change tab into 4 spaces
    " You can do that with "set tabstop=4", which is a BAD idea
    set tabstop=4
    set shiftwidth=4

    " Always replace tab with 8 spaces, except for makefiles
    set expandtab
    autocmd FileType make setlocal noexpandtab

    " My settings when editing *.txt files
    "   - automatically indent lines according to previous lines
    "   - replace tab with 8 spaces
    "   - when I hit tab key, move 2 spaces instead of 8
    "   - wrap text if I go longer than 76 columns
    "   - check spelling
    autocmd FileType text setlocal autoindent expandtab softtabstop=2 textwidth=76 spell spelllang=en_us

    autocmd FileType python setlocal shiftwidth=2 softtabstop=2 expandtab

" Don't do spell-checking on Vim help files
"""""""""autocmd FileType help setlocal nospell

" Prepend ~/.backup to backupdir so that Vim will look for that directory
    " before littering the current dir with backups.
    " You need to do "mkdir ~/.backup" for this to work.
    set backupdir^=~/.backup

    " Also use ~/.backup for swap files. The trailing // tells Vim to incorporate
    " full path into swap file names.
    set dir^=~/.backup//

    " Ignore case when searching
    " - override this setting by tacking on \c or \C to your search term to
    "make
    "   your search always case-insensitive or case-sensitive, respectively.
    set ignorecase

    "
    " End of Jae's Vim settings
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    " Ignore case when searching
    set ignorecase

    " When searching try to be smart about cases
    set smartcase

    " Highlight search results
    set hlsearch

    " Makes search act like search in modern browsers
    set incsearch

    " Don't redraw while executing macros (good performance config)
    set lazyredraw

    " For regular expressions turn magic on
    set magic


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename

" -----------Buffer Management---------------
set hidden " Allow buffers to be hidden if you've modified a buffer



" ctrl-p
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

" Use the nearest .git|.svn|.hg|.bzr directory as the cwd
let g:ctrlp_working_path_mode = 'r'

nmap <leader>p :CtrlP<cr>  " enter file search mode

" Nerdtree
"autocmd vimenter * NERDTree
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>  " open and close file tree
nmap <leader>n :NERDTreeFind<CR>  " open current buffer in file tree
let NERDTreeQuitOnOpen=1

" Jump to the main window.
autocmd VimEnter * wincmd p

" YCM settings
" (Pretty sure these don't work/YCM isn't completely installed because
" was killing the machine when I was trying to install.)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:ycm_global_ycm_extra_conf ='~/.vim/.ycm_extra_config.py'
"let g:ycm_semantic_triggers =  {
"  \   'c' : ['->', '.'],
"  \   'objc' : ['->', '.'],
"  \   'cpp,objcpp' : ['->', '.', '::'],
"  \   'perl' : ['->'],
"  \   'php' : ['->', '::'],
"  \   'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
"  \   'lua' : ['.', ':'],
"  \   'erlang' : [':'],
"  \ }

"let g:ycm_complete_in_comments_and_strings=1
"let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
"let g:ycm_autoclose_preview_window_after_completion = 1
"https://github.com/Yggdroot/indentLine
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
"let g:indentLine_enabled = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required

" Automatic ctags cleanup on file writes. This plugin searches parent
" directories for any .tags files and removes stale tags.
Plug 'craigemery/vim-autotag'

" Syntax checking
Plug 'scrooloose/syntastic'

" Convenient completion for XML/HTML
Plug 'othree/xml.vim'

" Press t to toggle tagbar.
Plug 'majutsushi/tagbar'

" gc to toggle comments
Plug 'tomtom/tcomment_vim'

" Browse the file system
Plug 'scrooloose/nerdtree'

" Fuzzy search ctrlp
Plug 'kien/ctrlp.vim'

" Git plugin
Plug 'tpope/vim-fugitive'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

" Skeltons for common filetypes
Plug 'noahfrederick/vim-skeleton'

" PEP8 indentation for python
Plug 'hynek/vim-python-pep8-indent'

" Better handling of (), [], etc
" Plug 'jiangmiao/auto-pairs'

" Move function arguments around easily.
Plug 'AndrewRadev/sideways.vim'

" Lighter alternative to airline
"""""" Plug 'itchyny/lightline.vim'

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Indentation guide
Plug 'nathanaelkane/vim-indent-guides'

" YCM
" Plug 'Valloric/YouCompleteMe'

" Ctrlp
Plug 'kien/ctrlp.vim'

" indentLine
Plug 'Yggdroot/indentLine'

" All of your Plugins must be added before the following line
call plug#end()
set mouse-=a
