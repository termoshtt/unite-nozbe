
let s:api_base_url = "https://webapp.nozbe.com/api/"


function! nozbe#call_api(api_key, method, attr)
    let api_url = s:api_base_url . a:method . "/key-" . a:api_key
    for [key, val] in items(a:attr)
        let api_url = api_url . "/" . key . "-" . val
    endfor
    let result = webapi#http#get(api_url)
    return webapi#json#decode(result["content"])
endfunction


function! nozbe#projects(api_key)
    return nozbe#call_api(a:api_key, "projects", {})
endfunction


function! nozbe#contexts(api_key)
    return nozbe#call_api(a:api_key, "contexts", {})
endfunction


function! nozbe#next_actions(api_key)
    return nozbe#call_api(a:api_key, "actions", {"what": "next"})
endfunction


function! nozbe#project_actions(api_key, project_id)
    return nozbe#call_api(a:api_key, "actions", {"what": "project", "id": a:project_id})
endfunction


function! nozbe#context_actions(api_key, context_id)
    return nozbe#call_api(a:api_key, "actions", {"what": "context", "id": a:context_id})
endfunction


function! nozbe#display_action(act)
    let template = "[%s] %-30S\t[%s] [%s] [%s] [%s]"
    return printf(template,a:act["done"], a:act["name"], a:act["project_name"], a:act["time"], a:act["context_name"], a:act["next"])
endfunction

