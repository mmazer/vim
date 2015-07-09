" 1: important {{{
set nocompatible
" disable before calling vundle
filetype off

" set this here because of unicode chars in listchars below
set encoding=utf-8

" bundles {{{
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" color schemes
Plugin 'dhruvasagar/vim-railscasts-theme'
Plugin 'mmazer/vim-github-colorscheme'
Plugin 'ajh17/Spacegray.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

Plugin 'gmarik/vundle'
Plugin 'mattn/emmet-vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'mattn/ctrlp-mark'
Plugin 'mattn/ctrlp-register'
Plugin 'rking/ag.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'tpope/vim-characterize'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-dispatch'
Plugin 'Raimondi/delimitMate'
Plugin 'Shougo/neocomplete.vim'
Plugin 'SirVer/ultisnips'
Plugin 'scrooloose/nerdtree'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'majutsushi/tagbar'
Plugin 'mattn/calendar-vim'
Plugin 'jeetsukumaran/vim-filebeagle'
Plugin 'sgur/ctrlp-extensions.vim'
Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'chrisbra/vim-diff-enhanced'

" git
Plugin 'int3/vim-extradite'

" file types
Plugin 'tpope/vim-markdown'
Plugin 'scrooloose/syntastic'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'elzr/vim-json'
Plugin 'davidoc/taskpaper.vim'
Plugin 'groenewege/vim-less'
Plugin 'ap/vim-css-color'
Plugin 'Shutnik/jshint2.vim'
Plugin 'vim-scripts/paredit.vim'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'mmazer/groovyindent'
Plugin 'chrisbra/csv.vim'

"Plugin 'eclim', {'pinned': 1}

call vundle#end()
"}}}

"}}}

" 2: moving around, searching and patterns {{{

set incsearch
set hlsearch
set ignorecase
set smartcase   "case sensitive if search term contains upppecase letter

" }}}

" 3: tags {{{
" }}}

" 4: displaying text {{{
set scrolloff=2
set listchars=tab:▸\ ,trail:·,nbsp:¬
set wrap linebreak textwidth=0
set number
augroup insert_number
    autocmd InsertEnter * set norelativenumber
    autocmd InsertLeave * set relativenumber
augroup END
" }}}

" 5: syntax, highligthing and spelling {{{1

filetype plugin indent on
syntax on
syntax sync minlines=256
set cursorline

set spelllang=en
set spellfile=~/.vim/spell/spellfile.en.add
" }}}

" 6: multiple windows {{{1
set hidden
set splitbelow
set splitright

