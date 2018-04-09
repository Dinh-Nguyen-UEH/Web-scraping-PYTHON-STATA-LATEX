import os

from requests import get 
from bs4 import BeautifulSoup
 
import time
from time import time
from time import sleep

import math
from random import randint
import random as random

from warnings import warn
from IPython.core.display import clear_output

import re
import pandas as pd
from openpyxl import load_workbook
import requests

parms = {'append'        : 'true',
                         'categoryId'    : '',  
                         'page'          : 84,
                         'provinceId'    : '217',
                         'st'            : '2',         #Sort by most viewed
                         'vt'            : 'row',
                         'CategoryGroup' : 'food',      #Group 
                         'dtids'         : 15,    #Districts
                         'c'             : 2     #Categories 
                        }

#Make a request  


response = requests.post(url = "https://www.foody.vn/ho-chi-minh/quan-an?ds=Restaurant&vt=row&st=1&dtids=15&c=3&page=4&provinceId=217&categoryId=3&append=true",
                            )   

print(response)
response_json = response.json() 
print(response_json)
print(list(response_json.keys()))
 



response = requests.post(url = "https://www.foody.vn/ho-chi-minh/quan-an?ds=Restaurant&vt=row&st=1&dtids=15&c=3&page=5&provinceId=217&categoryId=3&append=true"
                            )   

print(response)
response_json = response.json() 
print(response_json)
print(list(response_json.keys()))
 
