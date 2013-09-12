" File:    nozbe.vim
" Author:  Toshiki Teramura <toshiki.teramura@gmail.com>
" Version: 0.1.0
" License: MIT Licence


let s:commands = [
    \ 'Next Action',
    \ 'Project',
    \ 'Context',
    \]

let s:source = {
    \ 'name': 'nozbe',
    \ }


function! s:source.gather_candidates(args,context)
    call unite#print_message('[nozbe] Nozbe commands')
    return map(s:commands,'{
        \ "word"  : v:val,
        \ "source": s:source.name,
        \ "kind"  : "source",
        \ "action__source_name" : "nozbe/" . v:val,
        \ }')
endfunction


function! unite#source#nozbe#define()
    return s:source
endfunction

