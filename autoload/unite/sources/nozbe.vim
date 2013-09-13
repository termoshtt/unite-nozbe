" File:    nozbe.vim
" Author:  Toshiki Teramura <toshiki.teramura@gmail.com>
" Version: 0.1.0
" License: MIT Licence


let s:nozbe_src = {'name': 'nozbe'}

function! s:nozbe_src.gather_candidates(args,context)
    return map([
        \ ['Next Action', 'next_action'],
        \ ['Project', 'project'],
        \ ['Context', 'context'],
        \ ],'{
        \ "word"  : v:val[0],
        \ "source": s:nozbe_src.name,
        \ "kind"  : "source",
        \ "action__source_name" : "nozbe/" . v:val[1],
        \ }')
endfunction


let s:nozbe_next_action_src = {'name': 'nozbe/next_action'}

function! s:nozbe_next_action_src.gather_candidates(args,context)
    return [{
        \ 'word': 'src1',
        \ 'source': 'nozbe/next_action',
        \ 'kind': 'word'
        \ }]
endfunction


function! unite#sources#nozbe#define()
    call unite#define_source(s:nozbe_next_action_src)
    return s:nozbe_src
endfunction

