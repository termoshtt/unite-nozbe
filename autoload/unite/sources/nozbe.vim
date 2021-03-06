" File:    nozbe.vim
" Author:  Toshiki Teramura <toshiki.teramura@gmail.com>
" License: MIT Licence

" Main source
let s:nozbe_src = {'name': 'nozbe'}
function! s:nozbe_src.gather_candidates(args,context)
    return map([
        \ ['Next Actions', 'next_actions'],
        \ ['Projects', 'projects'],
        \ ['Contexts', 'contexts'],
        \ ],'{
        \ "word"  : v:val[0],
        \ "source": s:nozbe_src.name,
        \ "kind"  : "source",
        \ "action__source_name" : "nozbe/" . v:val[1],
        \ }')
endfunction


" Next Action
let s:nozbe_next_action_src = {
    \ 'name': 'nozbe/next_actions',
    \ }
function! s:nozbe_next_action_src.gather_candidates(args,context)
    return map(call(function("nozbe#next_actions"),[g:nozbe_api_key,]),'{
        \ "word": nozbe#display_action(v:val),
        \ "source": s:nozbe_next_action_src.name,
        \ "kind": "nozbe_action",
        \ "action__action": v:val,
        \ }')
endfunction


" Project
let s:nozbe_project_src = {'name': 'nozbe/projects'}
function! s:nozbe_project_src.gather_candidates(args,context)
    let l:projects = call(function("nozbe#projects"), [g:nozbe_api_key,])
    return map(l:projects,'{
        \ "word": v:val["name"],
        \ "source": s:nozbe_project_src.name,
        \ "kind": "source",
        \ "action__source_name": "nozbe/project_actions",
        \ "action__source_args": [v:val["id"]],
        \ }')
endfunction


" Context
let s:nozbe_context_src = {'name': 'nozbe/contexts'}
function! s:nozbe_context_src.gather_candidates(args,context)
    let l:contexts = call(function("nozbe#contexts"), [g:nozbe_api_key,])
    return map(l:contexts,'{
        \ "word": v:val["name"],
        \ "source": s:nozbe_context_src.name,
        \ "kind": "source",
        \ "action__source_name": "nozbe/context_actions",
        \ "action__source_args": [v:val["id"]],
        \ }')
endfunction


" Project actions
let s:nozbe_project_actions_src = {"name": "nozbe/project_actions"}
function! s:nozbe_project_actions_src.gather_candidates(args,context)
    let l:actions = call(function("nozbe#project_actions"),[g:nozbe_api_key,a:args[0]])
    return map(l:actions,'{
        \ "word": nozbe#display_action(v:val),
        \ "source": s:nozbe_next_action_src.name,
        \ "kind": "nozbe_action",
        \ "action__action": v:val,
        \ }')
endfunction


" Context actions
let s:nozbe_context_actions_src = {"name": "nozbe/context_actions"}
function! s:nozbe_context_actions_src.gather_candidates(args,context)
    let l:actions = call(function("nozbe#context_actions"),[g:nozbe_api_key,a:args[0]])
    return map(l:actions,'{
        \ "word": nozbe#display_action(v:val),
        \ "source": s:nozbe_next_action_src.name,
        \ "kind": "nozbe_action",
        \ "action__action": v:val,
        \ }')
endfunction


function! unite#sources#nozbe#define()
    call unite#define_source(s:nozbe_next_action_src)
    call unite#define_source(s:nozbe_project_src)
    call unite#define_source(s:nozbe_context_src)
    call unite#define_source(s:nozbe_project_actions_src)
    call unite#define_source(s:nozbe_context_actions_src)
    return s:nozbe_src
endfunction
