# Copyright (c) 2008 Yahoo! Inc. All rights reserved.
# Licensed under the Yahoo! Search BOSS Terms of Use
# (http://info.yahoo.com/legal/us/yahoo/search/bosstos/bosstos-2317.html)

""" A simple text library for normalizing, cleaning, and overlapping strings """

__author__ = "Vik Singh (viksi@yahoo-inc.com)"

from stops import STOPWORDS

STRIP = "\'\"`,.;-!?:()[]{}*<>\\/|%$@`~%^&_=+"

def strip_enclosed_carrots(s):
  i = s.find("<")
  if i >= 0:
    j = s.find(">", i)
    if j > i:
      j1 = j + 1
      if j1 >= len(s):
        return strip_enclosed_carrots(s[:i])
      else:
        return strip_enclosed_carrots(s[:i] + s[j1:])
  return s

def filter_stops(words, stops=[]):
  return filter(lambda w: w not in STOPWORDS and w not in stops, words) 

def uniques(s):
  return set( tokenize(s) )

def tokenize(s, rem_stops=True):
  tks = filter(lambda st: len(st) > 0, map(lambda t: t.lower().strip(STRIP).replace("-", " ").strip(), s.split()))
  if rem_stops:
    return filter_stops(tks)
  return tks

def norm(s):
  return "".join( sorted( tokenize(s) ) )

def overlap(s1, s2):
  return len(uniques(s1) & uniques(s2))

def is_capitalized(s):
  return s[0] == s[0].upper()
