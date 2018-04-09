#https://www.foody.vn/ho-chi-minh/dia-diem-tai-quan-11
#https://www.foody.vn/ho-chi-minh/dia-diem?CategoryGroup=food&dtids=12,13,17 
    #Thành phố Hồ Chí Minh
        #Quận 1:------------1
        #Quận 2:------------4
        #Quận 3:------------5
        #Quận 4:------------6
        #Quận 5:------------7
        #Quận 6:------------8
        #Quận 7:------------9
        #Quận 8:-----------10
        #Quận 9:-----------11
        #Quận 10:----------12
        #Quận 11:----------13
        #Quận 12:----------14
        #Quận Bình Thạnh:--15
        #Quận Tân Bình:----16
        #Quận Phú Nhuận:---17
        #Quận Bình Tân:----18
        #Quận Tân Phú:-----19
    #Phân loại:
        #Nhà hàng:-------------1
        #Cà phê/dessert:-------2
        #Quán ăn:--------------3
        #Bar/pub:--------------4
        #Karaoke:--------------5
        #Tiệm bánh:------------6
        #Tiệc cưới/hội nghị:---9 
        #Ăn vặt/ vỉa hè:------11
        #Sang trọng:----------12
        #Giao cơm văn phòng:--28
        #Buffet:--------------39
        #Beer club:-----------43
        #Tiệc tận nơi:--------44
        #Khu ẩm thực:---------79


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
        
#1,    4,    5,    6,    7,    8,    9,    10,   11,   12,    13,    14,    
#"Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7", "Q8", "Q9", "Q10", "Q11", "Q12", 
districts      = [15,    16,    17,    18,    19]
districts_name = ["QBTh", "QTB", "QPN", "QBTa", "QTP"] 

categories = [1, 2, 3, 4, 5, 6, 9, 11, 12, 28, 39, 43, 44, 79]
categories_name = ["Nhà hàng", 
                "Cà phê-dessert",
                "Quán ăn",
                "Bar-pub", 
                "Karaoke", 
                "Tiệm bánh", 
                "Tiệc cưới-hội nghị", 
                "Ăn vặt-vỉa hè", 
                "Sang trọng", 
                "Giao cơm văn phòng", 
                "Buffet",                
                "Beer club", 
                "Tiệc tận nơi", 
                "Khu ẩm thực", 
                ]

#Set working directory
os.chdir('D:/Dropbox (Vo Tat Thang)/[0][Master]Database/(3)Library_of_Project/(99)Mics/(13)Web-scraping') # Provide the path here 

#List to store scrapped data
names = [] 
scores = [] 
stats = []
addresses = [] 

#Starting log 

