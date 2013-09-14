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
EOF


function! nozbe#next_actions(api_key)
    let l:actions = []
python << EOF
import vim
key = vim.eval("a:api_key")
actions = call_api(key, "actions", {"what": "next"})
for act in actions:
    cmd_tmpl = u"""\
    call add(l:actions,\
    {'name':'%(name)s',\
     'id':'%(id)s',\
     'project_name':'%(project_name)s',\
    })"""
    cmd = (cmd_tmpl % act).encode("utf-8")
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
    name  = pro[u"name"]
    id_   = pro[u"id"]
    count = pro[u"count"]
    cmd_tmpl = u"call add(l:projects,{'name':'%s','id':'%s','count':'%s'})"
    cmd = (cmd_tmpl % (name,id_,count)).encode("utf-8")
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
    name  = con[u"name"]
    id_   = con[u"id"]
    count = con[u"count"]
    cmd_tmpl = u"call add(l:contexts,{'name':'%s','id':'%s','count':'%s'})"
    cmd = (cmd_tmpl % (name,id_,count)).encode("utf-8")
    vim.command(cmd)
EOF
    return l:contexts
endfunction
