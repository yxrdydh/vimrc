" File: runlog.vim
" Author: Michael Goerz (goerz@physik.uni-kassel.de)
" License: Public Domain
" Description: 
"    Filetype plugin for 'runlog' files: spreadsheet-like collection of
"    results of numerical simulations
"
"    Running jobs are indicated with 'R' in the first column and
"    are highlighted in green.
"
"    Jobs can be marked with an 'X' in the first column and are then
"    highlighted in red.
"
"    Comment lines are indicated by a 'C' in the first column
"
"    Every second line gets a light-gray background if it is not highlighted
"    already with any of the above marks, for easier readability
"
" Installation:
"    Copy this file into your ftplugin directory. Use filetype "runlog' for a
"    file
"

function! s:RunLogHighlight()
    sign unplace *
    let l:b = bufnr("%")
    highlight RunLogRunningHL ctermfg=black ctermbg=green
    \ guifg=black guibg=green
    highlight RunLogXHL ctermfg=black ctermbg=202
    \ guifg=black guibg=#ff5f00
    highlight RunLogEvenHL ctermfg=black ctermbg=255
    \ guifg=black guibg=#eeeeee
    sign define RunLogRunningMark linehl=RunLogRunningHL
    sign define RunLogCommentMark linehl=Comment
    sign define RunLogXMark       linehl=RunLogXHL
    sign define RunLogEvenMark    linehl=RunLogEvenHL
    for l:linenum in range(1, line('$'))
        if match(getline(l:linenum), '^\s*R\s') >= 0
            execute "sign place ".l:linenum." line=".l:linenum
            \ ." name=RunLogRunningMark buffer=".l:b
        elseif match(getline(l:linenum), '^\s*X\s') >= 0
            execute "sign place ".l:linenum." line=".l:linenum
            \ ." name=RunLogXMark buffer=".l:b
        elseif match(getline(l:linenum), '^\s*C\s') >= 0
            execute "sign place ".l:linenum." line=".l:linenum
            \ ." name=RunLogCommentMark buffer=".l:b
        elseif (l:linenum % 2 == 1)
            execute "sign place ".l:linenum." line=".l:linenum
            \ ." name=RunLogEvenMark buffer=".l:b
        endif
    endfor
endfunction  

set nospell
set textwidth=0
set foldenable
set foldmethod=manual
au! BufWrite,BufRead,BufEnter,BufLeave,InsertLeave,CursorMoved <buffer>
\ :call s:RunLogHighlight()
