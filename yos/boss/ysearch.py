# Copyright (c) 2008 Yahoo! Inc. All rights reserved.
# Licensed under the Yahoo! Search BOSS Terms of Use
# (http://info.yahoo.com/legal/us/yahoo/search/bosstos/bosstos-2317.html)

"""
This is the Boss search API
search is the main function

Examples:
  web_results = search("britney spears")
  news_20_results = search("tiger woods", vertical="news", count=20)
"""

__author__ = "Vik Singh (viksi@yahoo-inc.com)"

from urllib import quote_plus

from django.utils import simplejson

from yos.crawl import rest

CONFIG = simplejson.load(open("config", "r"))
SEARCH_API_URL = CONFIG["uri"].rstrip("/") + "/%s/v%d/%s?start=%d&count=%d&lang=%s&region=%s" + "&appid=" + CONFIG["appid"]

def params(d):
  """ Takes a dictionary of key, value pairs and generates a cgi parameter/argument string """
  p = ""
  for k, v in d.iteritems():
    p += "&%s=%s" % (quote_plus(k), quote_plus(v))
  return p

def search(command, vertical="web", version=1, start=0, count=10, lang="en", region="us", more={}):
  """
  command is the query (not escaped)
  vertical can be web, news, spelling, images
  lang/region default to en/us - take a look at the the YDN Boss documentation for the supported lang/region values
  """
  url = SEARCH_API_URL % (vertical, version, quote_plus(command), start, count, lang, region) + params(more)
  return rest.load_json(url)
