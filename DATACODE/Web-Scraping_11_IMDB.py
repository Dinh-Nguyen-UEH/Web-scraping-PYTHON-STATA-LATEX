#Step 1: Identify the URL structure
#Page 1: http://www.imdb.com/search/title?release_date=2017-01-01,2017-12-31&count=250&view=advanced
#Page 2: http://www.imdb.com/search/title?release_date=2017-01-01,2017-12-31&count=250&view=advanced&page=2&ref_=adv_nxt
  
import os

from requests import get
from bs4 import BeautifulSoup
 
import time
from time import time
from time import sleep

from random import randint
import random as random

from warnings import warn
from IPython.core.display import clear_output

import re
import pandas as pd

#Set working directory
os.chdir('D:/Dropbox (Vo Tat Thang)/[0][Master]Database/(3)Library_of_Project/(99)Mics/(13)Web-scraping') # Provide the path here 

#List to store scrapped data
names = []
years = []
imdb_ratings = []
meta_ratings = []
votes = []
certificates = []
runtimes = []
genres = []
directors = []
star_1s = []
star_2s = []
star_3s = []
star_4s = []
grosses = []

#Loop monitoring
start_time = time()
requests = 0

#Define loop length
pages = [str(i) for i in range(1,6)]
years_url = [str(i) for i in range(2000,2018)] 

#For every year in the defined interval
for year_url in years_url:

    #For every page in the defined interval
    for page in pages:

        #Make a request 
        url = "http://www.imdb.com/search/title?release_date=" \
                   + year_url + "-01-01," \
                   + year_url + "-12-31&count=250&view=advanced&page=" \
                   + page + "&ref_=adv_nxt"
        print (url)
        t_0 = time()
        response = get(url, headers = {"Accept-Language": "en-US,en;q=0.5", #Define page language 
                                       "User-Agent": "My web scraping program. Contact me at Dinh.Nguyen.UEH@outlook.com" # Tell the admin that you are not a robot
                                      }
                      )

        #Pause the loop
        sleep(random.uniform(5,10))

        #Back off if server slows down
        #response_delay = time() - t_0
        #sleep(10*response_delay)  # wait 10x longer than it took them to respond

        #Monitor the requests
        requests += 1
        elapsed_time = time() - start_time
        print('Request: {}; Frequency: {} requests/s; Elapsed time: {}'.format(requests, requests/elapsed_time,elapsed_time))
        clear_output(wait = True)

        #Show warning for non-200 status codes
        if response.status_code != 200:
            warn("Request: {}; Status code: {}".format(requests,response.status_code))
        #Break the loop if the number of requests is greater than expected
        #if requests > 72:
        #    warn("Number of requests was greater than expected.")
        #    break

        #Parse HTML content with BeautifulSoup
        page_html = BeautifulSoup(response.text, "html.parser")
        
        #Select all 250 movies containers from a single page 
        movie_containers = page_html.find_all("div", class_ = "lister-item mode-advanced")

        #For every movie of these 250
        for container in movie_containers: 

            #The movie name:
            name = container.h3.a.text
            names.append(str(name))

            #The year
            year = container.h3.find('span', class_ = "lister-item-year").text
            years.append(year)

            #The IMDB rating
            if container.strong is not None:
                imdb_rating = container.strong.text
            else:
                imdb_rating = ''
            imdb_ratings.append(str(imdb_rating))

            #The Metascore
            if container.find("div", class_ = "ratings-metascore") is not None:
                meta_rating = container.find("span", class_ = "metascore").text
            else:
                meta_rating = ''
            meta_ratings.append(str(meta_rating))

            #The number of votes
            if container.find("span", attrs = {"name":"nv"}) is not None:
                vote = container.find("span", attrs = {"name":"nv"})["data-value"]
            else:
                vote = ''
            votes.append(str(vote))

            #Set up new container for additional information
            container_2nd = container.find("p", class_ = "text-muted ")
                
            #The certificate 
            if container_2nd.find("span", class_ = "certificate") is not None:
                certificate = container_2nd.find("span", class_ = "certificate").text
            else:
                certificate = ''
            certificates.append(str(certificate)) 
     
            #The run-time 
            if container_2nd.find("span", class_ = "runtime") is not None:
                runtime = container_2nd.find("span", class_ = "runtime").text
            else:
                runtime = ''
            runtimes.append(str(runtime)) 

            #The genre 
            if container_2nd.find("span", class_ = "genre") is not None:
                genre = container_2nd.find("span", class_ = "genre").text
            else:
                genre = ''
            genres.append(str(genre))  

            #The director
            if container.find("a", href = re.compile('/?ref_=adv_li_dr_0')) is not None:
                director = container.find("a", href = re.compile('/?ref_=adv_li_dr_0')).text
            else:
                director = ''
            directors.append(str(director))  

            #The actor/actress 1 
            if container.find("a", href = re.compile('/?ref_=adv_li_st_0')) is not None:
                star_1  = container.find("a", href = re.compile('/?ref_=adv_li_st_0')).text
            else:
                star_1 = ''
            star_1s.append(str(star_1))  

            #The actor/actress 2 
            if container.find("a", href = re.compile('/?ref_=adv_li_st_1')) is not None:
                star_2  = container.find("a", href = re.compile('/?ref_=adv_li_st_1')).text
            else:
                star_2 = ''
            star_2s.append(str(star_2))  

            #The actor/actress 3 
            if container.find("a", href = re.compile('/?ref_=adv_li_st_2')) is not None:
                star_3  = container.find("a", href = re.compile('/?ref_=adv_li_st_2')).text
            else:
                star_3 = ''
            star_3s.append(str(star_3))  

            #The actor/actress 4 
            if container.find("a", href = re.compile('/?ref_=adv_li_st_3')) is not None:
                star_4  = container.find("a", href = re.compile('/?ref_=adv_li_st_3')).text
            else:
                star_4 = ''
            star_4s.append(str(star_4))  

            #The gross 
            try:
                gross = container.findAll("span", attrs = {"name":"nv"})[1] 
                gross = gross["data-value"] 
            except IndexError:
                gross = '' 
            grosses.append(str(gross))  

            print(name,year)

#Check collected data with Pandes
movie_data = pd.DataFrame({'Movie': names,
                           'Year': years,
                           'Imdb': imdb_ratings,
                           'Metascore': meta_ratings,
                           'Votes': votes,
                           'Runtime': runtimes,
                           'Genre': genres,
                           'Director': directors,
                           'Star 1': star_1s,
                           'Star 2': star_2s,
                           'Star 3': star_3s,
                           'Star 4': star_4s,
                           'Gross': grosses,
                           'Certificates': certificates,
                           })
print(movie_data.info()) 
     
#Reordering columns:
#movie_data = movie_data[["movie", "year", "imdb", "metascore", "votes"]]
 
writer = pd.ExcelWriter(os.path.join("DATARAW", 'movie_data_uncleaned.xlsx'))
movie_data.to_excel(writer,'Sheet1')
writer.save()


   