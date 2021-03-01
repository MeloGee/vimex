"/////////////////////////////////////////////////////////////////////////////
" basic
"/////////////////////////////////////////////////////////////////////////////

set nocompatible " be iMproved, required

function! OSX()
    return has('macunix')
endfunction
function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function! WINDOWS()
    return  (has('win16') || has('win32') || has('win64'))
endfunction

" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if !exists('g:exvim_custom_path')
    if WINDOWS()
        set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    endif
endif

"/////////////////////////////////////////////////////////////////////////////
" language and encoding setup
"/////////////////////////////////////////////////////////////////////////////

" always use English menu
" NOTE: this must before filetype off, otherwise it won't work
set langmenu=none

" use English for anaything in vim-editor.
if WINDOWS()
    silent exec 'language english'
elseif OSX()
    silent exec 'language en_US'
else
    let s:uname = system("uname -s")
    if s:uname == "Darwin\n"
        " in mac-terminal
        silent exec 'language en_US'
    else
        " in linux-terminal
        silent exec 'language en_US.utf8'
    endif
endif

" try to set encoding to utf-8
if WINDOWS()
    " Be nice and check for multi_byte even if the config requires
    " multi_byte support most of the time
    if has('multi_byte')
        " Windows cmd.exe still uses cp850. If Windows ever moved to
        " Powershell as the primary terminal, this would be utf-8
        set termencoding=cp850
        " Let Vim use utf-8 internally, because many scripts require this
        set encoding=utf-8
        setglobal fileencoding=utf-8
        " Windows has traditionally used cp1252, so it's probably wise to
        " fallback into cp1252 instead of eg. iso-8859-15.
        " Newer Windows files might contain utf-8 or utf-16 LE so we might
        " want to try them first.
        set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
    endif

else
    " set default encoding to utf-8
    set encoding=utf-8
    set termencoding=utf-8
endif
scriptencoding utf-8

"/////////////////////////////////////////////////////////////////////////////
" Bundle steup
"/////////////////////////////////////////////////////////////////////////////

" vundle#begin
filetype off " required

" set the runtime path to include Vundle
if exists('g:exvim_custom_path')
    let g:ex_tools_path = g:exvim_custom_path.'/vimfiles/tools/'
    exec 'set rtp+=' . fnameescape ( g:exvim_custom_path.'/vimfiles/bundle/Vundle.vim/' )
    call vundle#rc(g:exvim_custom_path.'/vimfiles/bundle/')
else
    let g:ex_tools_path = '~/.vim/tools/'
    set rtp+=~/.vim/bundle/Vundle.vim/
    call vundle#rc('~/.vim/bundle/')
    Plugin 'fatih/vim-go'
    Plugin 'bling/vim-airline'
    Plugin 'zivyangll/git-blame.vim'
endif


"/////////////////////////////////////////////////////////////////////////////
" Git info plugin steup
"/////////////////////////////////////////////////////////////////////////////
nnoremap <Leader>f :<C-u>call gitblame#echo()<CR>

" load .vimrc.plugins & .vimrc.plugins.local
if exists('g:exvim_custom_path')
    let vimrc_plugins_path = g:exvim_custom_path.'/.vimrc.plugins'
    let vimrc_plugins_local_path = g:exvim_custom_path.'/.vimrc.plugins.local'
else
    let vimrc_plugins_path = '~/.vimrc.plugins'
    let vimrc_plugins_local_path = '~/.vimrc.plugins.local'
endif
if filereadable(expand(vimrc_plugins_path))
    exec 'source ' . fnameescape(vimrc_plugins_path)
endif
if filereadable(expand(vimrc_plugins_local_path))
    exec 'source ' . fnameescape(vimrc_plugins_local_path)
endif

" vundle#end
filetype plugin indent on " required
syntax on " required

"/////////////////////////////////////////////////////////////////////////////
" General
"/////////////////////////////////////////////////////////////////////////////

"set path=.,/usr/include/*,, " where gf, ^Wf, :find will search
set backup " make backup file and leave it around

" setup back and swap directory
let data_dir = $HOME.'/.data/'
let backup_dir = data_dir . 'backup'
let swap_dir = data_dir . 'swap'
if finddir(data_dir) == ''
    silent call mkdir(data_dir)
endif
if finddir(backup_dir) == ''
    silent call mkdir(backup_dir)
endif
if finddir(swap_dir) == ''
    silent call mkdir(swap_dir)
