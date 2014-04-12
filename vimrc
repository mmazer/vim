" 1: important {{{
set nocompatible
" disable before calling vundle
filetype off

" set this here because of unicode chars in listchars below
set encoding=utf-8

" bundles {{{
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" color schemes
Bundle 'altercation/vim-colors-solarized'
Bundle 'junegunn/seoul256.vim'
Bundle 'mmazer/vim-railscasts-theme'
Bundle 'gregsexton/Gravity'

Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-fugitive'

Bundle 'benmills/vimux'
Bundle 'epeli/slimux'
Bundle 'gmarik/vundle'
Bundle 'mattn/emmet-vim'
Bundle 'kien/ctrlp.vim'
Bundle 'mattn/ctrlp-mark'
Bundle 'mattn/ctrlp-register'
Bundle 'rking/ag.vim'
Bundle 'mmazer/ctrlp-funky'
Bundle 'tpope/vim-characterize'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-dispatch'
Bundle 'Raimondi/delimitMate'
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'Shougo/neocomplete.vim'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'
Bundle 'justinmk/vim-gtfo.git'
Bundle 'mmazer/vim-caniuse'
Bundle 'scrooloose/nerdtree'
Bundle 'nathanaelkane/vim-indent-guides'

" file types
Bundle 'tpope/vim-markdown'
Bundle 'scrooloose/syntastic'
Bundle 'mmazer/syntastic-jsxhint'
Bundle 'derekwyatt/vim-scala'
Bundle 'pangloss/vim-javascript'
Bundle 'mxw/vim-jsx'
Bundle 'elzr/vim-json'
Bundle 'davidoc/taskpaper.vim'
Bundle 'nelstrom/vim-markdown-folding'
Bundle 'groenewege/vim-less'
Bundle 'ap/vim-css-color'
Bundle 'Shutnik/jshint2.vim'
"}}}

"}}}

" 2: moving around, searching and patterns {{{

set incsearch
set hlsearch
set ignorecase
set smartcase   "case sensitive if search term contains upppecase letter

nnoremap n nzzzv
nnoremap N Nzzzv

" }}}

" 3: tags {{{
" }}}

" 4: displaying text {{{
set scrolloff=2
set listchars=tab:▸\ ,trail:·,nbsp:¬
set wrap linebreak textwidth=0
set number

" }}}

" 5: syntax, highligthing and spelling {{{1
filetype plugin indent on
syntax on
syntax sync minlines=256
set nocursorline
if has("gui_running")
    let g:seoul256_background=252
    colorscheme gravity
else
    colorscheme railscasts
endif
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
set statusline+=\ %f\:\#%n            "file name and buffer #
set statusline+=%(\[%R%M\]%)      "modified flag
set statusline+=\ %{SyntasticStatuslineFlag()}
set statusline+=%=
set statusline+=\ %{StatuslineWhitespace()}
set statusline+=\ %y      "filetype
set statusline+=\ %{Fenc()} " file encoding
set statusline+=\[%{&ff}\]  "file format
set statusline+=\ \|\ LN\:%4.l/%-4.L\:%-3.c   "cursor line/total lines:column

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

    if     mode ==# "n"  | return "NORMAL"
    elseif mode ==# "i"  | return "INSERT"
    elseif mode ==# "c"  | return "COMMAND"
    elseif mode ==# "!"  | return "SHELL"
    elseif mode ==# "R"  | return "REPLACE"
    elseif mode ==# "v"  | return "VISUAL"
    elseif mode ==# "V"  | return "V-LINE"
    elseif mode ==# ""   | return "V-BLOCK"
    else                 | return l:mode
    endif
endfunction

function! Branch()
    let branch = ''
    if !exists('*fugitive#head')
        return branch
    endif

    let branch = fugitive#head(7)
    return empty(branch) ? '' : 'Git:'.branch
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
        let trailing_warning = 'trailing'
     else
        let trailing_warning = ''
     endif

     " check indents
    let tabs = search('^\t', 'nw') != 0
    let spaces = search('^ ', 'nw') != 0
    let mixed = tabs && spaces

    if mixed
        let tab_warning = 'mixed-indent'
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

set t_Co=256

" }}}

" 9: using the mouse {{{1
" }}}

" 10: GUI {{{1

