""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   \\|//    _    _  ___  ______
"    o o      \  /   /   /  /  /
"     U        \/ __/_ _/ _/_ /_
" by Phil - http://www.306Studio.cn/
"
" Description: My vimrc with dozens of scripts, for linux/windows
" Derive From: Leal - http://www.leal.cn/
"              Amix - http://amix.dk
"              MetaCosm - http://vi-improved.org/vimrc.php
"              W.T. Sidney - http://www.afn.org/~afn39695/sidney.htm
" Last Change: 09/11/07 16:47:57
" Author:      Phil <nicephil@gmail.com>
" Version:     1.00
"
" Section:
" ------------------------------------------------------------------
" *> General
" *> Colors and Font
" *> Fileformat
" *> VIM userinterface
" ------ *> Statusline
" *> Visual
" *> Moving around and tab
" *> General Autocommand
" *> Parenthesis/bracket expanding
" *> General Abbrev
" *> Editing mappings etc.
" *> Command-line config
" *> Buffer related
" *> Files and backup
" *> Folding
" *> Text option
" ------ *> Indent
" *> Spell checking
" *> Plugin configuration
" ------ *> Yank ring
" ------ *> File explorer
" ------ *> Minibuffer
" ------ *> Tag list (ctags)
" ------ *> LaTeX Suite thing
" *> Filetype generic
" ------ *> Todo
" ------ *> VIM
" ------ *> HTML related
" ------ *> Ruby & PHP section
" ------ *> Python section
" ------ *> Cheetah section
" ------ *> Java section
" ------ *> JavaScript section
" ------ *> C mapping
" ------ *> SML
" ------ *> Scheme binding
" *> Snippet
" ------ *> Python
" ------ *> javaScript
" *> Cope
" *> MISC
"
" Tip:
" If you find anything that you can't understand than do this:
" help keyword OR helpgrep keyword
" Example:
" Go into command-line mode and type helpgrep nocompatible, ie.
" :helpgrep nocompatible
" then press <leader>c to see the results, or :botright cw
"
" Usage:
"   1. Create necessary directories and files.
"      $VIMDATA      x:\vim\vimdata on windows, ~/vimdata on linux
"       |-- temp        dir to put swap files when :set swapfile
"       |-- backup      dir to put backup files when :set backup
"       |-- diary       dir to save calendar.vim's diaries
"       |-- GetLatest   dir to save getscript.vim's download files
"       |     `-- GetLatestVimScripts.dat
"       |-- _vim_fav_files       file to store favmenu.vim's items
"       `-- _vim_mru_files       file to store mru.vim's items
"
"   2. Get your favorite scripts on www.vim.org thru getscript.vim.
"
"   3. Get all necessary utilities, especially on windows, such as:
"      wget  - http://users.ugent.be/~bpuype/wget/
"      ctags - http://ctags.sf.net/
"
"   4. If you find anything that you couldn't understand, do this:
"      :h keyword OR :helpgrep keyword OR press K (<S-k>) on it.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get out of VI's compatible mode..
set nocompatible
set vb

function! MySys()
return "linux"
endfunction
"Set shell to be bash
if MySys() == "linux" || MySys() == "mac"
set shell=bash
else
"I have to run win32 python without cygwin
"set shell=D:\program\mingw\bin\sh
endif

"Sets how many lines of history VIM har to remember
set history=400

"Enable filetype plugin
if has("eval")
filetype plugin on
filetype indent on
endif

"Set to auto read when a file is changed from the outside
set autoread

"Have the mouse enabled all the time:
if $TERM != "linux" && $TERM != "screen"
  set mouse=a           " except screen & SecureCRT's linux terminal
endif

"Set mapleader
let mapleader = ","
let g:mapleader = ","

"Fast saving
nmap <leader>w :w!<cr>
nmap <leader>f :find<cr>

"Do not use Ex-mode, use Q for formatting
map Q gq

map ^C ctrl + c

"Use the directory of the related buffer
set browsedir=buffer 

