
from bs4 import BeautifulSoup
import requests
import numpy as np


#
# first_url = "https://greyhoundbet.racingpost.com/#result-meeting"
#
# track_id = "69"
# date = "2021-04-02"
# r_time = "08:00"
#
#
# full_url = first_url + "/track_id=" + track_id + "&r_date=" + date + "&r_time=" + r_time
#
# print(full_url)
#
# len_data = 0
#
#
#
# headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}
# page = requests.get(full_url, headers=headers)
#
# print('url crawing: ',full_url)
#
# soup = BeautifulSoup(page.content, 'html.parser')
#
# table = soup.find("div", class_="layout-col2")
#
# all_divs = soup.find_all("div")
#
# soup.find("div").findChildren()
#
# soup.find_all("a", attrs={"class": "container"})
#
#
# for a in soup.find_all('a', href=True):
#     print ("Found the URL:", a['href'])
#     print(a)
#
#
# soup.find_all(href=True)
#
#
#
# soup = BeautifulSoup(page.content, 'html.parser')
# links_with_text = []
# for a in soup.find_all('a', href=True):
#     if a.text:
#         links_with_text.append(a['href'])
#
# soup.find("div", {"class": "resultsList"})
#
#
#
# import urllib.request, urllib.error, urllib.parse
#
#
# response = urllib.request.urlopen(full_url)
# webContent = response.read()
#
#
#
#
# ########################
# full_url = "https://greyhoundbet.racingpost.com/#results-list/r_date=2021-04-03"
#
# headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}
# page = requests.get(full_url, headers=headers)
#
#
# soup = BeautifulSoup(page.content, 'html.parser')
#
#
#
#
# url = "https://greyhoundbet.racingpost.com/#results-list/r_date=2021-04-03/json"
# r = requests.get(url)
# print(r.text)
#
#
#
#
#
#
#
#
#
#
#
#
#
# from webdriver_manager.chrome import ChromeDriverManager
# import time
# from bs4 import BeautifulSoup
# from selenium import webdriver
#
# chromedriver_path= "/Users/.../chromedriver"
#
# #driver = webdriver.Chrome(chromedriver_path)
# driver = webdriver.Chrome(ChromeDriverManager().install())
#
#
# url = "https://greyhoundbet.racingpost.com/#results-list/r_date=2021-04-03"
# driver.get(url)
# time.sleep(3) #if you want to wait 3 seconds for the page to load
# page_source = driver.page_source
#
# soup = bs4.BeautifulSoup(page_source, 'lxml')
#
#
#
#
#
#
#
#
#
#
#
#
#
# ###################################
# import requests
# from bs4 import BeautifulSoup
#
#
#
#
# url = "https://greyhoundstats.co.uk/graded_greyhound_stats.php"
#
# response = requests.get(url, headers=headers)
#
# print(response.text)
#
#
#
#
# soup = BeautifulSoup(response.content, features="lxml")
#
#
#
# links_with_text = []
# for a in soup.find_all('a', href=True):
#     if a.text:
#         links_with_text.append(a['href'])
#
#
#
#
#
# my_all = soup.find_all("span", {"class": "a-size-medium a-color-base a-text-normal"})
#
# print(my_all)



data

#####################################
# part 1
date_filter = "02-03-2021"
full_url2 = "https://www.ukdogracing.net/racecards/" + date_filter
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}
page = requests.get(full_url2, headers=headers)
print('url crawing: ',full_url2)

soup = BeautifulSoup(page.content, 'html.parser')

links_with_text = []
for a in soup.find_all('a', href=True):
    if a.text:
        links_with_text.append(a['href'])

urls_to_crawler = np.unique([elem for elem in links_with_text if  'results/' + date_filter in elem])

#########################################
# part 2
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}


data = []
for url in urls_to_crawler[0:1]:
    full_url = "https://www.ukdogracing.net/" + url
    page = requests.get(full_url, headers=headers)
    print('url crawing: ',full_url)

    soup = BeautifulSoup(page.content, 'html.parser')

    table = soup.find('table', class_='racecard-table')
    rows = table.find_all('tr', class_='order-by-pos')

    for row in rows:
        cols = row.find_all('td')
        cols = [ele.text.strip() for ele in cols]
        data.append(cols)



    time_and_local_race = soup.find('div',class_='ctleft').text

    time_race = time_and_local_race[0:5]
    local_race = time_and_local_race[6:9999]

    print(time_race)
    print(local_race)
    order_race_grade_distance = soup.find('div',class_='ctright').text

    index_separate1 = order_race_grade_distance.find(',')
    order_race = order_race_grade_distance[0:index_separate1]


    grade_distance = order_race_grade_distance[(index_separate1+2):9999]

    index_separate2 = grade_distance.find(' ')

    grade_race = grade_distance[0:index_separate2]
    distance_race = grade_distance[(index_separate2+1):9999]

    print(order_race)
    print(grade_race)
    print(distance_race)


