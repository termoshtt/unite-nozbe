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
