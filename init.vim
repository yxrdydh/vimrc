" Main VIM Configuration File
" Author: Michael Goerz <goerz@physik.uni-kassel.de>

" Python interpreter (neovim)
let g:python_host_prog = $HOME.'/anaconda3/envs/py27/bin/python'
let g:python3_host_prog = $HOME.'/anaconda3/bin/python'
let g:notedown_enable = 1

" Pathogen --allows to install plugins in .vim/bundle
execute pathogen#infect()

" * Interface Settings {{{1

" switch ' and `
nnoremap ' `
nnoremap ` '

" Leader keys
let mapleader = ","
let g:mapleader = ","
let maplocalleader = "\\"
let g:maplocalleader = "\\"

set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

" use the mouse in xterm (or other terminals that support it)
" Toggle with ,m
set mouse=
"set ttymouse=xterm2
fun! s:ToggleMouse()
    if !exists("s:old_mouse")
        let s:old_mouse = "a"
    endif

    if &mouse == ""
        let &mouse = s:old_mouse
        echo "Mouse is for Vim (" . &mouse . ")"
    else
        let s:old_mouse = &mouse
        let &mouse=""
        echo "Mouse is for terminal"
    endif
endfunction
nnoremap <Leader>m :call <SID>ToggleMouse()<CR>

" pastetoggle
set pastetoggle=<C-L>p
nnoremap <Leader>p :set invpaste<CR>

" Save
nnoremap <leader>w :w!<cr>

" Align to mark 'a
nnoremap <leader>a :call AlignToMark('a')<CR>

" paste without cutting
vnoremap p "_dP

" Open file in external program
nnoremap go :!open <cfile><CR>

" Up/down, j/k key behaviour
" -- Changes up/down arrow keys to behave screen-wise, rather than file-wise.
"    Behaviour is unchanged in operator-pending mode.
if version >= 700
    " Stop remapping from interfering with Omni-complete popup
    inoremap <silent><expr><Up> pumvisible() ? "<Up>" : "<C-O>gk"
    inoremap <silent><expr><Down> pumvisible() ? "<Down>" : "<C-O>gj"
else
    inoremap <silent><Up> <C-O>gk
    inoremap <silent><Down> <C-O>gj
endif

nnoremap <silent>j gj
nnoremap <silent>k gk
nnoremap <silent><Up> gk
nnoremap <silent><Down> gj
vnoremap <silent>j gj
vnoremap <silent>k gk
vnoremap <silent><Up> gk
vnoremap <silent><Down> gj

" command mode mappings
" Use emacs-style shortcuts, remap diagraph-insertion to <C-D>
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-D> <C-K>
cnoremap <C-K> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>


" windowing commands -- I prefer vertical splits
" however, keep all CTRL-W CTRL-XX commands at the default!
set splitright
set splitbelow
:map <c-w>f :vertical wincmd f<CR>
:map <c-w>gf :vertical wincmd f<CR>
:map <c-w>] :vertical wincmd ]<CR>
:map <c-w>n :vnew<CR>
" Wrap window-move-cursor
" http://stackoverflow.com/questions/13848429/is-there-a-way-to-have-window-navigation-wrap-around-in-vim<Paste>
function! s:GotoNextWindow( direction, count )
  let l:prevWinNr = winnr()
  execute a:count . 'wincmd' a:direction
  return winnr() != l:prevWinNr
endfunction
function! s:JumpWithWrap( direction, opposite )
  if ! s:GotoNextWindow(a:direction, v:count1)
    call s:GotoNextWindow(a:opposite, 999)
  endif
endfunction
nnoremap <silent> <C-w>h :<C-u>call <SID>JumpWithWrap('h', 'l')<CR>
nnoremap <silent> <C-w>j :<C-u>call <SID>JumpWithWrap('j', 'k')<CR>
nnoremap <silent> <C-w>k :<C-u>call <SID>JumpWithWrap('k', 'j')<CR>
nnoremap <silent> <C-w>l :<C-u>call <SID>JumpWithWrap('l', 'h')<CR>
nnoremap <silent> <C-w><Left> :<C-u>call <SID>JumpWithWrap('h', 'l')<CR>
nnoremap <silent> <C-w><Down> :<C-u>call <SID>JumpWithWrap('j', 'k')<CR>
nnoremap <silent> <C-w><Up> :<C-u>call <SID>JumpWithWrap('k', 'j')<CR>
nnoremap <silent> <C-w><Right> :<C-u>call <SID>JumpWithWrap('l', 'h')<CR>

" neomake
if has('nvim')
    autocmd! BufWritePost,BufEnter * Neomake
    " Neomake only runs asynchronously in neovim. Having it active
    " automatically in vim would cause unacceptable delays.
endif
let g:neomake_highlight_columns = 0
"let g:neomake_verbose=3
"let g:neomake_logfile='/tmp/neomake_error.log'
let g:neomake_error_sign = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {
    \   'text': '△',
    \   'texthl': 'NeomakeWarningSign',
    \ }
let g:neomake_message_sign = {
    \   'text': '➤',
    \   'texthl': 'NeomakeMessageSign',
    \ }
let g:neomake_info_sign = {'text': '𝚒', 'texthl': 'NeomakeInfoSign'}
let g:neomake_python_pylint_maker = {
\ 'args': [
    \ '--load-plugins=pylint.extensions.check_docs',
    \ '--output-format=text',
    \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}"',
    \ '--reports=no',
    \ '--docstring-min-length=5',
    \ '--max-args=30',
    \ '--max-locals=100',
    \ '--max-branches=50',
    \ '--max-statements=800',
    \ '--max-attributes=80',
    \ '--max-public-methods=50',
    \ '--max-module-lines=10000',
    \ '--ignored-classes=numpy,numpy.random,scipy,matplotlib',
    \ '--variable-rgx=[A-Za-z_][a-z0-9_]*$',
    \ '--attr-rgx=([A-Za-z_][A-Za-z0-9_]*|(__.*__))$',
    \ '--argument-rgx=[A-Za-z_][a-z0-9_]*$',
    \ '--bad-functions=',
    \ '-d C0330,C0326,W0108,W0511,C0321,C0103',
\ ],
\ 'errorformat':
    \ '%A%f:%l:%c:%t: %m,' .
    \ '%A%f:%l: %m,' .
    \ '%A%f:(%l): %m,' .
    \ '%-Z%p^%.%#,' .
    \ '%-G%.%#',
\ }
" always show gutter
augroup mine
    au BufWinEnter * sign define mysign
    au BufWinEnter * exe "sign place 1337 line=1 name=mysign buffer=" . bufnr('%')
augroup END

" Work around neovim not running bang commands in the current tty
" https://github.com/neovim/neovim/issues/1496
if has('nvim')
  cnoremap <expr> !<space> strlen(getcmdline())?'!':('!tmux split-window -c '.getcwd().' -p 90 ')
endif


" iVim (Nicolas Holzschuch's fork)
if has("ivim")

    let $PATH .= ':'.$HOME.'/../Library/bin:'.$HOME.'/bin'
    let $PYTHONHOME = $HOME.'/../Library/'
    let $SSH_HOME = $HOME
    let $CURL_HOME = $HOME
    let $SSL_CERT_FILE = $HOME.'/cacert.pem'
    let $HGRCPATH = $HOME.'/.hgrc'

    map <D-o> :idocuments <CR>
    map <D-e> :edit . <CR>
    map <D-s> :w <CR>
    map <D-t> :tabnew <CR>
    map <D-w> :bd <CR>
    map <D-q> :quit <CR>
    map <D-}> :tabne <CR>
    map <D-{> :tabprev <CR>

endif


" persistent undo
if has("persistent_undo")
    set undodir=~/.vim/undo/
    set undofile
    au BufWritePre /tmp/* setlocal noundofile
endif

" swap and backup
set backupdir=~/.vim/backup/
set directory=~/.vim/backup/

"" indicate textwidth with color column
"if exists("+colorcolumn")
"    set colorcolumn=+1
"endif

" enable incremental search, and search highlighting by default
set hlsearch " opposite of set nohlsearch
set incsearch
" Disable search highlighting by pressing ESC in normal mode
:nnoremap <esc> :nohlsearch<return><esc>
" Note that the nohlsearch *command* is different from the nohlsearch
" *option*: the command just switches off the hightlighting, but it will
" appear again on the next search command. The option switches if off
" permanently

" Reload the file if it changes outside of vim
set autoread

" select case-insenitiv search
set ignorecase
set smartcase

" Trailing whitespace detection
function! WhitespaceCheck()
  if &readonly || mode() != 'n'
    return ''
  endif
  let trailing = search(' $', 'nw')
  let indents = [search('^ ', 'nb'), search('^ ', 'n'), search('^\t', 'nb'), search('^\t', 'n')]
  let mixed = indents[0] != 0 && indents[1] != 0 && indents[2] != 0 && indents[3] != 0
  if trailing != 0 || mixed
    return "(!) "
  endif
  return ''
endfunction!

" Return current working directory (in quotes) if either autochdir is on or a
" symlink has been followed. Otherwise, return empty string. To be used for
" display in the status line
function! StatusCwd()
  if exists("+autochdir")
    if &autochdir
      return '"' . getcwd() . '"/'
    endif
  endif
  if exists("b:followed_symlink")
    return '"' . getcwd() . '"/'
  endif
  return ''
endfunction!


" Follow symlink for current file
" Sources:
"  - https://github.com/tpope/vim-fugitive/issues/147#issuecomment-7572351
"  - http://www.reddit.com/r/vim/comments/yhsn6/is_it_possible_to_work_around_the_symlink_bug/c5w91qw
" Echoing a warning does not appear to work:
"   echohl WarningMsg | echo "Resolving symlink." | echohl None |
function! MyFollowSymlink(...)
  let fname = a:0 ? a:1 : expand('%')
  if getftype(fname) != 'link'
    return
  endif
  let resolvedfile = fnameescape(resolve(fname))
  exec 'file ' . resolvedfile
  lcd %:p:h
  let b:followed_symlink = 1
endfunction
command! FollowSymlink call MyFollowSymlink()


" statusline is set by the airline plugin
" You may only set the powerline fonts to 1 if you have insalled  the
" powerline fonts, https://github.com/Lokaltog/powerline-fonts
let g:airline_theme='goerz'
let g:airline_powerline_fonts=0
"
let g:airline_enable_syntastic=0
let g:airline_modified_detection=0
if (g:airline_powerline_fonts==0)
    "let g:airline_left_sep=''
    "let g:airline_right_sep=''
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '◀'
    let g:airline_linecolumn_prefix = '¶ '
    let g:airline_fugitive_prefix = ''
endif
let g:airline_section_b='%{WhitespaceCheck()}%{StatusCwd()}%f%m'
let g:airline_section_c='%3p%% '.g:airline_linecolumn_prefix.'%3l/%L:%3c'
let g:airline_section_z='%{g:airline_externals_fugitive}'

" Use proper highlighting for the active status line (otherwise font colors
" are messed up)
if !has('nvim')
    set highlight+=sr
endif
set laststatus=2 " always show status line

" set the terminal title
"set title
"set titleold=xterm

" show cursor line and column, if no statusline
set ruler

" shorten command-line text and other info tokens
set shortmess=atI

" don't jump between matching brackets while typing
set noshowmatch

" display mode INSERT/REPLACE/...
set showmode

" When selecting blocks, allow to move the cursor beyond the end of the line
set virtualedit=block

" remember more commands and search patterns
set history=1000

" changes special characters in search patterns (default)
" set magic

" define some listchars, but keep 'list' disabled by default
set lcs=tab:>-,trail:-,nbsp:~
set nolist

" Required to be able to use keypad keys and map missed escape sequences
if ! has('nvim')
    set esckeys
endif

" get easier to use and more user friendly Vim defaults
" CAUTION: This option breaks some vi compatibility.
"          Switch it off if you prefer real vi compatibility
set nocompatible

" Enabled XSMP connection. This seems to enable the X clipboard when vim
" is called with the -X option
"call serverlist()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Complete longest common string, then each full match
" (bash compatible behavior)
set wildmode=longest,full

" No bells
set noerrorbells
if has('autocmd')
  autocmd GUIEnter * set vb t_vb=
endif

" Show Buffer Tabs
set showtabline=1               "Display the tabbar if there are multiple tabs. Use :tab ball or invoke Vim with -p
set hidden                      "allows opening a new buffer in place of an existing one without first saving the existing one

" Search the first 5 lines for modelines
set modelines=5

" Folding settings
set nofoldenable " Don't show folds by default
autocmd BufWinLeave ?* mkview          " Store fold settings for all buffers ...
"autocmd BufWinEnter ?* silent loadview " ... and reload them


" Tagbar (and legacy Taglist ) plugin
let Tlist_Inc_Winwidth = 0 " Taglist: Don't enlarge the terminal
"noremap <silent> <leader>t :TlistToggle<CR><C-W>h
noremap <silent> <leader>t :TagbarToggle<CR>
let g:tagbar_ctags_bin = 'ctags'
let g:tagbar_show_linenumbers = 0
let g:tagbar_sort = 0
let g:tagbar_left = 1
let g:tagbar_foldlevel = 2
"use ~/.vim/ctags.cnf This depends on a patched version of the tagbar plugin
"(pull request #476)
let g:tagbar_ctags_options = ['NONE', split(&rtp,",")[0].'/ctags.cnf']
" the definition below depend on the settings in ctags.cnf
let g:tagbar_type_make = {
            \ 'kinds':[
                \ 'm:macros',
                \ 't:targets'
            \ ]
\}
let g:tagbar_type_julia = {
    \ 'ctagstype' : 'julia',
    \ 'kinds'     : [
        \ 't:struct', 'f:function', 'm:macro', 'c:const']
    \ }

" LaTeX to Unicode substitutions
"  This is mainly for Julia, but I also like to use it for Python and others
let g:latex_to_unicode_file_types = [
    \ "julia", "python", "mail", "markdown", "pandoc", "human"]
noremap <silent> <leader>l :call LaTeXtoUnicode#Toggle()<CR>


" go to defn of tag under the cursor (case sensitive)
" adapted from http://tartley.com/?p=1277
fun! MatchCaseTag()
    let ic = &ic
    set noic
    try
        exe 'tjump ' . expand('<cword>')
    catch /.*/
        echo v:exception
    finally
       let &ic = ic
    endtry
endfun
nnoremap <silent> <c-]> :call MatchCaseTag()<CR>

" CSV plugin
let g:csv_no_conceal = 1
let g:csv_highlight_column = 'n'
let g:csv_comment = '#'
let g:csv_start = 1
let g:csv_end = 100
let g:csv_strict_columns = 1

" SLIME plugin
let g:slime_target = "tmux"
let g:slime_no_mappings = 1
nnoremap <silent> <leader>s :SlimeSend<CR>
xnoremap <silent> <leader>s :'<,'>SlimeSend<CR>

" Undotree plugin
nnoremap <silent> <leader>u :UndotreeToggle<CR>

" CtrlP
let g:ctrlp_max_files = 10000

if has("unix") " Optimize file searching
    let g:ctrlp_user_command = {
    \   'types': {
    \       1: ['.git/', 'cd %s && git ls-files']
    \   },
    \   'fallback': 'find %s -type f | head -' . g:ctrlp_max_files
    \ }
endif

" Nerd_commenter plugin
let g:NERDShutUp = 1

" vmath plugin
vmap <expr>  ++  VMATH_YankAndAnalyse()
nmap         ++  vip++

" pydoc plugin
let g:pydoc_open_cmd = 'vsplit'

" Activate 256 colors independently of terminal. Most of my terms are 256
" colors. For those cases where I'm running vim in a low-color terminal, this
" is only safe if I'm using screen (which I always am).
set t_Co=256

" Default Color Scheme
if has('ivim')
    set background=light
else
    if !empty($COLORFGBG)
        let s:bg_color_code = split($COLORFGBG, ";")[-1]
        if s:bg_color_code == 8 || s:bg_color_code  <= 6
            set background=dark
        else
            set background=light
        endif
    endif
endif
colorscheme goerz
autocmd FileType tex hi! texSectionTitle gui=underline term=bold cterm=underline,bold
autocmd FileType tex hi! Statement gui=none term=none cterm=none
if has('ivim')
    hi Normal ctermbg=White ctermfg=Black guifg=Black guibg=White
endif

" Forward SyncTeX
autocmd FileType tex nnoremap <Leader>s :w<CR>:silent !$SYNCTEXREADER -g <C-r>=line('.')<CR> %<.pdf %<CR><C-l>

" Datestamps
if exists("*strftime")
    nmap <leader>d a<c-r>=strftime("%a %D %H:%M:%S %Z")<cr>
    imap <C-L>d <c-r>=strftime("%a %D %H:%M:%S %Z")<cr>
endif

" abbreviations / commands
command Noindent setl noai nocin nosi inde=
command German set spell spelllang=de_20
command English set spell spelllang=en
command Python set nospell ft=python
command ManualFolding set foldenable foldmethod=manual
command WriteDark set background=dark | colorscheme peaksea | Goyo 100
command WriteLight set background=light | colorscheme peaksea | Goyo 100
command Dark set background=dark | colorscheme peaksea
cabbr AB 'a,'b

" Activate wildmenu
set wildmenu

" Hide Toolbar and mouse usage in Macvim
if has("gui_running")
    set guioptions=egmrt
    set mouse=a
endif


" * Text Formatting -- General {{{1

" don't make it look like there are line breaks where there aren't:
set wrap
" but if we wrap, use a nice unicode character to indicate the linebreak, and
" don't break in the middle of a word
"set showbreak=∟
set linebreak

" tab stops should be at 4 spaces
set tabstop=4

" use indents of 4 spaces:
set shiftwidth=4
set shiftround
set expandtab
set noautoindent

" don't break text by default:
set formatoptions=tcql
set textwidth=0

" My default language is American English
set spelllang=en_us

set grepprg=~/.vim/scripts/ack

" Use # without VIM moving it to the first column
inoremap # X<C-H>#

" Temporary files
set wildignore+=*.o,*.obj
set wildignore+=*.bak,*~,*.tmp,*.backup


" Printing settings
set printoptions=paper:a4,number:y,left:25pt,right:40pt
set printheader=%<%f%h%m\ \ (%{strftime('%m/%d/%y\ %X')})%=Page\ %N


" * Text Formatting -- Specific File Formats {{{1

" enable filetype detection:
filetype plugin on
filetype plugin indent on
" Custom mappings between extensions and filetypes are done by the scripts in
" the ftdetect folder

" Hiding of quotes in json files
let g:vim_json_syntax_conceal=0

" For some programming languages, delete trailing spaces on save
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
autocmd BufWritePre *.pl normal m`:%s/\s\+$//e ``