"Use register '*' for all y, d, c, p ops
set clipboard+=unnamed   

"None of these should be word dividers
set isk+=$,%,#   

"Raise a confirm dialog for changed buffer
set confirm            

"Platform dependent
if has("win32")        
  let $VIMRC    = $VIM.'/_vimrc'
  let $VIMDATA  = $VIM.'/vimdata'
  let $VIMFILES = $VIM.'/vimfiles'
else
  let $VIMRC    = $HOME.'/.vimrc'
  let $VIMDATA  = $HOME.'/vimdata'
  let $VIMFILES = $HOME.'/.vim'
endif

"Fast sourcing and editing of the .vimrc
map <leader>s :source $VIMRC<cr>
map <leader>e :e! $VIMRC<cr>
au! BufWritePost [\._]vimrc source $VIMRC
 
"Add this to rtp to satisfy getscript.vim
set rtp+=$VIMDATA

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Font
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable syntax hl
syntax on

"Set font to Monaco 10pt
if has("win32")
  "set gfn=courier:h12
elseif MySys() == "mac"
 set gfn=Bitstream Vera Sans Mono:h14
 set nomacatsui
 set termencoding=macroman
elseif MySys() == "linux"
 "set gfn=Monospace 11
 set encoding=utf-8
 "set encoding=gb2312
endif

let &termencoding=&encoding
set fileencodings=utf8,gb2312,cp936,utf-8,big5,ucs-bom,gb18030,gbk
"Internationalization
"Only work in Win* Chinese version
"if has("multi_byte")
"set termencoding=chinese
"set encoding=utf-8
"set fileencodings=cp936,ucs-bom,utf-8,chinese,gbk
"set encoding=utf-8
"set fileencodings=utf-8,chinese,latin-1
"if has("win32")
"  set fileencoding=chinese
"else
"  set fileencoding=utf-8
"endif
"source $VIMRUNTIME/delmenu.vim
"source $VIMRUNTIME/menu.vim
"language messages zh_CN.utf-8
"endif

"if you use vim in tty,
"'uxterm -cjk' or putty with option 'Treat CJK ambiguous characters as wide' on
if has("ambiwidth")
set ambiwidth=double
endif

if has("gui_running")
set guioptions-=m
set guioptions-=T
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

if MySys()=="win32"
"start gvim maximized
if has("autocmd")
au GUIEnter * simalt ~x
endif
endif
let psc_style='cool'
"colorscheme desertEx
else
set background=dark
"colorscheme desertEx
endif

"Some nice mapping to switch syntax (useful if one mixes different languages in one file)
map <leader>1 :set syntax=c<cr>
map <leader>2 :set syntax=cheetah<cr>
map <leader>3 :set syntax=xhtml<cr>
map <leader>4 :set syntax=python<cr>
map <leader>5 :set ft=javascript<cr>
map <leader>$ :syntax sync fromstart<cr>

"Highlight current
if has("gui_running")   " highlight current line/column
  if v:version >= 700
    "set cursorline
    "hi CursorLine guibg=#333333
    "hi CursorColumn guibg=#333333
  endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fileformat
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetype
set ffs=unix,dos,mac

nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM userinterface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set 7 lines to the curors - when moving vertical..
set so=7

"Turn on WiLd menu
set wildmenu

"Always show current position
set ruler

"The commandbar is 2 high
set cmdheight=2

"Show line number
set nu

"Do not redraw, when running macros.. lazyredraw
set lz

"Change buffer - without saving
set hid

"Bbackspace and cursor keys wrap to
set whichwrap+=<,>,h,l

"Ignore case when searching
set ignorecase
set incsearch

"Set magic on
set magic

"No sound on errors.
set noerrorbells
set novisualbell
set t_vb=

"show matching bracet
set showmatch

"How many tenths of a second to blink
set mat=4

"Highlight search thing
set hlsearch

"Shorten to avoid 'press a key' prompt
set shortmess=atI  

"Minimal screen lines above/below cursor
set scrolloff=7

