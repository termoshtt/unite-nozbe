" File:    nozbe.vim
" Author:  Toshiki Teramura <toshiki.teramura@gmail.com>
" Version: 0.1.0
" License: MIT Licence

" Main source
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

" Next Action
let s:nozbe_next_action_src = {'name': 'nozbe/next_action'}
function! s:nozbe_next_action_src.gather_candidates(args,context)
    return map(call(function("nozbe#next_actions"),[g:unite_nozbe_api_key,]),'{
        \ "word": v:val["name"],
        \ "source": s:nozbe_next_action_src.name,
        \ "kind": "word",
        \ }')
endfunction

" Project
let s:nozbe_project_src = {'name': 'nozbe/project'}
function! s:nozbe_project_src.gather_candidates(args,context)
    let l:Projects_f = function("nozbe#get_projects")
    let l:projects = call(l:Projects_f, [g:unite_nozbe_api_key,])
    return map(l:projects,'{
        \ "word": v:val["name"],
        \ "source": s:nozbe_project_src.name,
        \ "kind": "word",
        \ }')
endfunction

" Context
let s:nozbe_context_src = {'name': 'nozbe/context'}
function! s:nozbe_context_src.gather_candidates(args,context)
    return [{
        \ 'word': 'src1',
        \ 'source': 'nozbe/next_action',
        \ 'kind': 'word'
        \ }]
endfunction


function! unite#sources#nozbe#define()
    call unite#define_source(s:nozbe_next_action_src)
    call unite#define_source(s:nozbe_project_src)
    call unite#define_source(s:nozbe_context_src)
    return s:nozbe_src
endfunction