" status line
set laststatus=2
set statusline=%{Mode()}
set statusline+=%{&paste?'\ (paste)':'\ '}
set statusline+=\|
set statusline+=\ %{Branch()}
set statusline+=\ %f
set statusline+=\ \[\#%n\]
set statusline+=%(\[%R%M\]%)      "modified flag
set statusline+=\ %{SyntasticStatuslineFlag()}
set statusline+=%=
set statusline+=\ %{StatuslineWhitespace()}
set statusline+=\ %y      "filetype
set statusline+=\ %{Fenc()} " file encoding
set statusline+=\[%{&ff}\]  "file format
set statusline+=\ %5.l/%L\:%c\    "cursor line/total lines:column

" Adapted from https://github.com/maciakl/vim-neatstatus
function! Mode()
    "redraw
    if &ft ==? "help"
        return "Help"
    endif

    if &ft ==? "diff"
        return "Diff"
    endif

    let l:mode = mode()

    if     mode ==# "n"  | return "NOR"
    elseif mode ==# "i"  | return "INS"
    elseif mode ==# "c"  | return "COM"
    elseif mode ==# "!"  | return "SHE"
    elseif mode ==# "R"  | return "REP"
    elseif mode ==# "v"  | return "VIS"
    elseif mode ==# "V"  | return "V-L"
    elseif mode ==# ""   | return "V-B"
    else                 | return l:mode
    endif
endfunction

function! Branch()
    let branch = ''
    if !exists('*fugitive#head')
        return branch
    endif

    let branch = fugitive#statusline()
    return branch
endfunction

function! Fenc()
    if &fenc !~ "^$\|utf-8" || &bomb
        return &fenc . (&bomb ? "-bom" : "" )
    else
        return "none"
    endif
endfun

" Detect trailing whitespace and mixed indentation
" Based on http://got-ravings.blogspot.ca/2008/10/vim-pr0n-statusline-whitespace-flags.html
function! StatuslineWhitespace()
    if &readonly || !&modifiable
        return ''
    endif

    if exists("b:statusline_whitespace")
        return b:statusline_whitespace
    endif

    let trailing = search('\s\+$', 'nw') != 0
    if trailing
        let trailing_warning = 'trail'
     else
        let trailing_warning = ''
     endif

     " check indents
    let tabs = search('^\t', 'nw') != 0
    let spaces = search('^ ', 'nw') != 0
    let mixed = tabs && spaces

    if mixed
        let tab_warning = 'mixed'
    elseif (spaces && !&et) || (tabs && &et)
        let tab_warning = '&et'
    else
        let tab_warning = ''
    endif

    if trailing || mixed
        let whitespace_warning = '['.trailing_warning
        if trailing && mixed
            let whitespace_warning.=':'
        endif
        let whitespace_warning.=tab_warning.']'
        let b:statusline_whitespace = whitespace_warning
    else
        let b:statusline_whitespace = ''
    endif

    return b:statusline_whitespace
endfunction

"recalculate the trailing whitespace warning when idle, and after saving
augroup statusline_whitespace
    autocmd CursorHold,BufWritePost * unlet! b:statusline_whitespace
augroup END

" }}}

" 7: multiple tab pages {{{1
" }}}

" 8: terminal {{{1

" }}}

" 9: using the mouse {{{1
" }}}

" 10: GUI {{{1

if has("gui_running")
    colorscheme spacegray
    set antialias
    if has('mac')
        set guifont=DejaVu\ Sans\ Mono:h12
    elseif has('win32')
        set guioptions-=m " Remove menu bar to save space
        set guioptions+=a " Yank to system clipboard
        set guifont=DejaVu_Sans_Mono:h8:cANSI
        set renderoptions=type:directx,gamma:1.0,contrast:0.2,level:1.0,geom:1,renmode:5,taamode:1
        set ttyscroll=3 " Fix gvim display corruption on Windows
    endif
    set guioptions-=T " remove tool bar
    set guioptions-=r " remove right-hand scroll bar
    set guioptions-=L " remove left-hand scroll bar
    set lines=90
    set columns=145
else
    set t_Co=256
    colorscheme railscasts
endif

" }}}

" 11: printing {{{1
" }}}

" 12: messages and info {{{1

set shortmess=aTItoO
set ruler
set noshowcmd
" disable bell/visual bell
set noeb vb t_vb=
augroup visual_bell
    autocmd GUIEnter * set vb t_vb=
augroup END

" }}}

" 13: selecting text {{{1
" }}}

" 14: editing text {{{1

set completeopt=longest,menuone,preview
set showmatch
runtime macros/matchit.vim

" }}}

" 15: tabs and indenting {{{1

set expandtab
set shiftwidth=4
set softtabstop=4
let g:html_indent_inctags = "html,body,head,tbody"

" }}}

" 16: folding {{{1

set foldmethod=syntax                   "fold based on indent
set foldnestmax=2                       "deepest fold is 10 levels
set nofoldenable                        "don't fold by default
let g:xml_syntax_folding=1              "enable xml folding

nnoremap <Space>z za
vnoremap <Space>z za

" refocus fold under cursor - from Steve Losh
nnoremap ,z zMzvzz

"http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
function! CustomFoldText()
    "get first non-blank line
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif

    let w = winwidth(0) - &foldcolumn - (&numberend ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " (" . foldSize . " lines) "
    let foldLevelStr = repeat("+--", v:foldlevel)
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
    let marker = "» "
    let expansionString = repeat(".", w - strwidth(marker.foldSizeStr.line.foldLevelStr.foldPercentage))
    "return marker . line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
    return marker . line . foldSizeStr
endfunction
set foldtext=CustomFoldText()

" }}}

" 17: diff mode {{{1
" }}}

" 18: mapping {{{1

" try to reduce delays waiting for multi-key combinations in tmux
" tmux needs `set -s escape-time 0` for these to work
set ttimeout timeout ttimeoutlen=125

"keep original motion: repeat latest f, t, F or T in opposite direction
noremap ,, ,
let mapleader = ","
let g:mapleader = ","

nnoremap g<space> :

nnoremap g[ gg
nnoremap g] G

" Better mark jumping (line + col)
nnoremap <expr> ' printf('`%c zz', getchar())

" for toggling paste mode in terminal
" Can also use `yo` from `unimpaired`
set pastetoggle=<F5>
nnoremap \p "*p

" For wrapped lines, navigate normally
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

inoremap <C-A> <C-o>^
inoremap <C-E> <C-o>$

nnoremap <silent> Q :qa!<CR>

noremap \\v :e ~/.vim/vimrc<CR>
noremap \\sv :so ~/.vim/vimrc<CR>

nnoremap <space>W :w!<CR>
" for use in terminal - c-s must be disabled using stty -ixon
nnoremap <C-s> :w!<CR>
inoremap <C-s> <C-o>:w!<CR>
nnoremap <space>w :w<CR>
nnoremap <space>B :b#<CR>
nnoremap <space>d :bd<CR>
" use bufkill BD command to close buffer but not window
nnoremap <space>D :BD<CR>
nnoremap \\b :Bonly<CR>

" goto buffer
nnoremap gb :ls<CR>:b

nmap <space><space> :

" Source lines - from Steve Losh
vnoremap X y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap X ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Avoid the escape key - remember <C-[> also maps to Esc
inoremap kj <ESC>`^

" Prefer to use Perl/Ruby style regex patterns
" See http://briancarper.net/blog/448/
nnoremap / /\v
vnoremap / /\v

nnoremap <space>j J

nnoremap K H
nnoremap J L
noremap H ^
noremap L $
vnoremap L g_

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
nnoremap <silent> <leader>d "_d
vnoremap <silent> <leader>d "_d

" Quick yanking to the end of the line
nnoremap Y y$

" manage windows
nnoremap W <C-w>

" window navigation: use ctrl-h/j/k/l to switch between splits
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Resize windows using a reasonable amount
" http://flaviusim.com/blog/resizing-vim-window-splits-like-a-boss/
noremap <silent> <S-Up> :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <S-Down> :exe "resize " . (winheight(0) * 2/3)<CR>

" tab navigation
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap td  :tabclose<CR>

" center window when moving to next search match
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" toggling following vim-unimpaired
nnoremap [of :setlocal foldcolumn=3<CR>
nnoremap ]of :setlocal foldcolumn=0<CR>

" make it easier to work with some text objects
vnoremap ir i]
vnoremap ar a]
vnoremap ia i>
vnoremap aa a>
onoremap ir i]
onoremap ar a]
onoremap ia i>
onoremap aa a>

