
import os

import xlrd

from selenium import webdriver
from selenium.webdriver.common.keys import Keys

from time import sleep 
from time import time

import random as random

#Set working directory
os.chdir('D:/Dropbox (Vo Tat Thang)/[0][Master]Database/(3)Library_of_Project/(99)Mics/(13)Web-scraping') # Provide the path here 

#Get stock names from HNX data base (pre-processed in STATA)
filename = os.path.join("DATADES", 'company_data_cleaned.xlsx')
data = xlrd.open_workbook(filename)
stock_code = data.sheets()[0]  
stock_code = stock_code.col_values(0)
stock_code.remove('Stock code')

#Page URL
url =  "https://www.vndirect.com.vn/portal/thong-ke-thi-truong-chung-khoan/lich-su-gia.shtml" 
 
#Input date to retieve price data
date_start = "01/01/2008"
date_end = "30/3/2018"

xpaths = {"stock_code"  : "//[@id='symbolID']", \
          "date_start"  : "//*[@id='fHistoricalPrice_FromDate']", \
          "date_end"    : "//*[@id='fHistoricalPrice_ToDate']", \
          "find_bottom" : "//*[@id='fHistoricalPrice_View']", \
          "down_bottom" : "//*[@id='tab-1']/div[2]/div/div/a/span[1]"
         }


#Open browser first time 
edge_driver = webdriver.Edge(os.path.join("DATADOC", 'MicrosoftWebDriver.exe'))

#Get price data for each stock
requests = 0
start_time = time()
for stock in stock_code:
 
    #Open webpage    
    edge_driver.get(url = url) 

    #Monitor the requests
    requests += 1
    elapsed_time = time() - start_time
    print('Request: {}-{}; Frequency: {} requests/s; Elapsed time: {}'.format(requests, stock, requests/elapsed_time,elapsed_time))

    #Input needed information
    edge_driver.find_element_by_xpath(xpaths['stock_code']).send_keys(stock)
    edge_driver.find_element_by_xpath(xpaths['date_start']).send_keys(date_start)
    edge_driver.find_element_by_xpath(xpaths['date_end']).send_keys(date_end)

    #Click find
    edge_driver.find_element_by_xpath(xpaths['find_bottom']).click()
    #Wait before download
    sleep(random.uniform(1,2)) 

    #Click download
    edge_driver.find_element_by_xpath(xpaths['down_bottom']).click() 
    #Wait for Edge to catch file from page
    sleep(random.uniform(3,5)) 

    #Quit browser and re-open webpage to prevent disconnection from server
    random_number = random.randint(1,10)
    if random_number == 3:

        #Quit browser
        edge_driver.quit()

        #Open browser
        edge_driver = webdriver.Edge(os.path.join("DATADOC", 'MicrosoftWebDriver.exe'))