" enable syntax highlighting
syntax on
syntax sync fromstart


" * Terminal Specific Settings {{{1

if &term =~ "linux$"
    colorscheme default
    set t_Co=8
endif

" Try to get the correct main terminal type
if &term =~ "xterm"
    let myterm = "xterm"
else
    let myterm =  &term
endif
let myterm = substitute(myterm, "cons[0-9][0-9].*$",  "linux", "")
let myterm = substitute(myterm, "vt1[0-9][0-9].*$",   "vt100", "")
let myterm = substitute(myterm, "vt2[0-9][0-9].*$",   "vt220", "")
let myterm = substitute(myterm, "\\([^-]*\\)[_-].*$", "\\1",   "")

" Here we define the keys of the NumLock in keyboard transmit mode of xterm
" which misses or hasn't activated Alt/NumLock Modifiers.  Often not defined
" within termcap/terminfo and we should map the character printed on the keys.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <ESC>Oo  :
    map! <ESC>Oj  *
    map! <ESC>Om  -
    map! <ESC>Ok  +
    map! <ESC>Ol  ,
    map! <ESC>OM  
    map! <ESC>Ow  7
    map! <ESC>Ox  8
    map! <ESC>Oy  9
    map! <ESC>Ot  4
    map! <ESC>Ou  5
    map! <ESC>Ov  6
    map! <ESC>Oq  1
    map! <ESC>Or  2
    map! <ESC>Os  3
    map! <ESC>Op  0
    map! <ESC>On  .
    " keys in normal mode
    map <ESC>Oo  :
    map <ESC>Oj  *
    map <ESC>Om  -
    map <ESC>Ok  +
    map <ESC>Ol  ,
    map <ESC>OM  
    map <ESC>Ow  7
    map <ESC>Ox  8
    map <ESC>Oy  9
    map <ESC>Ot  4
    map <ESC>Ou  5
    map <ESC>Ov  6
    map <ESC>Oq  1
    map <ESC>Or  2
    map <ESC>Os  3
    map <ESC>Op  0
    map <ESC>On  .
