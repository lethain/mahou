#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

__author__ = "Vik Singh (viksi@yahoo-inc.com)"

import logging

import wsgiref.handlers
from google.appengine.ext import webapp

from yos.crawl.rest import download
from yos.util import console
from whenqa import whensearch
from wwwqa import wwwsearch

SERP_TEMPLATE = "<html><head><title>Q&A: %s</title><body>" \
                "&nbsp;<font size=\"2\" face=\"arial\"><b><a href=\"http://zooie.wordpress.com\">" \
                "learn more</a></b>" \
                "<center><br/><br/>%s<br/><br/><br/>" \
                "<a href=\"/qa?query=who+is+brad+pitt+married+to\">" \
                "who is brad pitt married to</a><br/>" \
                "<a href=\"/qa?query=who+will+win+the+presidential+election\">" \
                "who will win the presidential election</a><br/>" \
                "<a href=\"/qa?query=who+plays+ari+in+entourage\">" \
                "who plays ari in entourage</a><br/>" \
                "<a href=\"/qa?query=when+did+jfk+get+assasinated\">" \
                "when did jfk get assasinated</a><br/>" \
                "<a href=\"/qa?query=who+invented+the+light+bulb\">" \
                "who invented the light bulb</a><br/>" \
                "<a href=\"/qa?query=what+company+does+jerry+yang+work+at\">" \
                "what company does jerry yang work at</a><br/>" \
                "<a href=\"/qa?query=when+was+britney+spears+born\">" \
                "when was britney spears born</a><br/>" \
                "<a href=\"/qa?query=when+did+microsoft+ipo\">" \
                "when did microsoft ipo</a><br/>" \
                "</font></center></body></head></html>"

ANSW_TEMPLATE = "<br/><font size=\"3\"><form name=\"input\" action=\"qa\" method=\"get\">" \
                "<input type=\"text\" name=\"query\" size=44 value=\"%s\">&nbsp;&nbsp;" \
                "<input type=\"submit\" value=\"?\"></form><br/>%s</font>"
WHEN_TEMPLATE = "<b>Month:</b>&nbsp;%s&nbsp;&nbsp;<b>Year:</b>&nbsp;%s"
WWW_TEMPLATE = "<b>%s</b>"

ROOT_REDIRECT = "/qa?query=when+did+yahoo+ipo"
NO_QUERY = "why didn't you provide a question"

def do_when(query):
  month, year = whensearch(query)
  answer = ANSW_TEMPLATE % (query, WHEN_TEMPLATE % (month, year))
  return SERP_TEMPLATE % (query, answer)

def do_www(query):
  phrase = wwwsearch(query)
  answer = ANSW_TEMPLATE % (query, WWW_TEMPLATE % (phrase))
  return SERP_TEMPLATE % (query, answer)

class QAHandler(webapp.RequestHandler):

  def get(self):
    query = console.strfix(self.request.get("query"))
    qt = query.split()
    if len(qt) == 0:
      page = do_www(NO_QUERY)
    elif qt[0].lower() == "when":
      page = do_when(query)
    else:
      page = do_www(query)
    self.response.out.write(page)
    
class RootHandler(webapp.RequestHandler):

  def get(self):
    self.redirect(ROOT_REDIRECT)


def main():
  logging.getLogger().setLevel(logging.DEBUG)
  application = webapp.WSGIApplication([('/', RootHandler),
                                        ('/qa', QAHandler)],
                                       debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()
