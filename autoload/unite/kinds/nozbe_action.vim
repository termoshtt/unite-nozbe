" File:    nozbe_action.vim
" Author:  Toshiki Teramura <toshiki.teramura@gmail.com>
" License: MIT Licence

let s:nozbe_action_kind = {
    \ "name": "nozbe_action",
    \ "default_action": "check",
    \ "action_table": {
    \       "check":{
    \           "description": "check",
    \       }
    \    }
    \ }

function! s:nozbe_action_kind.action_table.check.func(candidate)
    let l:action = a:candidate.action__action
    call nozbe#check(g:unite_nozbe_api_key,l:action.id)
    echo printf("[checked] %s (%s)", l:action.name, l:action.project_name)
    echo l:action.id
endfunction

function! unite#kinds#nozbe_action#define()
    return s:nozbe_action_kind
endfunction