endif

" xterm but without activated keyboard transmit mode
" and therefore not defined in termcap/terminfo.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <Esc>[H  <Home>
    map! <Esc>[F  <End>
    " Home/End: older xterms do not fit termcap/terminfo.
    map! <Esc>[1~ <Home>
    map! <Esc>[4~ <End>
    " Up/Down/Right/Left
    map! <Esc>[A  <Up>
    map! <Esc>[B  <Down>
    map! <Esc>[C  <Right>
    map! <Esc>[D  <Left>
    " KP_5 (NumLock off)
    map! <Esc>[E  <Insert>
    " PageUp/PageDown
    map <ESC>[5~ <PageUp>
    map <ESC>[6~ <PageDown>
    map <ESC>[5;2~ <PageUp>
    map <ESC>[6;2~ <PageDown>
    map <ESC>[5;5~ <PageUp>
    map <ESC>[6;5~ <PageDown>
    " keys in normal mode
    map <ESC>[H  0
    map <ESC>[F  $
    " Home/End: older xterms do not fit termcap/terminfo.
    map <ESC>[1~ 0
    map <ESC>[4~ $
    " Up/Down/Right/Left
    map <ESC>[A  k
    map <ESC>[B  j
    map <ESC>[C  l
    map <ESC>[D  h
    " KP_5 (NumLock off)
    map <ESC>[E  i
    " PageUp/PageDown
    map <ESC>[5~ 
    map <ESC>[6~ 
    map <ESC>[5;2~ 
    map <ESC>[6;2~ 
    map <ESC>[5;5~ 
    map <ESC>[6;5~ 
endif

" xterm/kvt but with activated keyboard transmit mode.
" Sometimes not or wrong defined within termcap/terminfo.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <Esc>OH <Home>
    map! <Esc>OF <End>
    map! <ESC>O2H <Home>
    map! <ESC>O2F <End>
    map! <ESC>O5H <Home>
    map! <ESC>O5F <End>
    " Cursor keys which works mostly
    " map! <Esc>OA <Up>
    " map! <Esc>OB <Down>
    " map! <Esc>OC <Right>
    " map! <Esc>OD <Left>
    map! <Esc>[2;2~ <Insert>
    map! <Esc>[3;2~ <Delete>
    map! <Esc>[2;5~ <Insert>
    map! <Esc>[3;5~ <Delete>
    map! <Esc>O2A <PageUp>
    map! <Esc>O2B <PageDown>
    map! <Esc>O2C <S-Right>
    map! <Esc>O2D <S-Left>
    map! <Esc>O5A <PageUp>
    map! <Esc>O5B <PageDown>
    map! <Esc>O5C <S-Right>
    map! <Esc>O5D <S-Left>
    " KP_5 (NumLock off)
    map! <Esc>OE <Insert>
    " keys in normal mode
    map <ESC>OH  0
    map <ESC>OF  $
    map <ESC>O2H  0
    map <ESC>O2F  $
    map <ESC>O5H  0
    map <ESC>O5F  $
    " Cursor keys which works mostly
    " map <ESC>OA  k
    " map <ESC>OB  j
    " map <ESC>OD  h
    " map <ESC>OC  l
    map <Esc>[2;2~ i
    map <Esc>[3;2~ x
    map <Esc>[2;5~ i
    map <Esc>[3;5~ x
    map <ESC>O2A  ^B
    map <ESC>O2B  ^F
    map <ESC>O2D  b
    map <ESC>O2C  w
    map <ESC>O5A  ^B
    map <ESC>O5B  ^F
    map <ESC>O5D  b
    map <ESC>O5C  w
    " KP_5 (NumLock off)
    map <ESC>OE  i
endif

if myterm == "linux"
    " keys in insert/command mode.
    map! <Esc>[G  <Insert>
    " KP_5 (NumLock off)
    " keys in normal mode
    " KP_5 (NumLock off)
    map <ESC>[G  i
endif

" This escape sequence is the well known ANSI sequence for
" Remove Character Under The Cursor (RCUTC[tm])
map! <Esc>[3~ <Delete>
map  <ESC>[3~    x

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " automatically follow symlinks
  autocmd BufReadPost * call MyFollowSymlink(expand('<afile>'))

endif " has("autocmd")