if has("gui_running")
    set antialias
    if has('mac')
        set guifont=DejaVu\ Sans\ Mono:h12
    elseif has('win32')
        set guioptions-=m " Remove menu bar to save space
        set guioptions+=a " Yank to system clipboard
        set guifont=DejaVu_Sans_Mono:h9
    endif
    set guioptions-=T " remove tool bar
    set guioptions-=r " remove right-hand scroll bar
    set guioptions-=L " remove left-hand scroll bar
    set lines=90
    set columns=145
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
augroup end

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

" Better mark jumping (line + col)
nnoremap ' `

" for toggling paste mode in terminal
" Can also use `yo` from `unimpaired`
set pastetoggle=<F5>
nnoremap <C-p> "+gP
inoremap <C-v> <esc>"+gPi
vnoremap <C-p> "+gP

" For wrapped lines, navigate normally
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

inoremap <C-]> <C-o>$
noremap <silent> Q :q!<CR>
noremap Ev :e ~/.vim/vimrc<CR>
noremap So :so ~/.vim/vimrc<CR>

nnoremap <space>W :w!<CR>
nnoremap <space>w :w<CR>
nnoremap <space>B :b#<CR>
nnoremap <space>d :bd<CR>
nnoremap <space>l :ls<CR>
" goto buffer
nnoremap gob :ls<CR>:b

nmap <space><space> :noh<CR>

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

" tab navigation: http://vim.wikia.com/wiki/Alternative_tab_navigation
nnoremap <space>th  :tabfirst<CR>
nnoremap <space>tj  :tabnext<CR>
nnoremap <space>tk  :tabprev<CR>
nnoremap <space>tl  :tablast<CR>
nnoremap <space>tt  :tabedit<Space>
nnoremap <space>tn  :tabnext<Space>
nnoremap <space>tm  :tabm<Space>
nnoremap <space>td  :tabclose<CR>

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

" Function mappings see ~/.vim/functions.vim
noremap <leader>c :call ToggleBackgroundColour()<CR>

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
nnoremap gq :copen<CR>
nnoremap cq :cclose<CR>

nnoremap gl :llist<CR>
noremap cl :lclose<CR>

" end lines with semicolons
inoremap ;] <C-o>A;
nnoremap <space>; A;<esc>

nnoremap <space>rd :redraw!<CR>
noremap <C-U> :redraw!<CR>

" Slimux keys
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>

inoremap <C-P> <C-X><C-U>

" }}}

" 19: reading and writing files {{{1

set modeline
set ffs=unix,dos,mac "Default file types
set ff=unix " set initial buffer file format
set nobackup
set backupdir=$HOME/.var/vim/backup//
set autoread

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

" 27: various {{{

" autocommands {{{
if has("autocmd")
    " remove trailing whitespace
    augroup trailing_whitespace
        autocmd FileType vim,css,groovy,java,javascript,less,php,scala autocmd BufWritePre <buffer> :%s/\s\+$//e
    augroup END

    augroup javascript_files
        autocmd FileType javascript setlocal foldmethod=indent
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    augroup END

    augroup jsx_files
        autocmd BufNewFile,BufRead *.jsx set ft=javascript.jsx
    augroup END

    augroup vim_files
        autocmd filetype vim set foldmethod=marker
    augroup END

    augroup html_files
        "autocmd filetype html set ft=xml.html.javascript
        autocmd FileType html setlocal shiftwidth=2 softtabstop=2 tabstop=2 foldmethod=manual
        autocmd FileType setlocal autoindent
    augroup END

    augroup jsp_files
        autocmd filetype jsp set ft=jsp.html
        autocmd filetype jsp set foldmethod=manual
    augroup END

    augroup gsp_files
        autocmd FileType gsp set ft=gsp.html
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
    augroup END

    augroup less_files
        autocmd FileType less setlocal omnifunc=csscomplete#CompleteCSS
    augroup END

    augroup jmeter_files
        autocmd! BufRead *.jtl setlocal ft=text
    augroup END

    augroup json_files
        autocmd FileType json nnoremap <buffer> <Leader>fj :%!python -m json.tool<CR>
    augroup END

    augroup xml_files
        autocmd filetype xml setlocal foldmethod=syntax
    augroup END

    augroup taskpaper_files
        autocmd FileType taskpaper setlocal noexpandtab
    augroup END

    augroup fugitive_buffers
        autocmd BufRead fugitive\:* xnoremap <buffer> dp :diffput<CR>|xnoremap <buffer> do :diffget<CR>
    augroup END

    augroup markdown_files
        autocmd BufNewFile,BufRead *.md,*.mkd,*.markdown setlocal formatoptions=ant textwidth=80 wrapmargin=0
    augroup END