"Type of file that will not in wildmenu
set wig=*.o,*.pyc,*.exe,*.obj   

"Tell us when anything is changed via :...
set report=0

"Make the splitters between windows be blank
set fillchars=vert:\ ,stl:\ ,stlnc:\

"Remove the highlight searched phrases
map <silent> <leader><cr> :noh<cr>

"How :set list show
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$
   
"Use popup menu to show the possible completions   
"set completeopt=menu   

"Popmenu colors setting
if v:version >= 700    
  hi Pmenu guibg=#333333
  hi PmenuSel guibg=#555555 guifg=#ffffff
endif   

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
"Always hide the statusline
set laststatus=2

function! CurDir()
let curdir = substitute(getcwd(), '/home/phil', "~/", "g")
return curdir
endfunction

"Format the statusline
set statusline=
set statusline+=%f "path to the file in the buffer, relative to current directory
set statusline+=\ %h%1*%m%r%w%0* " flag
set statusline+=\ [%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding}, " encoding
set statusline+=%{&fileformat}] " file format
set statusline+=\ CWD:%r%{CurDir()}%h
set statusline+=\ Line:%l/%L       

""""""""""""""""""""""""""""""
" => Visual
""""""""""""""""""""""""""""""
" From an idea by Michael Naumann
function! VisualSearch(direction) range
let l:saved_reg = @"
execute "normal! vgvy"
let l:pattern = escape(@", '\/.*$^~[]')
let l:pattern = substitute(l:pattern, " $", "", "")
if a:direction == 'b'
execute "normal ?" . l:pattern . "^M"
else
execute "normal /" . l:pattern . "^M"
endif
let @/ = l:pattern
let @" = l:saved_reg
endfunction

"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around and tab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Map space to / and c-space to ?
map <space> /
map <c-space> ?

"Smart way to move btw. window
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"Actually, the tab does not switch buffers, but my arrow
"Bclose function ca be found in "Buffer related" section
map <leader>bd :Bclose<cr>
map <down> <leader>bd

"Use the arrows to something usefull
map <right> :bn<cr>
map <left> :bp<cr>

"Tab configuration
map <leader>tn :tabnew %<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
if has("usetab")
set switchbuf=usetab
endif

if has("stal")
set stal=2
endif

"Moving fast to front, back and 2 sides ;)
imap <m-$> <esc>$a
imap <m-0> <esc>0i
imap <D-$> <esc>$a
imap <D-0> <esc>0i

"Switch to current dir
"map <leader>c :cd %:p:h<cr>

map <leader>c "+y
vmap <leader>c "+y
nmap <leader>c "+y
map <leader>v <ESC>"+p
imap <leader>v <ESC>"+p
vmap <leader>v <ESC>"+p
nmap <leader>v <ESC>"+p

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Autocommand
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Ensure every file does syntax highlighting (full)
autocmd BufEnter * :syntax sync fromstart

"Having it auto maximize the screen
"autocmd GUIEnter * :simalt ~x --

"All the file under the directory are recognized as cpp files by vim
au BufEnter /usr/include/c++/*   setf cpp
 
"If there are any error space(the end of line or before the tabs) in c/c++ code,highlight it
"if $VIM_HATE_SPACE_ERRORS != '0'
"let c_space_errors=1
"endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $w <esc>`>a"<esc>`<i"<esc>

"Map auto complete of (, ", ', [
"ino ( ()<esc>:let leavechar=")"<cr>i
"ino { {}<esc>:let leavechar="}"<cr>i
"ino $q ''<esc>:let leavechar="'"<cr>i
"ino $w ""<esc>:let leavechar='"'<cr>i
"imap <c-l> <esc>:exec "normal f" . leavechar<cr>a

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrev
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Comment for C like language
if has("autocmd")
au BufNewFile,BufRead *.js,*.htc,*.c,*.tmpl,*.css ino $c /**<cr> **/<esc>O
endif

"My information
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab xname Phil Wang

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings etc.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
map 0 ^

"Move a line of text using control
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if MySys() == "mac"
nmap <D-j> <M-j>
nmap <D-k> <M-k>
vmap <D-j> <M-j>
vmap <D-k> <M-k>
endif

map <A-i> i <esc>r

fu! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endf
au BufWrite *.py :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command-line config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! Cwd()
let cwd = getcwd()
return "e " . cwd
endfunc

func! DeleteTillSlash()
let g:cmd = getcmdline()
if MySys() == "linux" || MySys() == "mac"
let g:cmd_edited = substitute(g:cmd, "\(.*[/]\).*", "\1", "")
else
let g:cmd_edited = substitute(g:cmd, "\(.*[\\]\).*", "\1", "")
endif
if g:cmd == g:cmd_edited
if MySys() == "linux" || MySys() == "mac"
let g:cmd_edited = substitute(g:cmd, "\(.*[/]\).*/", "\1", "")
else
let g:cmd_edited = substitute(g:cmd, "\(.*[\\]\).*[\\]", "\1", "")
endif
endif
return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"cno $q <C->eDeleteTillSlash()<cr>
"cno $c e <C->eCurrentFileDir("e")<cr>
"cno $tc <C->eCurrentFileDir("tabnew")<cr>
cno $th tabnew ~/
cno $td tabnew ~/Desktop/

"Bash like
cno <C-A> <Home>
cno <C-E> <End>
cno <C-K> <C-U>

"Bash like
cno <C-F> <Right>
cno <C-B> <Left>
cno <Esc>b <S-Left>
cno <Esc>f <S-Right>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Buffer related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Fast open a buffer by search for a name
map <c-q> :sb

"Open a dummy buffer for paste
map <leader>q :e ~/buffer<cr>

"Buffer - reverse everything ... :)
map <F9> ggVGg?

"Don't close window, when deleting a buffer
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
execute "bdelete! ".l:currentBufNum
endif
endfunction

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files and backup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn backup off
set nobackup
set nowb
set noswapfile
set noar

set backupdir=$VIMDATA/backup
set directory=$VIMDATA/temp
set nowritebackup

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable folding, I find it very useful
set foldenable
set foldlevel=100

"Manual, marker, syntax, trying set foldcolumn=2         
set foldmethod=manual

"Don't autofold
set foldopen-=search
set foldopen-=undo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text option
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set backspace=2
set smarttab
set lbr

"See help formatoptions (complex)
set fo=tcrqnmM

"Wrap long lines at a character in 'breakat'       
set linebreak 

"Maximum width of text that is being inserted        
set textwidth=500

"Wrap lines            
set wrap               

map <leader>t2 :set shiftwidth=2<cr>
map <leader>t4 :set shiftwidth=4<cr>
map <leader>t8 :set shiftwidth=8<cr>

au FileType html,python,vim,javascript setl shiftwidth=4
au FileType html,python,vim,javascript setl tabstop=4

""""""""""""""""""""""""""""""
" => Indent
""""""""""""""""""""""""""""""
"Auto indent
set ai

"Smart indet
set si

"C-style indenting
set cindent

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" => a.vim          - alternate files quickly (.c --> .h etc)
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => supertab.vim   - <Tab> mapped to SuperTab() function
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => lookupfile.vim - file names tags file generated with find
""""""""""""""""""""""""""""""
let g:LookupFile_TagExpr = '"./filenametags"'

""""""""""""""""""""""""""""""
" => calendar.vim   - where to store your diary
""""""""""""""""""""""""""""""
let g:calendar_diary = $VIMDATA.'/diary'

""""""""""""""""""""""""""""""
" => mru.vim        - which file to save mru entries
""""""""""""""""""""""""""""""
let MRU_File = $VIMDATA.'/_vim_mru_files'
let MRU_Max_Entries = 20
 
""""""""""""""""""""""""""""""
" => favmenu.vim    - which file to save favorite items
""""""""""""""""""""""""""""""
let FAV_File = $VIMDATA.'/_vim_fav_files'

""""""""""""""""""""""""""""""
" => timestamp.vim - auto add timestamp to file
""""""""""""""""""""""""""""""
let g:timestamp_regexp = '\v\C%(<Last %([cC]hanged?|[Mm]odified):\s+)@<=.*$'
let g:timestamp_rep = '%w %d/%m/%Y %H:%M:%S #u@#h:#f'
 
""""""""""""""""""""""""""""""
" => doxygentoolkit.vim - map :Dox
""""""""""""""""""""""""""""""
map <leader>d :Dox<cr>

""""""""""""""""""""""""""""""
" => doxygen.vim    - load doxygen syntax file for c/cpp/idl files
""""""""""""""""""""""""""""""
let g:load_doxygen_syntax=1
set syntax=c.doxygen
"let b:current_syntax=
"let b:doxygen_syntax=

""""""""""""""""""""""""""""""
" => vcscommand.vim - svn executable path
""""""""""""""""""""""""""""""
if has("win32")
    let g:VCSCommandSVNExec = 'D:\Program\MinGW\bin\svn.exe'
endif

""""""""""""""""""""""""""""""
" => WindowManager.vim   -  Windows Manager
""""""""""""""""""""""""""""""
"let loaded_winmanager = 1
let g:persistentBehaviour = 0

"map <c-w><c-t> :WMToggle<cr>

let g:bufExplorerSortBy = "name"

"let g:winManagerWindowLayout = 'FileExplorer,TagList|BufExplorer'

let g:winManagerWindowLayout = 'FileExplorer|TagList'

let g:winManagerWidth = 65

let g:bufExplorerMaxHeight =15

""""""""""""""""""""""""""""""
" => Matchit.vim   -
""""""""""""""""""""""""""""""
let b:match_ignorecase = 1

""""""""""""""""""""""""""""""
" => Yank Ring
""""""""""""""""""""""""""""""
map <leader>y :YRShow<cr>

if has('viminfo')
        set vi^=!
endif

let g:yankring_persist = 0

""""""""""""""""""""""""""""""
" => File explorer
""""""""""""""""""""""""""""""
"Split vertically
"let g:explVertical=1

"Window size
"let g:explWinSize=35

"let g:explSplitLeft=1
"let g:explSplitBelow=1

"Hide some file
"let g:explHideFiles='^.,.*.class$,.*.swp$,.*.pyc$,.*.swo$,.DS_Store$'

"Hide the help thing..
let g:explDetailedHelp=0

""""""""""""""""""""""""""""""
" => Minibuffer
""""""""""""""""""""""""""""""
"let g:miniBufExplModSelTarget = 1
"let g:miniBufExplorerMoreThanOne = 0
"let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplVSplit = 25
let g:miniBufExplSplitBelow=1

let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1

""""""""""""""""""""""""""""""
" => Tag list (ctags) -
""""""""""""""""""""""""""""""
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1

"Automatically open the taglist window
"let Tlist_Auto_Open = 1

"let Tlist_WinWidth = 55
"let Tlist_WinHeight = 215

"Which tags files CTR-] will search
if filereadable("./tags")
  set tags=./tags
elseif filereadable("/home/phil/db/tags")
  set tags=/home/phil/db/tags
endif

"if has("win32")
"set path=.,./../**,D:\Program\Vim\MinGW\include
"elseif
"set path=.,./../**,/usr/include/*,,
"endif

"set autochdir

set makeef=makeerror.err

map <leader>t :Tlist<cr>

if has("win32")
let Tlist_Ctags_Cmd = $VIMFILES.'\ctags.exe'
endif

"Order by Name
let Tlist_Sort_Type = "name"

"Split to the right side
"let Tlist_Use_Right_Window = 1

"Show small meny
"let Tlist_Compart_Format = 1

"If you are the last, kill yourself
"let Tlist_Exist_OnlyWindow = 1

"Do not close tags for other files
"let Tlist_File_Fold_Auto_Close = 0

"Do not show folding tree
"let Tlist_Enable_Fold_Column = 0

""""""""""""""""""""""""""""""
" => LaTeX Suite thing
""""""""""""""""""""""""""""""
"set grepprg=grep\ -r\ -s\ -n
"let g:Tex_DefaultTargetFormat="pdf"
"let g:Tex_ViewRule_pdf='xpdf'

"if has("autocmd")
"Binding
"au BufRead *.tex map <silent><leader><space> :w!<cr> :silent! call Tex_RunLaTeX()<cr>

"Auto complete some things ;)
"au BufRead *.tex ino $i indent
"au BufRead *.tex ino $* cdot
"au BufRead *.tex ino $i item
"au BufRead *.tex ino $m [<cr>]<esc>O
"endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Filetype generic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Todo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"au BufNewFile,BufRead *.todo so ~/vim_local/syntax/amido.vim

""""""""""""""""""""""""""""""
" => VIM
""""""""""""""""""""""""""""""
if has("autocmd")
au BufRead,BufNew *.vim map <buffer> <leader><space> :w!<cr>:source %<cr>
endif

""""""""""""""""""""""""""""""
" => HTML related
""""""""""""""""""""""""""""""
" HTML entities - used by xml edit plugin
"let xml_use_xhtml = 1
"let xml_no_auto_nesting = 1

"To HTML
"let html_use_css = 0
"let html_number_lines = 0
"let use_xhtml = 1

""""""""""""""""""""""""""""""
" => Ruby & PHP section
""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
""Run the current buffer in python - ie. on leader+space
"au BufNewFile,BufRead *.py so ~/vim_local/syntax/python.vim
"au BufNewFile,BufRead *.py map <buffer> <leader><space> :w!<cr>:!python %<cr>
"au BufNewFile,BufRead *.py so ~/vim_local/plugin/python_fold.vim

""Set some bindings up for 'compile' of python
"au BufNewFile,BufRead *.py set makeprg=python -c "import py_compile,sys; sys.stderr=sys.stdout; py_compile.compile(r'%')"
"au BufNewFile,BufRead *.py set efm=%C %.%#,%A File "%f"\, line %l%.%#,%Z%[%^ ]%\@=%m
"au BufNewFile,BufRead *.py nmap <buffer> <F8> :w!<cr>:make<cr>

""Python iMap
"au BufNewFile,BufRead *.py set cindent
"au BufNewFile,BufRead *.py ino <buffer> $r return
"au BufNewFile,BufRead *.py ino <buffer> $s self
"au BufNewFile,BufRead *.py ino <buffer> $c ##<cr>#<space><cr>#<esc>kla
"au BufNewFile,BufRead *.py ino <buffer> $i import
"au BufNewFile,BufRead *.py ino <buffer> $p print
"au BufNewFile,BufRead *.py ino <buffer> $d """<cr>"""<esc>O

""Run in the Python interpreter
"function! Python_Eval_VSplit() range
" let src = tempname()
" let dst = tempname()
" execute ": " . a:firstline . "," . a:lastline . "w " . src
" execute ":!python " . src . " > " . dst
" execute ":pedit! " . dst
"endfunction
"au BufNewFile,BufRead *.py vmap <F7> :call Python_Eval_VSplit()<cr>

""""""""""""""""""""""""""""""
" => Cheetah section
"""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""
" => Java section
"""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
"au BufNewFile,BufRead *.js so ~/vim_local/syntax/javascript.vim
"function! JavaScriptFold()
" set foldmethod=marker
" set foldmarker={,}
" set foldtext=getline(v:foldstart)
"endfunction
"au BufNewFile,BufRead *.js call JavaScriptFold()
"au BufNewFile,BufRead *.js imap <c-t> console.log();<esc>hi
"au BufNewFile,BufRead *.js imap <c-a> alert();<esc>hi
"au BufNewFile,BufRead *.js set nocindent
"au BufNewFile,BufRead *.js ino <buffer> $r return

"au BufNewFile,BufRead *.js ino <buffer> $d //<cr>//<cr>//<esc>ka<space>
"au BufNewFile,BufRead *.js ino <buffer> $c /**<cr><space><cr>**/<esc>ka


"if has("eval") && has("autocmd")
"fun! <SID>abbrev_cpp()
"iabbrev <buffer> cci const_iterator
"iabbrev <buffer> ccl cla
"iabbrev <buffer> cco const
"iabbrev <buffer> cdb \bug
"iabbrev <buffer> cde \throw
"iabbrev <buffer> cdf /** \file<CR><CR>/<Up>
"iabbrev <buffer> cdg \ingroup
"iabbrev <buffer> cdn /** \namespace<CR><CR>/<Up>
"iabbrev <buffer> cdp \param
"iabbrev <buffer> cdt \test
"iabbrev <buffer> cdx /**<CR><CR>/<Up>
"iabbrev <buffer> cit iterator
"iabbrev <buffer> cns namespace
"iabbrev <buffer> cpr protected
"iabbrev <buffer> cpu public
"iabbrev <buffer> cpv private
"iabbrev <buffer> csl std::list
"iabbrev <buffer> csm std::map
"iabbrev <buffer> css std::string
"iabbrev <buffer> csv std::vector
"iabbrev <buffer> cty typedef
"iabbrev <buffer> cun using namespace
"iabbrev <buffer> cvi virtual
"iabbrev <buffer> #i #include
"iabbrev <buffer> #d #define
"endfun

"fun! <SID>abbrev_java()
"iabbrev <buffer> #i import
"iabbrev <buffer> #p System.out.println
"iabbrev <buffer> #m public static void main(String[] args
"endfun

"fun! <SID>abbrev_python()
"iabbrev <buffer> #i import
"iabbrev <buffer> #p print
"iabbrev <buffer> #m if __name__=="__main":
"endfun

"augroup abbreviation
"autocmd!
"autocmd FileType cpp,c :call <SID>abbrev_cpp()
"autocmd FileType java :call <SID>abbrev_java()
"autocmd FileType python :call <SID>abbrev_python()
"augroup END
"endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>n :cn<cr>
map <leader>p :cp<cr>
"map <leader>c :botright cw 10<cr>
map <c-u> <c-l><c-j>:q<cr>:botright cw 10<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remove the Windows ^M
noremap <Leader>m :%s/\r//g<CR>

"Paste toggle - when pasting something in, don't indent.
set pastetoggle=<F3>

"Remove indenting on empty line
map <F2> :%s/\s*$//g<cr>:noh<cr>''

"Super paste
ino <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>

"Remove the windows ^M
"noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"Super paste
"inoremap <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>

"Select range, hit :call SuperRetab($width) - by p0g and FallingCow
fu! SuperRetab(width) range
  sil! exe a:firstline.','.a:lastline.'s/\v%(^ *)@<= {'. a:width .'}/\t/g'
endf

"Inserts links & anchors on a TOhtml export.
" Usage:
"   *> Link
"   => Anchor
fu! SmartTOhtml()
  let g:html_use_encoding = toupper(&fileencoding)
  let g:html_use_css = 1
  TOhtml
  try
    %s/&quot;\s\+\*&gt; \(.\+\)</" <a href="#\1" style="color: cyan">\1<\/a></g
    %s/&quot;\(-\|\s\)\+\*&gt; \(.\+\)</" \&nbsp;\&nbsp; <a href="#\2" style="color: cyan;">\2<\/a></g
    %s/&quot;\s\+=&gt; \(.\+\)</" <a name="\1" style="color: #fff">\1<\/a></g
  catch
  endtry
  exe ":w!"
  exe ":bd"
endf
set vb

" Vundle
set nocompatible               " be iMproved
filetype off                   " required!

call vundle#rc()

Bundle 'Textile-for-VIM'
Bundle 'preview'

filetype plugin indent on     " required! 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim: set et ft=vim tw=78 path+=$VIMFILES/* tags+=$VIMRUNTIME/doc/tags:
