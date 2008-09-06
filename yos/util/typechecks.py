# Copyright (c) 2008 Yahoo! Inc. All rights reserved.
# Licensed under the Yahoo! Search BOSS Terms of Use
# (http://info.yahoo.com/legal/us/yahoo/search/bosstos/bosstos-2317.html)

__author__ = "Vik Singh (viksi@yahoo-inc.com)"

from yos.crawl import object_dict
from types import DictType, ListType, TupleType

OBJ_DICT_TYPE = type(object_dict.object_dict())

def is_dict(td):
  return td is DictType or td is OBJ_DICT_TYPE
                
def is_ordered(to):
  return to is ListType or to is TupleType

def is_list(o):
  return o is ListType

def is_int(o):
  try:
    int(o)
    return True
  except:
    return False
