
let s:api_base_url = "http://dev.webapp.nozbe.com/sync2/"

let s:app_key_termoshtt = "MF5dMyqHem"

function! nozbe#data#call_api(method, key, attr)
    let api_url = s:api_base_url . a:method . "/app_key-" . s:app_key_termoshtt . "/key-" . a:key
    let header = {"Content-Type": "application/json"}
    let param_json = webapi#json#encode(a:attr)
    let response = webapi#http#post(api_url, param_json, header)
    let g:nozbe_debug_response = webapi#json#decode(response['content'])
    return g:nozbe_debug_response
endfunction

" Get api_key interactively to save to g:nozbe_api_key
function! nozbe#data#login()
    let email = input('Enter email for Nozbe.com: ')
    let passwd = inputsecret(printf('Enter Password for Nozbe.com (%s): ', email))
    let md5_passwd = md5#md5(passwd)
    let attr = {
    \   "email": email,
    \   "password": md5_passwd,
    \ }
    let res = nozbe#data#call_api("login", "", attr)
    if !has_key(res, "key")
        echoerr "login Failed" . join(res["error"], ', ')
    else
        let g:nozbe_api_key = res["key"]
    endif
endfunction

" Sign up to Nozbe.com first
function! nozbe#data#signup()
    let name = input('Enter your Name: ')
    let email = input('Enter your E-mail: ')
    let passwd = inputsecret('Enter Password: ')
    let passwd_dual = inputsecret('Enter Password (for confirmation): ')
    if passwd !=# passwd_dual
        echoerr "Password does not match"
        return
    endif
    let attr = {
    \   "name": name,
    \   "email": email,
    \   "password": passwd
    \ }
    let res = nozbe#data#call_api("signup", "", attr)
    if !has_key(res, "key")
        echoerr "sign up Failed" . join(res["error"], ', ')
    else
        let g:nozbe_api_key = res["key"]
    endif
endfunction

" Getting data
function! nozbe#data#get()
    if !exists("g:nozbe_api_key")
        call nozbe#data#login()
    endif
    let g:nozbe_data = nozbe#data#call_api("getdata", g:nozbe_api_key, { "what": "all" })
endfunction

" Sync data
function! nozbe#data#process()
    if !exists("g:nozbe_api_key")
        call nozbe#data#login()
    endif
    if !exists("g:nozbe_data")
        echoerr "Please get nozbe data first."
        return
    endif
    let res = nozbe#data#call_api("process", g:nozbe_api_key, g:nozbe_data)
    if has_key(res, "error")
        echoerr "Error occurs while process: " . res["error"]
    else
        let g:nozbe_data = res
    endif
endfunction

function! nozbe#data#timestamp()
    if !exists("g:nozbe_api_key")
        call nozbe#data#login()
    endif
    return nozbe#data#call_api("getserver_ts", g:nozbe_api_key, {})['ts']
endfunction

