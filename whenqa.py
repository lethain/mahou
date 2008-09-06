# Copyright (c) 2008 Yahoo! Inc. All rights reserved.
# Licensed under the Yahoo! Search BOSS Terms of Use
# (http://info.yahoo.com/legal/us/yahoo/search/bosstos/bosstos-2317.html)

"""
This answers questions that ask when something happened
It searches the question, and counts the month + year tokens in the abstracts of the results
Then does a group by, summing up the frequencies, and prints the top month + year combo
This technique actually works sometimes ...
"""

__author__ = "Vik Singh (viksi@yahoo-inc.com)"

from yos.util import text, typechecks
from yos.yql import db
from yos.boss import ysearch

def month_lookup(s):
  for m in ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sept", "oct", "nov", "dec"]:
    if s.startswith(m): return m

def parse_month(s):
  months = filter(lambda m: m is not None, map(month_lookup, text.uniques(s)))
  if len(months) > 0:
    return text.norm(months[0]).capitalize()

def parse_year(s):
  years = filter(lambda t: len(t) == 4 and typechecks.is_int(t), text.uniques(s))
  if len(years) > 0: return text.norm(years[0])

def date_udf(r):
  return {"year": parse_year(r["abstract"]), "month": parse_month(r["abstract"]), "count": 1}

def whensearch(q):
  wt = db.select(udf=date_udf, data=ysearch.search(q, count=50))

  dates = db.group(by=["year", "month"], key="count", reducer=lambda x,y: x+y, as="total", table=wt)
  dates = db.where(lambda r: r["month"] is not None and r["year"] is not None, table=dates)
  dates = db.sort(key="total", table=dates)

  if len(dates.rows) > 0:
    top = dates.rows[0]
    return top["month"], top["year"]

  return "None", "None"
