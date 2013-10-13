" File:    nozbe.vim
" Author:  Toshiki Teramura <toshiki.teramura@gmail.com>
" License: MIT Licence


python << EOF
import urllib2
import json


def call_api(api_key, method, attr={}):
    base_url = "https://webapp.nozbe.com/api/"
    url = base_url + method
    url += "/key-" + api_key
    for key, val in attr.items():
        url += "/%s-%s" % (key, val)
    res = urllib2.urlopen(url)
    try:
        return json.load(res)
    except:
        return []

cmd_tmpl_actions = u"""\
    call add(%(vim_val)s,\
    {'name':'%(name)s',\
     'done':'%(done)s',\
     'next':'%(next)s',\
     'time':'%(time)s',\
     'id':'%(id)s',\
     'project_name':'%(project_name)s',\
     'project_id':'%(project_id)s',\
     'context_name':'%(context_name)s',\
     'context_id':'%(context_id)s',\
    })"""

cmd_tmpl_project = u"""\
    call add(%(vim_val)s,\
    {'name':'%(name)s',\
     'id':'%(id)s',\
     'count':'%(count)s',\
    })"""

cmd_tmpl_context = cmd_tmpl_project
EOF


function! nozbe#next_actions(api_key)
    let l:actions = []
python << EOF
import vim
key = vim.eval("a:api_key")
actions = call_api(key, "actions", {"what": "next"})
for act in actions:
    act.update({"vim_val":"l:actions"})
    cmd = (cmd_tmpl_actions % act).encode("utf-8")
    vim.command(cmd)
EOF
    return l:actions
endfunction


function! nozbe#get_projects(api_key)
    let l:projects = []
python << EOF
import vim
key = vim.eval("a:api_key")
projects = call_api(key,"projects")
for pro in projects:
    pro.update({"vim_val":"l:projects"})
    cmd = (cmd_tmpl_project % pro).encode("utf-8")
    vim.command(cmd)
EOF
    return l:projects
endfunction


function! nozbe#get_contexts(api_key)
    let l:contexts = []
python << EOF
import vim
key = vim.eval("a:api_key")
contexts = call_api(key,"contexts")
for con in contexts:
    con.update({"vim_val":"l:contexts"})
    cmd = (cmd_tmpl_context % con).encode("utf-8")
    vim.command(cmd)
EOF
    return l:contexts
endfunction


function! nozbe#get_project_actions(api_key,project_id)
    let l:actions = []
python << EOF
import vim
key = vim.eval("a:api_key")
pid = vim.eval("a:project_id")
actions = call_api(key, "actions", {"what": "project", "id" : pid})
for act in actions:
    act.update({"vim_val":"l:actions"})
    cmd = (cmd_tmpl_actions % act).encode("utf-8")
    vim.command(cmd)
EOF
    return l:actions
endfunction


function! nozbe#get_context_actions(api_key,context_id)
    let l:actions = []
python << EOF
import vim
key = vim.eval("a:api_key")
cid = vim.eval("a:context_id")
actions = call_api(key, "actions", {"what": "context", "id" : cid})
for act in actions:
    act.update({"vim_val":"l:actions"})
    cmd = (cmd_tmpl_actions % act).encode("utf-8")
    vim.command(cmd)
EOF
    return l:actions
endfunction


function! nozbe#check(api_key,action_id)
python << EOF
key = vim.eval("a:api_key")
aid = vim.eval("a:action_id")
call_api(key,"check",{"ids":aid})
EOF
endfunction


function! nozbe#display_action(act)
    let l:template = "[%s] %-30S\t[%s] [%s] [%s] [%s]"
    return printf(l:template,a:act["done"], a:act["name"], a:act["project_name"], a:act["time"], a:act["context_name"], a:act["next"])
endfunction
