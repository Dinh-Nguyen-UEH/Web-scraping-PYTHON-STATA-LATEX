1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91
92
93
94
95
96
97
98
99
100
101
102
103
104
105
106
107
108
109
110
111
112
113
114
115
116
117
118
119
120
121
122
123
124
125
126
127
128
129
130
131
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
        #Thăm quan & chụp ảnh:-7
        #Billiadrds:-----------8
        #Tiệc cưới/hội nghị:---9
        #Shop/cửa hàng:-------10
        #Ăn vặt/ vỉa hè:------11
        #Sang trọng:----------12
        #Giao cơm văn phòng:--28
        #Buffet:--------------39
        #Beer club:-----------43
        #Tiệc tận nơi:--------44
        #Khu ẩm thực:---------79
 
import os
 
from requests import get
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
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
 
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

#Set working directory
os.chdir('D:/Dropbox (Vo Tat Thang)/[0][Master]Database/(3)Library_of_Project/(99)Mics/(13)Web-scraping') # Provide the path here 
 
#List to store scrapped data
names = []
comments = []
scores = []
pictures = []
votes = []
saves = []
 
addresses = []
districts = []
cities = []
 
#Loop monitoring
start_time = time()
requests = 0
 
#Set parameters
parms = {'append': 'true',
        'categoryId': '',  
        'page': '',
        'provinceId': '217',
        'st': '1',
        'vt': 'row',
        'CategoryGroup': 'food',     #Group 
        'dtids'         : '15', #Districts
        'c'             : '2'         #Categories 
        }
 
#Make a request 
url = "https://www.foody.vn/ho-chi-minh/dia-diem?"
t_0 = time()
response = get(url = url, \
               params = parms, \
               headers = {"User-Agent": "My web scraping program. Contact me at Dinh.Nguyen.UEH@outlook.com" # Tell the admin that you are not a robot
                        }
                )
print(response.request.url)
print (response)
 
#Parse HTML content with BeautifulSoup to get total food 
page_html_a = BeautifulSoup(response.text, "html.parser")
 
#Scroll down all pages to get all data
 
xpaths = {"scroll_down"  : "//*[@id='scrollLoadingPage']/a"
         }
  
#Get total food
total_food = page_html_a.find('span',{'data-bind':"text: totalResult().format('n0')"}).text
total_food = str(total_food)
total_food = total_food.replace(",", "")
 
#Number of page down 
no_of_pagedowns = math.ceil(int(total_food)/12)
print(no_of_pagedowns)
 
#Open browser first time 
edge_driver = webdriver.Edge(os.path.join("DATADOC", 'MicrosoftWebDriver.exe'))

edge_driver.get(url = response.request.url) 

while no_of_pagedowns:
    #Click scroll down
    edge_driver.find_element_by_xpath(xpaths['scroll_down']).click()
    #Wait before download
    sleep(random.uniform(1,1.5)) 
    no_of_pagedowns -= 1
 
#Parse HTML content with BeautifulSoup after scrolling to get all data
page_html_b = edge_driver.page_source
page_html_b = BeautifulSoup(response.text, "html.parser")
  