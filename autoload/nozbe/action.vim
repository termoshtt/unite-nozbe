
" Write an action to a buffer
"
" @param task [dict]
" @param bufnr [int]
" @param line [int]
"
" 1. Move to the buffer
" 2. Write action
" 3. Return to the previous buffer
"
function! nozbe#action#write(task, bufnr, line)
    let now_bufnr = bufnr("%")
    execute ":buffer " . a:bufnr
    let title_line = ""
    if a:task["next"]
        let title_line = title_line . "*"
    endif
    if a:task["completed"]
        let title_line = title_line . "[x]"
    else
        let title_line = title_line . "[ ]"
    endif
    let title_line = title_line . " " . a:task["name"]

    let project = nozbe#data#get_project(a:task["project_hash"])
    let desk_line = "#" . project["name"]

    if type(a:task["contexts"]) == type([])
        for context in a:task["contexts"]
            let name = nozbe#data#get_context(context["context_hash"])["name"]
            let desk_line = desk_line . " @" . name
        endfor
    endif

    let comment_lines = []
    if type(a:task["comments"]) == type([])
        for comme in a:task["comments"]
            let user = nozbe#data#get_user(comme["user_hash"])
            call add(comment_lines, ">>" . user . " " . comme["date"])
            let body = comme["body"]
        endfor
    endif

    call append(a:line, [title_line, desk_line])
    execute ":buffer " . now_bufnr
endfunction

