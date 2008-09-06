# Copyright (c) 2008 Yahoo! Inc. All rights reserved.
# Licensed under the Yahoo! Search BOSS Terms of Use
# (http://info.yahoo.com/legal/us/yahoo/search/bosstos/bosstos-2317.html)

"""
This answers questions that start with who/what/where 
It searches the question, extracts the capitalized n-grams from the abstracts and titles
Then does a group by, summing up the frequencies, and prints the top n-gram
This technique actually works sometimes ...
"""

__author__ = "Vik Singh (viksi@yahoo-inc.com)"

from collections import defaultdict
from operator import itemgetter

from yos.util import text, typechecks
from yos.yql import db
from yos.boss import ysearch

def calc_pl(q):
  if q.split()[0].lower() == "who":
    return 2
  return 1
  
class QueryMiner:
  def __init__(self, query, pl=1):
    self._querystops = set(text.tokenize(query))
    self._pl = calc_pl(query)

  def extract(self, r):
    content = text.strip_enclosed_carrots(r["title"]) + " " + text.strip_enclosed_carrots(r["abstract"])
    ctokens = content.split()
  
    phrases = []
    current = []
    for ct in ctokens:
      if text.is_capitalized(ct):
        current += filter(lambda w: w not in self._querystops, text.tokenize(ct))
      elif len(current) > 0:
        if len(current) >= self._pl:
          phrases.append(" ".join(current))
        current = []
    return phrases

def wwwsearch(q):
  qm = QueryMiner(q)

  def phrases_udf(r):
    r.update({"phrases": qm.extract(r)}) ; return r

  pc = defaultdict(lambda: 1)
  
  def pc_udf(r):
    for p in r["phrases"]: pc[p] += 1
    
  w = db.select(udf=phrases_udf, data=ysearch.search(q, count=50))
  db.select(udf=pc_udf, table=w)

  if len(pc) > 0:
    return sorted(pc.iteritems(), key=itemgetter(1), reverse=True)[0][0]

  return "None"
