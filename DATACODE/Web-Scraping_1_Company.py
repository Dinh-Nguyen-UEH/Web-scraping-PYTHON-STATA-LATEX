import os

from time import sleep
import random as random
import requests
import json
from bs4 import BeautifulSoup
import pandas as pd
from requests.utils import quote
from openpyxl import load_workbook

#Set working directory
#os.chdir('C:/Users/nguye/Dropbox (Vo Tat Thang)/[0][Master]Database/(3)Library_of_Project/(99)Mics/(13)Web-scraping') # Provide the path here 
os.chdir('D:/Dropbox (Vo Tat Thang)/[0][Master]Database/(3)Library_of_Project/(99)Mics/(13)Web-scraping') # Provide the path here 

#Page URL 
url =  "https://www.hsx.vn/Modules/Listed/Web/SymbolList?"  

#Extract all company data
parms = {'_search': 'false', \
        'page': '1', \
        'pageCriteriaLength': '4', \
        'pageFieldName1': 'Code', \
        'pageFieldName2': 'Sectors', \
        'pageFieldName3': 'Sector', \
        'pageFieldName4': 'StartWith', \
        'pageFieldOperator1': 'eq', \
        'pageFieldOperator2': '', \
        'pageFieldOperator3': '', \
        'pageFieldOperator4': '', \
        'pageFieldValue1': '', \
        'pageFieldValue2': '' , \
        'pageFieldValue3': '', \
        'pageFieldValue4': '', \
        'rows': '400', \
        'sidx': 'id', \
        'nd' : '', \
        'sord': 'desc' 
        }

#print(parms)

#Request data from server (Note: must use get, post returns all values)
response = requests.get(url = url, \
                        params = parms, \
                        headers = {'X-Requested-With': 'XMLHttpRequest' \
                                ,  'User-Agent': 'My web scraping program. Contact me at Dinh.Nguyen.UEH@outlook.com'
                                    }
                        ) 
print(response.request.url)

#Convert data to html
response_html = BeautifulSoup(response.text, "lxml")
response_html.encode('utf-8')

#Convert html to json
response_json = response.json()
print(response_json)

#Paste json data to data frame and save as and excel file
writer = pd.ExcelWriter(os.path.join("DATARAW", 'company_data_uncleaned.xlsx'), engine = 'openpyxl')

df1 = pd.DataFrame(response_json) 
df1.to_excel(writer \
        , 'All companies' \
        , index = False)
writer.save()
writer.close()