endif "}}}
" }}}

" 28: plugin settings {{{1

" ctrlp
nmap <space> [ctrlp]
nnoremap <silent> [ctrlp]a :<C-u>CtrlPBookmarkDirAdd<cr>
nnoremap <silent> [ctrlp]b :<C-u>CtrlPBuffer<cr>
nnoremap <silent> [ctrlp]c :<C-u>CtrlPClearCache<cr>
nnoremap <silent> [ctrlp]d :<C-u>CtrlPDir<cr>
nnoremap <silent> [ctrlp]f :<C-u>CtrlP<cr>
nnoremap <silent> [ctrlp]m :<C-u>CtrlPMark<cr>
nnoremap <silent> [ctrlp]o :<C-u>CtrlPBookmarkDir<cr>
nnoremap <silent> [ctrlp]r :<C-u>CtrlPRegister<cr>
nnoremap <silent> [ctrlp]q :<C-u>CtrlPQuickFix<cr>
nnoremap <silent> [ctrlp]s :<C-u>CtrlPFunky<cr>


let g:ctrlp_extensions = ['quickfix', 'dir', 'undo', 'line', 'changes', 'mixed', 'bookmarkdir', 'funky', 'mark', 'register']
let g:ctrlp_match_window_bottom = 1 " Show at top of window
let g:ctrlp_working_path_mode = 'ra' " Smart path mode
let g:ctrlp_mru_files = 1 " Enable Most Recently Used files feature
let g:ctrlp_jump_to_buffer = 2 " Jump to tab AND buffer if already open
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_root_markers = ['.top', '.project', '.ctrlp']
let g:ctrlp_follow_symlinks = 1

let g:ctrlp_custom_ignore = {
    \ 'dir':  'target\|node_modules\|.settings'
    \ }

let g:ctrlp_funky_syntax_highlight = 1
if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor --follow -g ""'
    if !has('win32')
        let g:ctrlp_use_caching = 0
    endif
endif

" fugitive
nnoremap <space>gb :Gblame<CR>
nnoremap <space>gC :Gcommit<CR>
nnoremap <space>gd :Gdiff<CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gr :Gread<CR>
nnoremap <space>gw :Gwrite<CR>

" Simple way to turn off Gdiff splitscreen
" works only when diff buffer is focused
" https://gist.github.com/radmen/5048080
command! Gdoff diffoff | q | Gedit
nnoremap <space>go :Gdoff<CR>

function! GitDiffCached()
    new
    r !git diff -w --cached
    setlocal ft=diff bt=nofile bh=wipe nobl noswf ro
    nnoremap <buffer> q :bw<cr>
endfunction
command! Gdiffcached :call GitDiffCached()
nnoremap <space>gc :Gdiffcached<CR>

function! GitIncoming()
    new
    r !git log --pretty=oneline --abbrev-commit --graph ..@{u}
    setlocal ft=git bt=nofile bh=wipe nobl noswf ro
    nnoremap <buffer> q :bw<cr>
endfunction
command! Gincoming :call GitIncoming()
nnoremap <space>g[ :Gincoming<CR>

function! GitOutgoing()
    new
    r !git log --pretty=oneline --abbrev-commit --graph @{u}..
    setlocal ft=git bt=nofile bh=wipe nobl noswf ro
    nnoremap <buffer> q :bw<cr>
endfunction
command! Goutgoing :call GitOutgoing()
nnoremap <space>g] :Goutgoing<CR>

