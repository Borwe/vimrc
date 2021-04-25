" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim



" FOR VUNDLE
set nocompatible              " be iMproved, required

" Get OS
let s:OS_win32=has('win32')

"for LSP completion with YouCompleteMe and setting up viminfo
let s:vim_location_home='.vim'
if s:OS_win32
   let s:vim_location_home='vimfiles'
endif

"for creating and setting up vimfinfo
function! SetupVimInfo()
    let viminfo_dir = $HOME .'/'. s:vim_location_home . "/files/info"
    if( isdirectory( viminfo_dir ) == v:false )
        call mkdir("info", $HOME .'/'. s:vim_location_home . "/files")
    endif

    let viminfo_file = viminfo_dir . "/viminfo"
    if( filereadable( viminfo_file ) == v:false)
        let blank=[]
        call writefile( blank, viminfo_file)
    endif

    exec "set viminfo='100,n".viminfo_file
endfunction
call SetupVimInfo()

" set the runtime path to include Vundle and initialize
call plug#begin()

" let Vundle manage Vundle, required
Plug 'scrooloose/nerdtree'
"Plug 'Yggdroot/duoduo'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'   "for git and info on airline
Plug 'Borwe/YouCompleteMe'
Plug 'Borwe/lsp-examples'
"Plug 'morhetz/gruvbox' " Color scheme 
"Plug 'dracula/vim',{'as':'dracula'}  " Color scheme
"Plug 'jordwalke/vim-taste' " Color scheme
Plug 'leafgarland/typescript-vim' " syntax highlighting for vim
Plug 'Shougo/unite.vim'
Plug 'mattn/emmet-vim'
Plug 'junegunn/fzf'
Plug 'tkztmk/vim-vala'
Plug 'vim-scripts/taglist.vim'
Plug 'Borwe/vim-ide-file' " own ide plugin, (WIP)
Plug 'Borwe/vim-vimrc-refresher' "For automatically refreshing vim
Plug 'SirVer/ultisnips' "for snippets
Plug 'vim/killersheep' "game
Plug 'vim-test/vim-test' "for running tests
Plug 'mhinz/vim-startify' " start screen"
Plug 'ararslan/license-to-vim' " for licenses

call plug#end()


filetype plugin indent on    " required

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark
colorscheme industry

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Setup the font for when using gvim
if s:OS_win32
    set guifont=Consolas:h10:cANSI:qDRAFT
else
    set guifont=Ubuntu\ Mono\ 11
endif
" remove gui options
set guioptions-=m
set guioptions-=T



" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
"set cmdheight=2 " the size of the command line at bottom 
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)
set number		" Set numbering
set relativenumber "show numbering relative to position
set autoindent
set autoread "make vim autoreload files
set mouse=a "enable using mouse in vim/neovim
set encoding=utf-8 " set the encodings to be utf8
set expandtab
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set foldmethod=syntax   " for folding code based on syntax
set path+=**	" Search down the subfolders
set wildmenu 	" Display all matching files when we tab complete
set backspace=2 " for allowing deletion with backspace

"for opening ~/.vimrc
nnoremap vrc :exec "edit ".$MYVIMRC<CR>

"for opening up terminal
if s:OS_win32
        nnoremap term :belowright terminal powershell<CR>
        nnoremap vterm :vertical terminal powershell<CR>
else
        nnoremap term :belowright terminal<CR>
        nnoremap vterm :vertical terminal<CR>
endif
"for exiting insert mode on terminal on vim
tnoremap <C-e> <C-\><C-N>
"for quiting all together
" tnoremap <C-A-e> <C-c>exit<CR>