nnoremap <space>h :h<space>
nnoremap gh :h<space>

" indent the whole file and return to original position
nmap <space>if gg=G``

" Remove trailing space
nnoremap <space>sw :call StripTrailingWhitespace()<CR>

nmap _= :call Preserve("normal gg=G")<CR>

" Select (charwise) the contents of the current line, excluding indentation.
" Borrowed from Steve Losh https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc
inoremap vv ^vg_

" set current working directory
nnoremap <space>cd :call Setcwd()<cr>

" quick fix window
nnoremap oq :copen<CR>
nnoremap qq :cclose<CR>

nnoremap ol :lopen<CR>
nnoremap ql :lclose<CR>

" end lines with semicolons
inoremap ;] <C-o>:call Preserve("s/\\s\*$/;/")<CR>
nnoremap <space>; :call Preserve("s/\\s\*$/;/")<CR>

" end lines with comma
inoremap ,] <C-o>:s/\s*$/,/<CR>
nnoremap <space>, :call Preserve("s/\\s\*$/,/")<CR>

noremap <C-U> i<ESC>:redraw!<CR>
inoremap <C-U> <ESC>:redraw!<CR>i
command! RR :redraw!

inoremap <C-P> <C-X><C-U>

" Insert new lines in normal mode
" Also available through vim-unimpaired [<space> and ]<space>
nnoremap <S-Enter> O<ESC>j
nnoremap <Enter> o<ESC>k

" toggle case of words
nnoremap [w gUiw
nnoremap ]w guiw

" http://vim.wikia.com/wiki/Show_the_length_of_the_current_word
nnoremap <C-_> :echo 'length of' expand('<cword>') 'is' strlen(substitute(expand('<cword>'), '.', 'x', 'g'))<CR>
" }}}

" 19: reading and writing files {{{1