#Loop monitoring
start_time = time()
i = 1
for district, district_name in zip(districts, districts_name):
 
    for category, category_name in zip(categories, categories_name):

        #Clearing lists
        names[:] = []
        scores[:] = []
        stats[:] = []
        addresses[:] = []

        #Set parameters for looping with district and category
        parms = {'append'       : 'true',
                'categoryId'    : '',  
                'page'          : '1',
                'provinceId'    : '217',
                'st'            : '2',      #Sort by most viewed
                'vt'            : 'row',
                'CategoryGroup' : 'food',   #Group 
                'dtids'         : district, #Districts
                'c'             : category,  #Categories 
                'maxPageToLoad' : '100'
                }

        #Make a request 
        url = "https://www.foody.vn/ho-chi-minh/dia-diem?"
        t_0 = time()
        response = get(url = url, \
                params = parms, \
                headers = { # Tell the admin that you are not a robot
                            }   
                        )   

        #Parse HTML content with BeautifulSoup to get total food 
        page_html_a = BeautifulSoup(response.text, "lxml")

        #Get food information
        if page_html_a.find('span',{'data-bind':"text: totalResult().format('n0')"}) is not None:

            #Find total stores
            total_food_a = page_html_a.find('span',{'data-bind':"text: totalResult().format('n0')"}).text
            total_food_a = str(total_food_a)
            total_food_a = total_food_a.replace(",", "")

            #Find number of page 
            no_of_pagedowns = math.ceil(int(total_food_a)/12)
            print("Total page: %1.0f" % (no_of_pagedowns))
            pages = [str(i) for i in range(1,no_of_pagedowns+1)]

            for page in pages:

                #Set parameters for looping within district, category and page
                parms = {'append'        : 'true',
                         'categoryId'    : '',  
                         'page'          : page,
                         'provinceId'    : '217',
                         'st'            : '2',         #Sort by most viewed
                         'vt'            : 'row',
                         'CategoryGroup' : 'food',      #Group 
                         'dtids'         : district,    #Districts
                         'c'             : category     #Categories 
                        }

                #Make a request 
                url = "https://www.foody.vn/ho-chi-minh/dia-diem?"
                response = get(url = url, \
                            params = parms, \
                            headers = { # Tell the admin that you are not a robot
                                        }
                                )
                print(response.request.url)

                #Parse HTML content with BeautifulSoup to get data
                page_html_b = BeautifulSoup(response.text, "lxml")

                #Find total stores
                #total_food_b = page_html_b.find('span', {'data-bind':"text: (totalResult()).format('n0')"}).text 
                #total_food_b = str(total_food_b)

                #print(total_food_b)
                #if total_food_b == '0':

                #    wait_command = int(input("Wait for command: (1) Continue, (0) Stop"))

                #    if wait_command == 1:

                #        continue

                #    elif wait_command == 0:

                #        exit

                #Find all food containers:
                food_containers = page_html_b.find_all("div",  class_ ="row-item filter-result-item")

                for food_container in food_containers:

                    #Food store name
                    name = food_container.h2.a.text.strip()
                    names.append(name)

                    #Address
                    address = food_container.find("div", class_ = "address").text.strip()
                    addresses.append(address)
 
                    #Score
                    if food_container.find("div", class_ = "point highlight-text") is not None:
                        score = food_container.find("div", class_ = "point highlight-text").text.strip()
                    else:
                        score = ''
                    scores.append(score)

                    #All stats
                    stat = food_container.find("div",  class_ = "stats").text.strip() 
                    stat = stat.replace("\n\n\n\n", "-")
                    stats.append(stat)

                    #Monitor the requests 
                    elapsed_time = time() - start_time
                    print("Elapsed time: %1.2f. Page %s/%1.0f: %s-%s, %s" % (elapsed_time, page, no_of_pagedowns, name, category_name, district_name))  

                #Pause the loop while looping through pages
                sleep(random.uniform(5,7))

        elif page_html_a.find('span',{'data-bind': "text: totalResult().format('n0')"}) is None:
            print("No food for this") 
        
            #Food store name
            name = ''
            names.append(name)

            #Address
            address = ''
            addresses.append(address)
 
            #Score
            score = ''
            scores.append(score)

            #All stats
            stat = ''
            stats.append(stat)

        #Store scraped data to an Excel file
        df1 = pd.DataFrame({'Name': names,
                            'Address': addresses,
                            'Score': scores,
                            'Stat': stats,
                            'category' : category_name
                            })

        #Create new excel file for first sheet
        if i == 1:
 
            writer = pd.ExcelWriter(os.path.join("DATARAW", 'foody_data_uncleaned.xlsx'), engine = 'openpyxl')
            df1.to_excel(writer \
                        , sheet_name = district_name + "-" + category_name \
                        , index = False)
            writer.save()
            writer.close() 

        #Append to the newly created excel file
        elif i != 1: 

            book = load_workbook(os.path.join("DATARAW", 'foody_data_uncleaned.xlsx'))
            writer = pd.ExcelWriter(os.path.join("DATARAW", 'foody_data_uncleaned.xlsx'), engine = 'openpyxl')
            writer.book = book  
            df1.to_excel(writer \
                        , sheet_name = district_name + "-" + category_name \
                        , index = False)
            writer.save()
            writer.close() 

        else:

            print("Something is wrong")

        i += 1

        #Pause the loop
        sleep(random.uniform(5,7))

    #Pause the loop
    sleep(random.uniform(5,6))

#Pause the loop
sleep(random.uniform(1,5))
 