"for coupled brackets and quatations
inoremap " ""<C-[>i
inoremap ' ''<C-[>i
inoremap { {}<C-[>i
inoremap [ []<C-[>i
inoremap ( ()<C-[>i

" setup for ultisnips
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsListSnippets="<A-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

"group for setting filetypes
augroup set_file_types
    "reset to null if exists before
    autocmd!
    "set filetypes
    autocmd BufEnter,BufNewFile *.vala :setlocal filetype=vala "set ts files to typescript
    autocmd BufEnter,BufNewFile *.ts :setlocal filetype=typescript "set ts files to typescript
    autocmd BufEnter,BufNewFile *vimrc :setlocal filetype=vim "set all files with postfix of 'vimrc' to be detected as vim files
augroup END

"Set filetype to be angular
function! SetAngularFileType()
    :echom "Setting filetype to be angular for easy completions"
    :setlocal filetype=angular
endfunction
command! SetAngular :call SetAngularFileType()
nnoremap angit :SetAngular

"Command for enabling tags for jumping through code
command! MakeTags :!ctags -R

"Command for showing fzf
nnoremap <C-f> :<C-u>FZF<CR>

"Command for resizing by 5 horizontally
nnoremap rs+ :vertical resize +5<CR>
nnoremap rs- :vertical resize -5<CR>

"Command for resizing by 5 vertically
nnoremap vrs+ :resize +5<CR>
nnoremap vrs- :resize -5<CR>

"Command to show nerdree
nnoremap ntree :NERDTree<CR>


" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif


"hand displaying/hiding taglist
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Show_One_File = 1 "set tags to only show based on current viewed buffer/file
function! TagListToggle()
    :TlistToggle
endfunction
:nnoremap tag <Esc>:call TagListToggle()<CR>


" for setting up java tool options, appended to the default system ones, but
" with lombok support
"let $JAVA_TOOL_OPTIONS=$JAVA_TOOL_OPTIONS.' -javaagent:/home/brian/vim-setup/vimrc/lombok.jar '
"let $JAVA_TOOL_OPTIONS=$JAVA_TOOL_OPTIONS

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" add command to switch tabs
function! SelectTabs()
    :tabs
    :let tabNum=input("Select Tab Number: ")
    :echo "\nMoving to tab ".tabNum
    :exec "tabn" tabNum
endfunction
command! Tab call SelectTabs() 

" add command to switch buffers
function! SelectBuffer()
    :ls
    :let buffNum=input("Select BUffer Number: ")
    :echo "\nMoving to Buffer ".buffNum
    :exec "buffer " buffNum
endfunction
command! Buff call SelectBuffer()

" For licenses support
let g:license_author= 'Brian Orwe'
let g:license_email= 'brian.orwe@gmail.com'

"for LSP completion with YouCompleteMe

"go to definition from ycmCompleter in a new tab
nnoremap <Space>n :YcmCompleter GoToDefinition<CR>
"go to include from ycmCompleter in a new tab
nnoremap <Space>i :YcmCompleter GoToInclude<CR>
"go to declaration from ycmCompleter in a new tab
nnoremap <Space>d :YcmCompleter GoToDeclaration<CR>
"go to implementation 
nnoremap <Space>m :YcmCompleter GoToImplementation<CR>
"show errors
nnoremap <Space>x :YcmDiags<CR>
"pop up hover info
nmap <Space>z <Plug>(YCMHover)
"go back
nnoremap <Space>b <C-o>

"Command to fix errors with YCM
nnoremap fix :YcmCompleter FixIt<CR>

"Ycm rename things
function! RenameThingsFunction()
    :echo "Renaming:"
    :normal viWy
    :echo "Word to replace is ".@@
    :let wordReplace=input("\nEnter word to replace with: ")
    :exec 'YcmCompleter RefactorRename '.wordReplace
    :echo "[Done]"
endfunction
command! Rename call RenameThingsFunction()


"for ycm warning symbal
let g:syntastic_warning_symbol="$$"
" disable ucm on vim help
let g:ycm_filetype_blacklist={'help':1}
"for ycm hiding window docs
let g:ycm_autoclose_preview_window_after_insertion=1
"for ycm have 1000+ candidates for completions
let g:ycm_max_num_candidates = 1000
"for ycm to stop auto popup on hovering
let g:ycm_auto_hover=""
" for ycm logging
let g:ycm_log_level='debug'

"For c++ youcompleteme support
" check if .bin/.ycm_extra_conf.py exists
" if so, then map g:ycm_global_ycm_extra_conf to it
" else skip and use the default
if filereadable('~/vim-setup/vimrc/.ycm_extra_conf.py')
    :let g:ycm_global_ycm_extra_conf ='~/vim-setup/vimrc/.ycm_extra_conf.py'
else
    "THE DEFAULT FROM YCM
    :let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
endif

"set AirLine theme
"let g:airline_theme='taste'

let s:lsp='~/'.s:vim_location_home.'/plugged/lsp-examples'
let s:pip_os_dir = 'bin'
if has('win32')
  let s:pip_os_dir = 'Scripts'
end
let g:ycm_language_server =[
\ { 'name': 'vim',
\ 'filetypes': [ 'vim' ],
\ 'cmdline': [ expand( s:lsp . '/viml/node_modules/.bin/vim-language-server' ), '--stdio' ]
\ },
\ { 'name': 'docker',
\   'filetypes': ['dockerfile'],
\   'cmdline':[expand(s:lsp . '/docker/node_modules/.bin/docker-langserver'), '--stdio']
\ },
\ { 'name':'vala-language-server',
\  'filetypes':['vala','genie'],
\  'cmdline': [ 'vala-language-server']
\ },
\ {'name':'cmake',
\   'filetypes':['cmake'],
\   'cmdline': [ expand( s:lsp . '/cmake/venv/' . s:pip_os_dir . '/cmake-language-server' )]
\ },
\ {'name':'vala',
\    'filetypes': ['vala','genie'],
\    'cmdline': ['vala-language-server']
\ },
\ { 'name': 'angular',
\     'cmdline': [ 'node' ,
\     expand( s:lsp . '/angular/node_modules/@angular/language-server' ),
\     '--ngProbeLocations',
\     expand( s:lsp . '/angular/node_modules/' ),
\     '--tsProbeLocations',
\     expand( s:lsp . '/angular/node_modules/' ),
\     '--stdio' ],
\ 'filetypes': [ 'ts','html' ],
\ },
\]

