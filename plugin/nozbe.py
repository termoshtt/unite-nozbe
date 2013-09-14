# coding=utf-8

import urllib2
import json

base_url = "https://webapp.nozbe.com/api/"


def _call_api(api_key, method, attr):
    url = base_url + method
    url += "/key-" + api_key
    for key, val in attr.items():
        url += "/%s-%s" % (key, val)
    res = urllib2.urlopen(url)
    return json.load(res)


def projects(api_key):
    return _call_api(api_key, "projects", {})


def contexts(api_key):
    return _call_api(api_key, "contexts", {})


def next_actions(api_key):
    return _call_api(api_key, "actions", {"what": "next"})
