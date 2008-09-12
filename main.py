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
from yos.util import text, console
from yos.boss import ysearch
from yos.yql import udfs, db

from django.utils import simplejson

class ImageSearchHandler(webapp.RequestHandler):
  def get(self):
    query = console.strfix(self.request.get("query"))
    offset = int(console.strfix(self.request.get("offset")))
    data = ysearch.search(query,vertical="images",count=20,start=offset);
    images = db.create(data=data)
    serialized = simplejson.dumps(images.rows)
    self.response.out.write(serialized)

class NewsSearchHandler(webapp.RequestHandler):
  def get(self):
    query = console.strfix(self.request.get("query"))
    offset = int(console.strfix(self.request.get("offset")))
    data = ysearch.search(query,vertical="news",count=20,start=offset);
    images = db.create(data=data)
    serialized = simplejson.dumps(images.rows)
    self.response.out.write(serialized)


def overlap_predicate(r1,r2):
  return text.overlap(r1['title'],r2['title']) > 1

class WebSearchHandler(webapp.RequestHandler):


  def get(self):
    query = console.strfix(self.request.get("query"))
    offset = int(console.strfix(self.request.get("offset")))
    includeDelicious = console.strfix(self.request.get("includeDelicious"))      

    search_results = ysearch.search(query,count=20,start=offset);
    web = db.create(data=search_results)
    if len(includeDelicious) == 4:
      dl = db.select(udfs.unnest_value, name="dl", url=u"http://feeds.delicious.com/rss/popular/%s" % query)
      web = db.join(overlap_predicate,[web,dl])

    serialized = simplejson.dumps(web.rows)
    self.response.out.write(serialized)
    
class RootHandler(webapp.RequestHandler):

  def get(self):
    self.redirect(ROOT_REDIRECT)


def main():
  logging.getLogger().setLevel(logging.DEBUG)
  application = webapp.WSGIApplication([('/', RootHandler),
                                        ('/search/images', ImageSearchHandler),
                                        ('/search/web', WebSearchHandler),
                                        ('/search/news', NewsSearchHandler),
                                        ],
                                       debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()