endif
unlet backup_dir
unlet swap_dir
unlet data_dir

set backupdir=$HOME/.data/backup " where to put backup file
set directory=$HOME/.data/swap " where to put swap file

" Redefine the shell redirection operator to receive both the stderr messages and stdout messages
set shellredir=>%s\ 2>&1
set history=50 " keep 50 lines of command line history
set updatetime=1000 " default = 4000
set autoread " auto read same-file change ( better for vc/vim change )
set maxmempattern=1000 " enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)

"/////////////////////////////////////////////////////////////////////////////
" xterm settings
"/////////////////////////////////////////////////////////////////////////////

behave xterm  " set mouse behavior as xterm
if &term =~ 'xterm'
    "set mouse=a
    set mouse=v
endif

"/////////////////////////////////////////////////////////////////////////////
" Variable settings ( set all )
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------
" Desc: Visual
" ------------------------------------------------------------------

set matchtime=0 " 0 second to show the matching paren ( much faster )
set nu " show line number
set scrolloff=0 " minimal number of screen lines to keep above and below the cursor
set nowrap " do not wrap text

" only supoort in 7.3 or higher
if v:version >= 703
    set noacd " no autochchdir
endif

" set default guifont
if has('gui_running')
    augroup ex_gui_font
        " check and determine the gui font after GUIEnter.
        " NOTE: getfontname function only works after GUIEnter.
        au!
        au GUIEnter * call s:set_gui_font()
    augroup END

    " set guifont
    function! s:set_gui_font()
        if has('gui_gtk2')
            if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
            elseif getfontname( 'DejaVu Sans Mono' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ 12
            else
                set guifont=Luxi\ Mono\ 12
            endif
        elseif has('x11')
            " Also for GTK 1
            set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
        elseif OSX()
            if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h15
            elseif getfontname( 'DejaVu Sans Mono' ) != ''
                set guifont=DejaVu\ Sans\ Mono:h15
            endif
        elseif WINDOWS()
            if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11:cANSI
            elseif getfontname( 'DejaVu Sans Mono' ) != ''
                set guifont=DejaVu\ Sans\ Mono:h11:cANSI
            elseif getfontname( 'Consolas' ) != ''
                set guifont=Consolas:h11:cANSI " this is the default visual studio font
            else
                set guifont=Lucida_Console:h11:cANSI
            endif
        endif
    endfunction
endif

" ------------------------------------------------------------------
" Desc: Vim UI
" ------------------------------------------------------------------

set wildmenu " turn on wild menu, try typing :h and press <Tab>
set showcmd " display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line
set ruler " show the cursor position all the time
set hidden " allow to change buffer without saving
set shortmess=aoOtTI " shortens messages to avoid 'press a key' prompt
set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line
set titlestring=%t\ (%{expand(\"%:p:.:h\")}/)

" set window size (if it's GUI)
if has('gui_running')
    " set window's width to 130 columns and height to 40 rows
    if exists('+lines')
        set lines=40
    endif
    if exists('+columns')
        set columns=130
    endif

    " DISABLE
    " if WINDOWS()
    "     au GUIEnter * simalt ~x " Maximize window when enter vim
    " else
    "     " TODO: no way right now
    " endif
endif

set showfulltag " show tag with function protype.
set guioptions+=b " present the bottom scrollbar when the longest visible line exceed the window

" disable menu & toolbar
set guioptions-=m
set guioptions-=T

" ------------------------------------------------------------------
" Desc: Text edit
" ------------------------------------------------------------------

set ai " autoindent
set si " smartindent
set backspace=indent,eol,start " allow backspacing over everything in insert mode
" indent options
" see help cinoptions-values for more details
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30
" default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
" set cinkeys=0{,0},0),:,!^F,o,O,e

" official diff settings
set diffexpr=g:MyDiff()
function! g:MyDiff()
    let opt = '-a --binary -w '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    silent execute '!' .  'diff ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
endfunction

set cindent shiftwidth=4 " set cindent on to autoinent when editing c/c++ file, with 4 shift width
set tabstop=4 " set tabstop to 4 characters
set expandtab " set expandtab on, the tab will be change to space automaticaly
set ve=block " in visual block mode, cursor can be positioned where there is no actual character

" set Number format to null(default is octal) , when press CTRL-A on number
" like 007, it would not become 010
set nf=

" ------------------------------------------------------------------
" Desc: Fold text
" ------------------------------------------------------------------

set foldmethod=marker foldmarker={,} foldlevel=9999
set diffopt=filler,context:9999

" ------------------------------------------------------------------
" Desc: Search
" ------------------------------------------------------------------

set showmatch " show matching paren
set incsearch " do incremental searching
set hlsearch " highlight search terms
set ignorecase " set search/replace pattern to ignore case
set smartcase " set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

" set this to use id-utils for global search
set grepprg=lid\ -Rgrep\ -s
set grepformat=%f:%l:%m

"/////////////////////////////////////////////////////////////////////////////
" Auto Command
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------
" Desc: Only do this part when compiled with support for autocommands.
" ------------------------------------------------------------------

if has('autocmd')

    augroup ex
        au!

        " ------------------------------------------------------------------
        " Desc: Buffer
        " ------------------------------------------------------------------

        " when editing a file, always jump to the last known cursor position.
        " don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        au BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
        au BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
        au BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
        au BufNewFile,BufRead *.avs set syntax=avs " for avs syntax file.

        " DISABLE {
        " NOTE: will have problem with exvim, because exvim use exES_CWD as working directory for tag and other thing
        " Change current directory to the file of the buffer ( from Script#65"CD.vim"
        " au   BufEnter *   execute ":lcd " . expand("%:p:h")
        " } DISABLE end

        " ------------------------------------------------------------------
        " Desc: file types
        " ------------------------------------------------------------------

        au FileType text setlocal textwidth=78 " for all text files set 'textwidth' to 78 characters.
        au FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.

        " disable auto-comment for c/cpp, lua, javascript, c# and vim-script
        au FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
        au FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://
        au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
        au FileType lua set comments=f:--

        " if edit python scripts, check if have \t. ( python said: the programme can only use \t or not, but can't use them together )
        au FileType python,coffee call s:check_if_expand_tab()
    augroup END

    function! s:check_if_expand_tab()
        let has_noexpandtab = search('^\t','wn')
        let has_expandtab = search('^    ','wn')

        "
        if has_noexpandtab && has_expandtab
            let idx = inputlist ( ['ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
                        \ '1. expand (tab=space, recommended)',
                        \ '2. noexpand (tab=\t, currently have risk)',
                        \ '3. do nothing (I will handle it by myself)'])
            let tab_space = printf('%*s',&tabstop,'')
            if idx == 1
                let has_noexpandtab = 0
                let has_expandtab = 1
                silent exec '%s/\t/' . tab_space . '/g'
            elseif idx == 2
                let has_noexpandtab = 1
                let has_expandtab = 0
                silent exec '%s/' . tab_space . '/\t/g'
            else
                return
            endif
        endif

        "
        if has_noexpandtab == 1 && has_expandtab == 0
            echomsg 'substitute space to TAB...'
            set noexpandtab
            echomsg 'done!'
        elseif has_noexpandtab == 0 && has_expandtab == 1
            echomsg 'substitute TAB to space...'
            set expandtab
            echomsg 'done!'
        else
            " it may be a new file
            " we use original vim setting
        endif
    endfunction
endif

"/////////////////////////////////////////////////////////////////////////////
" Key Mappings
"/////////////////////////////////////////////////////////////////////////////

" NOTE: F10 looks like have some feature, when map with F10, the map will take no effects

" Don't use Ex mode, use Q for formatting
map Q gq

" define the copy/paste judged by clipboard
if &clipboard ==# 'unnamed'
    " fix the visual paste bug in vim
    " vnoremap <silent>p :call g:()<CR>
else
    " general copy/paste.
    " NOTE: y,p,P could be mapped by other key-mapping
    map <leader>y "*y
    map <leader>p "*p
    map <leader>P "*P
endif

" copy folder path to clipboard, foo/bar/foobar.c => foo/bar/
nnoremap <silent> <leader>y1 :let @*=fnamemodify(bufname('%'),":p:h")<CR>

" copy file name to clipboard, foo/bar/foobar.c => foobar.c
nnoremap <silent> <leader>y2 :let @*=fnamemodify(bufname('%'),":p:t")<CR>

" copy full path to clipboard, foo/bar/foobar.c => foo/bar/foobar.c
nnoremap <silent> <leader>y3 :let @*=fnamemodify(bufname('%'),":p")<CR>

" F8 or <leader>/:  Set Search pattern highlight on/off
nnoremap <F8> :let @/=""<CR>
nnoremap <leader>/ :let @/=""<CR>
" DISABLE: though nohlsearch is standard way in Vim, but it will not erase the
"          search pattern, which is not so good when use it with exVim's <leader>r
"          filter method
" nnoremap <F8> :nohlsearch<CR>
" nnoremap <leader>/ :nohlsearch<CR>

" map Ctrl-Tab to switch window
nnoremap <S-Up> <C-W><Up>
nnoremap <S-Down> <C-W><Down>
nnoremap <S-Left> <C-W><Left>
nnoremap <S-Right> <C-W><Right>

" easy buffer navigation
" NOTE: if we already map to EXbn,EXbp. skip setting this
if !hasmapto(':EXbn<CR>') && mapcheck('<C-l>','n') == ''
    nnoremap <C-l> :bn<CR>
endif
if !hasmapto(':EXbp<CR>') && mapcheck('<C-h>','n') == ''
    noremap <C-h> :bp<CR>
endif

" easy diff goto
noremap <C-k> [c
noremap <C-j> ]c

" enhance '<' '>' , do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

" map Up & Down to gj & gk, helpful for wrap text edit
noremap <Up> gk
noremap <Down> gj
nnoremap <silent> <leader>sw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<cr><c-o>

"/////////////////////////////////////////////////////////////////////////////
" local setup
"/////////////////////////////////////////////////////////////////////////////

let vimrc_local_path = '~/.vimrc.local'
if exists('g:exvim_custom_path')
    let vimrc_local_path = g:exvim_custom_path.'/.vimrc.local'
endif

if filereadable(expand(vimrc_local_path))
    exec 'source ' . fnameescape(vimrc_local_path)
endif
" vim:ts=4:sw=4:sts=4 et fdm=marker:

" base tabs
set expandtab
set tabstop=4
set shiftwidth=4
"let g:auto_save = 1  " enable AutoSave on Vim startup

" xterm info setting
syntax on
if &term =~ "xterm"
  if has("terminfo")
    set t_Co=8
    set t_Sf=^[[3%p1%dm
    set t_Sb=^[[4%p1%dm
  else
    set t_Co=8
    set t_Sf=^[[3%dm
    set t_Sb=^[[4%dm
  endif
endif

"/////////////////////////////////////////////////////////////////////////////
" 至此，以上为整套配置的系统配置，不建议改动。
" 以下，为用户配置，可根据需求自由改动，如主题配色/中文编码等...
"/////////////////////////////////////////////////////////////////////////////
"
"                    ,----------------,              ,---------,
"                ,-----------------------,          ,"        ,"|
"              ,"                      ,"|        ,"        ,"  |
"             +-----------------------+  |      ,"        ,"    |
"             |  .-----------------.  |  |     +---------+      |
"             |  |                 |  |  |     | -==----'|      |
"             |  |  PornHub...     |  |  |     |         |      |
"             |  |                 |  |  |/----|`---=    |      |
"             |  |  Oh, yes!       |  |  |   ,/|==== ooo |      ;
"             |  |                 |  |  |  // |(((([Orz]|    ,"
"             |  `-----------------'  |," .;'| |((((     |  ,"
"             +-----------------------+  ;;  | |         |,"
"                /_)______________(_/  //'   | +---------+
"           ___________________________/___  `,
"          /  oooooooooooooooo  .o.  oooo /,   \,"-----------
"         / ==ooooooooooooooo==.o.  ooo= //   ,`\--{)B     ,"
"        /_==__==========__==_ooo__ooo=_/'   /___________,"
"
"/////////////////////////////////////////////////////////////////////////////

" 主题配色设置
set background=dark
"let g:solarized_termcolors = 16
"colorscheme solarized
colorscheme mycolors

" 光标聚焦线开启
set cursorline
set cursorcolumn

" must be at last
set t_Co=256

" 函数高亮设置
" hilight function name
autocmd BufNewFile,BufRead,BufWritePost * : syntax match cfunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
autocmd BufNewFile,BufRead,BufWritePost * : syntax match cfunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1

" highlight c function name
"autocmd BufNewFile,BufRead,BufWritePost * : syntax match cfunctions "::\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
"autocmd BufNewFile,BufRead,BufWritePost * : syntax match cfunctions "::\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1

" highlight c class function
autocmd BufNewFile,BufRead,BufWritePost * : syntax match cClassFunc "\<[a-zA-Z_][a-zA-Z_0-9]*\>::"me=e-2

" 部分高亮颜色微调设置
" 关键词设置
hi cfunctions            ctermfg=187  cterm=bold                  "函数
hi cClassFunc            ctermfg=187 cterm=bold                   "C class function
"hi Type                  ctermfg=202 cterm=bold                  "变量
"hi Normal                ctermfg=248 guibg=#292099               "普通文字颜色以及背景色
"hi Structure             ctermfg=161                             "结构体 类 namespace class struct
"hi Macro                 ctermfg=118                             "宏
"hi PreCondit             ctermfg=118                             "预处理
"hi Comment               ctermfg=29                              "注释
"hi Todo                  ctermfg=243 ctermbg=190                 "TODO
"hi Typedef               ctermfg=81                              "typedef
"hi Statement             ctermfg=161                             "return import package等
"hi StatusLine            ctermfg=238 ctermbg=253                 "状态栏
"hi StatusLineNC          ctermfg=244 ctermbg=232

" 变量右值颜色设置
"hi Boolean               ctermfg=135
"hi Float                 ctermfg=135                              "浮点型
"hi Character             ctermfg=157                              "字符
"hi Number                ctermfg=135                              "数字
"hi String                ctermfg=157                              "字符串
"hi Conditional           ctermfg=161 cterm=bold                   "条件语句
"hi Constant              ctermfg=161 cterm=bold
"hi Cursor                ctermfg=16  ctermbg=253
"hi Debug                 ctermfg=225 cterm=bold
"hi Define                ctermfg=81
"hi Delimiter             ctermfg=241
"hi Exception             ctermfg=124 cterm=bold                   "try catch 异常处理
"hi StorageClass          ctermfg=124 cterm=bold                   "const static关键字颜色
"hi Operator              ctermfg=161                              "C++操作符重载
"hi Keyword               ctermfg=202 cterm=bold

" 光标聚焦线设置
"hi Cursorline ctermbg=237 cterm=underline
"hi CursorColumn ctermbg=237

" 功能设置
"hi Search                ctermfg=15  cterm=bold  ctermbg=66       "关键词搜索颜色设置
"hi Pmenu                 ctermfg=88  cterm=bold  ctermbg=15       "自动补全框颜色
"hi PmenuSel              ctermfg=88  cterm=bold  ctermbg=45       "自动补全框颜色
"hi PmenuSbar             ctermbg=88  cterm=bold                   "自动补全框颜色
"hi PmenuThumb            ctermfg=81

" vim diff
"hi DiffAdd               ctermbg=24
"hi DiffChange            ctermfg=181 ctermbg=239
"hi DiffDelete            ctermfg=162 ctermbg=53
"hi DiffText              ctermbg=102 cterm=bold

" 更多设置
"hi Tag                   ctermfg=161
"hi Title                 ctermfg=166
"hi Underlined            ctermfg=244 cterm=underline
"hi VertSplit             ctermfg=244 ctermbg=232 cterm=bold
"hi VisualNOS             ctermbg=238
"hi Visual                ctermbg=235
"hi WarningMsg            ctermfg=231 ctermbg=238 cterm=bold
"hi WildMenu              ctermfg=81  ctermbg=16
"hi LineNr                ctermfg=250 ctermbg=234
"hi NonText               ctermfg=250 ctermbg=234
"hi SpecialKey            ctermfg=178
"hi Special               ctermfg=178                              "%d等特殊符号
"hi SpecialChar           ctermfg=178 cterm=bold
"hi SignColumn            ctermfg=118 ctermbg=235
"hi SpecialComment        ctermfg=245 cterm=bold
"hi PreCondit             ctermfg=118 cterm=bold
"hi PreProc               ctermfg=118
"hi Question              ctermfg=81
"hi Repeat                ctermfg=161 cterm=bold
"hi MatchParen            ctermfg=16  ctermbg=208 cterm=bold
"hi ModeMsg               ctermfg=229
"hi MoreMsg               ctermfg=229
"hi Label                 ctermfg=229 cterm=none
"hi Directory             ctermfg=118 cterm=bold
"hi Error                 ctermfg=219 ctermbg=89
"hi ErrorMsg              ctermfg=199 ctermbg=16  cterm=bold
"hi FoldColumn            ctermfg=67  ctermbg=16
"hi Folded                ctermfg=67  ctermbg=16
"hi Function              ctermfg=118
"hi Identifier            ctermfg=208
"hi Ignore                ctermfg=244 ctermbg=232

" 解决中文乱码问题， 终端iterm2保持utf-8即可
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set helplang=cn

" 系统函数跳转
"set tags+=~/.vim/systags

set ts=4
set expandtab
set autoindent