" gitgutter
let g:gitgutter_diff_args = '-w'
let g:gitgutter_sign_added = '+ '
let g:gitgutter_sign_modified = '= '
let g:gitgutter_sign_removed = '- '
let g:gitgutter_sign_modified_removed = '~ '
nnoremap [og :GitGutterEnable<CR>
nnoremap ]og :GitGutterDisable<CR>
nnoremap cog :GitGutterToggle<CR>
nnoremap ]gg :GitGutterNextHunk<CR>
nnoremap [gg :GitGutterPrevHun<CR>

highlight GitGutterAdd guifg=NONE guibg=#b4de85
highlight GitGutterChange guifg=NONE guibg=#87c5dc
highlight GitGutterDelete guifg=NONE guibg=#7c7c7c
highlight GitGutterChangeDelete guifg=NONE guibg=#7c7c7c

" emmet
let g:user_emmet_expandabbr_key = '<C-e>'
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
noremap <space>no :NERDTree %:p:h<CR>

" netrw
let g:netrw_browse_split = 4
let g:netrw_liststyle=3
let g:netrw_winsize=20
nnoremap gd :Vex<CR>

" vim-gist
let g:gist_show_privates = 1

" indent guides
let g:indent_guides_guide_size = 1
nmap <silent> ti <Plug>IndentGuidesToggle

" syntastic
let g:syntastic_javascript_checkers=['jshint']
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_always_populate_loc_list=1

let g:syntastic_stl_format = '[Syntax: %E{Errors: %fe #%e}%B{, }%W{Warnings: %fw #%w}]'

let g:syntastic_mode_map = { 'mode': 'active',
            \ 'passive_filetypes': ['xml', 'html', 'java'] }
let g:syntastic_filetype_map = { 'javascript.jsx': 'jsx' }

" neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup=1
let g:neocomplete#disable_auto_complete=1
let g:neocomplete#enable_auto_select=1
let g:neocomplete#min_keyword_length=3

function! ToggleComplete()
    if g:neocomplete#disable_auto_complete == 1
        let g:neocomplete#disable_auto_complete=0
    else
        let g:neocomplete#disable_auto_complete=1
    endif
endfunction
nnoremap tc :call ToggleComplete()<CR>

"}}}

" 29: functions {{{

" Taken from http://learnvimscriptthehardway.stevelosh.com/chapters/38.html
function! FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=3
    endif
endfunction
nnoremap <Leader>tf :call FoldColumnToggle()<cr>


function! OpenURI()
    " 2011-01-21 removed colon ':' from regexp to allow for port numbers in URLs
    " original regexp: [a-z]*:\/\/[^ >,;:]*
    let uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;\)\"]*')
    echo uri
    if uri != ""
        if has('win32')
            exec ":silent !cmd /C start /min " . escape(uri,"%")
        elseif has('mac')
            exec ":silent !open \"" . escape(s:uri,"%") . "\""
        else
            echo "OpenURI not supported on this system"
        endif
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
nnoremap ql :call QuickLook()<CR>

function! OpenCurrentDir()
    if has('mac')
        exec ":silent !open \"" . expand("%:p:h") . "\""
    else
        echo "OpenCurrentDir not supported on this system"
    endif
endfunction
map <leader>F :call OpenCurrentDir()<CR>

" Toggle background colour
" http://www.functor.be/wiki/index.php/VIM
function! ToggleBackgroundColour ()
    if (&background == 'light')
        set background=dark
        echo "background -> dark"
    else
        set background=light
        echo "background -> light"
    endif
endfunction

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
command! StripWh :call StripTrailingWhitespace()

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
command! Setcwd :silent call Setcwd() | pwd

" TODO replace with simple iab <expr>
function! DateTimeStamp()
    return strftime("%H:%M-%m.%d.%Y")
endfun

function! ShortDate()
    return strftime("%Y-%m-%d")
endfun

"}}}

" 30: user commands {{{

command! Rd :redraw!
command! Scratch :silent e ~/.var/vim/vim-scratch.txt
nnoremap Es :Scratch<CR>
if executable("dos2unix")
    command! Dos2Unix :%!dos2unix
endif

" http://robots.thoughtbot.com/faster-grepping-in-vim/
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<Space>

if has("mac")
    command! Marked :silent exe "!open -a Marked.app '%:p'" |  redraw!
    nnoremap <space>M :Marked<CR>
endif

command! GrailsStop :SlimuxShellRun stop-app
command! GrailsRun :SlimuxShellRun run-app

" }}}

" 31 abbreviations {{{

:iab dts <c-r>=DateTimeStamp()<cr><esc>
:iab ddt <c-r>=ShortDate()<cr><esc>

if filereadable(glob("~/.vim/abbr.vim"))
    source ~/.vim/abbr.vim
endif

"}}}

