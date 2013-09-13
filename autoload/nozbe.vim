" File:    nozbe.vim
" Author:  Toshiki Teramura <toshiki.teramura@gmail.com>
" Version: 0.1.0
" License: MIT Licence


function! nozbe#get_projects(api_key)
    let l:projects = []
python << EOF
import urllib2
import json

def call_api(api_key, method, attr):
    base_url = "https://webapp.nozbe.com/api/"
    url = base_url + method
    url += "/key-" + api_key
    for key, val in attr.items():
        url += "/%s-%s" % (key, val)
    res = urllib2.urlopen(url)
    return json.load(res)

import vim
key = vim.eval("a:api_key")
for pro in call_api(key,"projects",{}):
    vim.command("call add(l:projects,{'name':'%s','id':'%s','count':'%s'})"
        % (pro[u"name"],pro[u"id"],pro[u"count"])
    )
EOF
    return l:projects
endfunction