set modeline
set ffs=unix,dos,mac "Default file types
set ff=unix " set initial buffer file format
set backup
set backupdir=$HOME/.var/vim/backup//
set autoread

nnoremap g! :e!<CR>
" }}}

" 20: swap file {{{1

set noswapfile
set directory=$HOME/.var/vim/swp//

"}}}

" 21: command line editing {{{1
set wildmenu
set wildmode=longest,list

set wildignore+=.hg,.git,.svn,CVS,target,.settings
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.class,*.jar,*.war,*.o,*.obj,*.exe,*.dll
set wildignore+=*.DS_Store
set wildignore+=*.orig      " merge resolution files

" }}}

" 22: executing external commands {{{1
" }}}

" 23: running make and jumping to errors {{{1

if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
endif

" }}}

" 24: system specific {{{1
" }}}

" 25: language specific {{{1

" }}}

" 26: multi-byte characters {{{1

" }}}

" 27: various: autocmd {{{

" autocommands {{{
if has("autocmd")
    " remove trailing whitespace
    augroup trailing_whitespace
        autocmd! FileType vim,css,groovy,java,javascript,less,php,scala,taskpaper autocmd BufWritePre <buffer> :%s/\s\+$//e
    augroup END

    augroup keyword
        autocmd FileType html,css,javascript setlocal iskeyword+=-
    augroup END

    augroup javascript_files
        autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 foldmethod=indent
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    augroup END

    augroup jsx_files
        autocmd FileType jsx setlocal shiftwidth=2 softtabstop=2 foldmethod=indent
        autocmd FileType jsx setlocal omnifunc=javascriptcomplete#CompleteJS
    augroup END

    augroup vim_files
        autocmd filetype vim set foldmethod=marker
    augroup END

    augroup html_files
        autocmd FileType html setlocal shiftwidth=2 softtabstop=2 tabstop=2 foldmethod=manual
        autocmd FileType html setlocal autoindent
    augroup END

    augroup jsp_files
        autocmd FileType jsp setlocal shiftwidth=2 softtabstop=2 tabstop=2 foldmethod=manual autoindent
    augroup END

    augroup gsp_files
        autocmd FileType gsp setlocal shiftwidth=2 softtabstop=2 tabstop=2 foldmethod=manual
    augroup END

    augroup java_files
        autocmd filetype java compiler maven
        autocmd FileType java setlocal foldmethod=syntax
        autocmd FileType java setlocal comments=sl:/**,mb:\ *,exl:\ */,sr:/*,mb:*,exl:*/,://
        " hide completion scatch window when using eclim
        autocmd FileType java setlocal completeopt-=preview
    augroup END

    augroup css_files
        autocmd FileType css setlocal  omnifunc=csscomplete#CompleteCSS
        autocmd FileType css setlocal shiftwidth=2 softtabstop=2 tabstop=2 foldmethod=syntax
    augroup END

    augroup less_files
        autocmd FileType less setlocal omnifunc=csscomplete#CompleteCSS
    augroup END

    augroup jmeter_files
        autocmd! BufRead *.jtl setlocal ft=text
    augroup END

    augroup json_files
        autocmd FileType json command! Format :%!python -m json.tool<CR>
        autocmd FileType json setlocal foldmethod=syntax
        autocmd FileType json setlocal foldnestmax=10
    augroup END

    augroup xml_files
        autocmd FileType xml setlocal shiftwidth=2 softtabstop=2 tabstop=2 foldmethod=syntax
    augroup END

    augroup wsdl_files
        autocmd! BufRead *.wsdl setlocal ft=xml
    augroup END

    augroup taskpaper_files
        autocmd FileType taskpaper setlocal noexpandtab
    augroup END

    augroup fugitive_buffers
        autocmd BufRead fugitive\:* xnoremap <buffer> dp :diffput<CR>|xnoremap <buffer> do :diffget<CR>
        autocmd BufReadPost fugitive://* set bufhidden=delete
        autocmd FileType gitcommit setlocal cursorline
    augroup END

    augroup markdown_files
        autocmd BufNewFile,BufRead *.md,*.mkd,*.markdown setlocal wrap linebreak nolist
    augroup END

    augroup diff_mode
        autocmd FilterWritePre * if &diff | nnoremap <buffer> dc :Gdoff<CR> | nnoremap <buffer> du :diffupdate<CR> | endif
    augroup END

    augroup conf_files
        autocmd! BufRead *.conf setlocal ft=conf
        autocmd FileType conf setlocal shiftwidth=2 softtabstop=2 tabstop=2 foldmethod=manual autoindent
    augroup END
