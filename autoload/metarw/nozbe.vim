

function! metarw#nozbe#read(fakepath)
    let sp_path = split(a:fakepath, '^\l\+\zs:')

    if len(sp_path) < 1
        echoerr 'Unexpected a:fakepath:' string(a:fakepath)
    endif

    if len(sp_path) == 1
        let actions = nozbe#next_actions(g:nozbe_api_key)
        return ['browse', map(actions, '{"label": v:val["name"], "fakepath": v:val["id"] }')]
    else
        " TODO
        return ['done', '']
    endif
endfunction

