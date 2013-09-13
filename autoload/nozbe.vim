" File:    nozbe.vim
" Author:  Toshiki Teramura <toshiki.teramura@gmail.com>
" Version: 0.1.0
" License: MIT Licence

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
    try:
        return json.load(res)
    except:
        return None
EOF

function! nozbe#get_projects(api_key)
    " let l:projects = [ {'name':'project_zero','id':'dfak'} ]
    let l:projects = []
python << EOF
import vim
key = vim.eval("a:api_key")
projects = call_api(key,"projects",{})
print(projects)
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