endif "}}}
" }}}

" 28: plugin settings {{{1

" ctrlp:
nmap <space> [ctrlp]
nnoremap <silent> [ctrlp]a :<C-u>CtrlPBookmarkDirAdd<cr>
nnoremap <silent> [ctrlp]b :<C-u>CtrlPBuffer<cr>
nnoremap <silent> [ctrlp]c :<C-u>CtrlPCmdline<cr>
nnoremap <silent> [ctrlp]C :<C-u>CtrlPClearCache<cr>
nnoremap <silent> [ctrlp]d :<C-u>CtrlPDir<cr>
nnoremap <silent> [ctrlp]f :<C-u>CtrlP<cr>
nnoremap <silent> [ctrlp]k :<C-u>CtrlPMark<cr>
nnoremap <silent> [ctrlp]m :<C-u>CtrlPMixed<cr>
nnoremap <silent> [ctrlp]o :<C-u>CtrlPBookmarkDir<cr>
nnoremap <silent> [ctrlp]r :<C-u>CtrlPRegister<cr>
nnoremap <silent> [ctrlp]q :<C-u>CtrlPQuickfix<cr>
nnoremap <silent> [ctrlp]s :<C-u>CtrlPFunky<cr>
nnoremap <silent> [ctrlp]t :<C-u>CtrlPBufTag<cr>
nnoremap <silent> [ctrlp]u :<C-u>CtrlPMRUFiles<cr>
nnoremap <silent> [ctrlp]y :<C-u>CtrlPYankring<cr>


let g:ctrlp_extensions = ['quickfix', 'dir', 'undo', 'line', 'changes', 'mixed', 'buffertag', 'bookmarkdir', 'funky', 'mark', 'register']
let g:ctrlp_match_window_bottom = 1 " Show at top of window
let g:ctrlp_working_path_mode = 'ra' " Smart path mode
let g:ctrlp_mru_files = 1 " Enable Most Recently Used files feature
let g:ctrlp_jump_to_buffer = 2 " Jump to tab AND buffer if already open
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_root_markers = ['.top', '.project', '.ctrlp']
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_custom_ignore = {
    \ 'dir':  '.git\|.svn\|target\|node_modules\|.settings'
    \ }

let g:ctrlp_funky_syntax_highlight = 1
if executable('ag')
    let g:ctrlp_user_command = 'ag -l --nocolor --follow -g "" %s'
    if has('win32')
        let g:ctrlp_use_caching = 1
        let g:ctrlp_clear_cache_on_exit = 0
    else
        let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
        let g:ctrlp_use_caching = 0
    endif
endif

" ctrlp_buftag
let g:ctrlp_buftag_types = {
    \ 'javascript'  : '--language-force=js',
    \ 'css'         : '--language-force=css',
    \ 'gsp'         : '--language-force=XML',
    \ 'xml'         : '--language-force=XML',
    \ 'spring'      : '--language-force=XML',
    \ 'jsp'         : '--language-force=XML',
    \ 'html'        : '--language-force=XML',
    \ 'taskpaper'   : '--language-force=Taskpaper',
    \ 'wsdl'        : '--language-force=wsdl'
    \ }

" fugitive
nnoremap GB :Gblame<CR>
nnoremap GC :Gcommit<CR>
nnoremap Gd :Gdiff<CR>
nnoremap Ge :Gedit<CR>
nnoremap Gl :Glog<CR>
nnoremap Gs :Gstatus<CR>
nnoremap Gr :Gread<CR>
nnoremap Gw :Gwrite<CR>

" Simple way to turn off Gdiff splitscreen
" works only when diff buffer is focused
" https://gist.github.com/radmen/5048080
command! Gdoff diffoff | q | Gedit

function! GitDiffCached()
    new
    r !git diff -w --cached
    :normal ggdd
    setlocal ft=diff bt=nofile bh=wipe nobl noswf ro
    nnoremap <buffer> q :bw<cr>
endfunction
command! Gdiffcached :call GitDiffCached()
nnoremap Gc :Gdiffcached<CR>

function! GitDiffBuf()
    let fname = expand('%')
    new
    exec "r! git diff ".printf('%s', fname)
    :normal ggdd
    setlocal ft=diff bt=nofile bh=wipe nobl noswf ro
    nnoremap <buffer> q :bw<cr>
endfunction
nnoremap Gb :call GitDiffBuf()<CR>

function! GitIncoming()
    new
    r !git log --pretty=oneline --abbrev-commit --graph ..@{u}
    setlocal ft=git bt=nofile bh=wipe nobl noswf ro
    nnoremap <buffer> q :bw<cr>
endfunction
command! Gincoming :call GitIncoming()
nnoremap Gi :Gincoming<CR>

function! GitOutgoing()
    new
    r !git log --pretty=oneline --abbrev-commit --graph @{u}..
    setlocal ft=git bt=nofile bh=wipe nobl noswf ro
    nnoremap <buffer> q :bw<cr>
endfunction
command! Goutgoing :call GitOutgoing()
nnoremap Go :Goutgoing<CR>

" gitgutter

let g:gitgutter_enabled = 0
let g:gitgutter_diff_args = '-w'
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '='
let g:gitgutter_sign_removed = '--'
let g:gitgutter_sign_modified_removed = '~'
nnoremap [og :GitGutterEnable<CR>
nnoremap ]og :GitGutterDisable<CR>
nnoremap cog :GitGutterToggle<CR>
nnoremap ]gg :GitGutterNextHunk<CR>zz
nnoremap [gg :GitGutterPrevHun<CR>zz

nnoremap Gh :GitGutterStageHunk<CR>
nnoremap GR :GitGutterRevertHunk<CR>

" emmet
let g:user_emmet_expandabbr_key = '<C-x>'
let g:user_emmet_settings = {
\ 'html' : {
\    'indentation' : '  '
\ },
\}

" NERDTree
let NERDChristmasTree=1
let NERDTreeWinSize=35
let NERDTreeDirArrows=1
noremap <silent> <C-T> :NERDTreeToggle<CR>
noremap <space>nc :NERDTreeClose<CR>
noremap <silent> <space>nf :NERDTreeFind<CR>
noremap <space>no :NERDTree %:p:h<CR>

" netrw
let g:netrw_browse_split = 4
let g:netrw_liststyle=3
let g:netrw_winsize=20
nnoremap gd :Vex<CR>
augroup Netrw
    autocmd FileType netrw nnoremap <buffer> q :bd<cr>
augroup END

" indent guides
let g:indent_guides_guide_size = 1
nmap <silent> ti <Plug>IndentGuidesToggle

" syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_javascript_checkers=['jsxhint']
let g:syntastic_error_symbol='E:'
let g:syntastic_warning_symbol='W:'
let g:syntastic_always_populate_loc_list= 1

let g:syntastic_stl_format = '| ✗ %E{E: %fe #%e}%B{, }%W{W: %fw #%w} | '

let g:syntastic_mode_map = { 'mode': 'active',
            \ 'passive_filetypes': ['xml', 'java'] }

let g:syntastic_html_tidy_exec = 'tidy5'
let g:syntastic_html_tidy_ignore_errors = [
    \ " proprietary attribute "
    \ ]

" neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup=1
let g:neocomplete#disable_auto_complete=1
let g:neocomplete#enable_auto_select=1
let g:neocomplete#min_keyword_length=3
inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.java = '\k\.\k*'

function! ToggleComplete()
    if g:neocomplete#disable_auto_complete == 1
        let g:neocomplete#disable_auto_complete=0
    else
        let g:neocomplete#disable_auto_complete=1
    endif

    echo (g:neocomplete#disable_auto_complete ? 'completion off' : 'completion on')
endfunction
nnoremap tc :call ToggleComplete()<CR>

" tagbar
noremap <silent> [ot :TagbarOpen fg<CR>
noremap <silent> ]ot :TagbarClose<CR>
noremap <silent> cot :TagbarToggle<CR>

let g:tagbar_type_javascript = {
    \ 'ctagstype'   :'js',
    \ 'kinds'       : [
        \ 'o:objects',
        \ 'f:functions'
    \ ]
\ }

let g:tagbar_type_html = {
    \ 'ctagstype'   :'xml',
    \ 'kinds'       : [
        \ 'e:elements'
    \ ]
\ }

" pandoc:
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
let g:pandoc#filetypes#pandoc_markdown = 0

" eclim:
let g:EclimJavascriptValidate=0
let g:EclimJavascriptIndentDisabled=1
let g:EclimFileTypeValidate=0
let g:EclimJavascriptLintEnabled=0
let g:EclimCompletionMethod='omnifunc'

" vim-json
let g:vim_json_syntax_conceal = 0

" calendar:
command! -nargs=* Cal call calendar#show(1, <f-args>)

"}}}

" 29: functions {{{

function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction
command! Syntax :echo SyntaxItem()

function! ShowTime()
    echo strftime('%a %d %b %H:%M:%S')
endfunction
nnoremap got :call ShowTime()<CR>

function! OpenURI()
    " 2011-01-21 removed colon ':' from regexp to allow for port numbers in URLs
    " original regexp: [a-z]*:\/\/[^ >,;:]*
    let uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;\)\"]*')
    if uri != ""
        let uri = escape(uri, "#%?&;")
        echo uri

        if has('win32')
            exec ":silent !cmd /C start /min " . uri
        elseif has('mac')
            exec ":silent !open \"" . printf("%s", uri) . "\""
        elseif has('unix')
            exec ":silent !firefox \"" . printf("%s", uri) . "\""
        else
            echo "OpenURI not supported on this system"
        endif
        exec ":redraw!"
    else
        echo "No URI found in line."
    endif
endfunction
noremap gou :call OpenURI()<CR>

function! QuickLook()
    if has('mac')
        exec ":silent !ql \"%\""
    else
        echo "Quicklook not supported on this system"
    endif
endfunction
nnoremap gol :call QuickLook()<CR>

" Save last search and cursor position before executing a command
" http://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
function! Preserve(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

function! StripTrailingWhitespace()
    call Preserve("%s/\\s\\+$//e")
endfunction
command! Swhite :call StripTrailingWhitespace()

" Taken from ctrlp help file
function! Setcwd()
    let cph = expand('%:p:h', 1)
    if cph =~ '^.\+://' | retu | en
    for mkr in ['.git/', '.hg/', '.svn/', '.bzr/', '_darcs/', '.vimprojects', '.project', '.ctrlp', '.top']
        let wd = call('find'.(mkr =~ '/$' ? 'dir' : 'file'), [mkr, cph.';'])
        if wd != '' | let &acd = 0 | brea | en
    endfo
    exe 'lc!' fnameescape(wd == '' ? cph : substitute(wd, mkr.'$', '.', ''))
endfunction
command! Cd :silent call Setcwd() | pwd
nnoremap \\cd :Cd<CR>

function! DateTimeStamp()
    return strftime("%H:%M-%m.%d.%Y")
endfun

function! ShortDate()
    return strftime("%Y-%m-%d")
endfun

" http://vimcasts.org/episodes/project-wide-find-and-replace/
command! -nargs=0 -bar Qargs execute 'args ' . QuickfixFilenames()
function! QuickfixFilenames()
    let buffer_numbers = {}
    for quickfix_item in getqflist()
        let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
    endfor
    return join(values(buffer_numbers))
endfunction

"}}}

" 30: user commands {{{

command! R :redraw!
command! Scratch :silent e ~/00INFOBASE/00INBOX/SCRATCH.txt
nnoremap \\s :Scratch<CR>
command! Journal :silent e ~/00INFOBASE/00INBOX/JOURNAL.txt
nnoremap \\j :Journal<CR>
nnoremap \\t :silent e ~/00INFOBASE/00INBOX/01TODO.taskpaper<CR>
command! Ssh :silent e ~/.ssh/config
nnoremap \\h :Ssh<CR>

if executable("dos2unix")
    command! Dos2Unix :%!dos2unix
endif

" http://robots.thoughtbot.com/faster-grepping-in-vim/
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \s :Ag<Space>

if has("mac")
    command! Marked :silent exe "!open -a Marked.app '%:p'" |  redraw!
    nnoremap <space>M :Marked<CR>
endif

" }}}

" 31 abbreviations {{{

:iab dts <c-r>=DateTimeStamp()<esc>
:iab ddt <c-r>=ShortDate()<esc>

if filereadable(glob("~/.vim/abbr.vim"))
    source ~/.vim/abbr.vim
endif

