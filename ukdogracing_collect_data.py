import pandas as pd
from bs4 import BeautifulSoup
import requests
import numpy as np
import sys
from datetime import date, timedelta
from itertools import chain


from database_manipulation import Database_Manipulation


db = Database_Manipulation()




qty_urls_to_crawler = 9999
schema_name = "GREYHOUND"
table_name = "RAW_RACING_INFORMATION"
sdate = date(2021, 2, 27)   # start date
edate = date(2021, 2, 28)   # end date



#####################################
# part 1
delta = edate - sdate       # as timedelta
all_dates_to_crawler = []
#list_all_urls = []

for i in range(delta.days + 1):
    day = sdate + timedelta(days=i)
    all_dates_to_crawler.append(day.strftime("%d-%m-%Y"))


headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}
for eachday in all_dates_to_crawler:
    url_all_racing = "https://www.ukdogracing.net/racecards/" + eachday
    page = requests.get(url_all_racing, headers=headers)
    print('\nurl crawing: ',url_all_racing)

    soup_all_racing = BeautifulSoup(page.content, 'html.parser')

    links_with_text = []
    for a in soup_all_racing.find_all('a', href=True):
        if a.text:
            links_with_text.append(a['href'])

    urls_to_crawler = np.unique([elem for elem in links_with_text if  'results/' + eachday in elem])
    #list_all_urls.append(urls_to_crawler)

    #list_all_urls = list(chain(*urls_to_crawler))

    ######################################
    # part 2
    i=0
    for url in urls_to_crawler:
        i=i+1
        full_url = "https://www.ukdogracing.net/" + url

        page = requests.get(full_url, headers=headers)
        soup = BeautifulSoup(page.content, 'html.parser')

        print('[',i,'/',len(urls_to_crawler),']',' url crawing:',full_url)

        time_and_local_race = soup.find('div',class_='ctleft').text

        time_race = time_and_local_race[0:5]
        local_race = time_and_local_race[6:9999]

        order_race_grade_distance = soup.find('div',class_='ctright').text

        index_separate1 = order_race_grade_distance.find(',')
        order_race = order_race_grade_distance[0:index_separate1]

        grade_distance = order_race_grade_distance[(index_separate1+2):9999]

        index_separate2 = grade_distance.find(' ')

        grade_race = grade_distance[0:index_separate2]
        distance_race = grade_distance[(index_separate2+1):9999]

        # print('order_race:',order_race)
        # print('grade_race:',grade_race)
        # print('distance_race:',distance_race)
        # print('time_race:',time_race)
        # print('local_race:',local_race)
        # print('date_race:',date_filter)
        # print('')


        #soup = BeautifulSoup(page.content, 'html.parser')

        table = soup.find('table', class_='racecard-table')
        rows = table.find_all('tr', class_='order-by-pos')

        data = []
        for row in rows:
            cols = row.find_all('td')
            cols = [ele.text.strip() for ele in cols]
            data.append(cols)

        for elem in data:

            elem0 = elem[0].split('\n')
            final_position = ''.join(filter(str.isdigit, elem0[0]))
            trap = elem0[1]

            elem2 = elem[2].split('\n')
            name_runner = elem2[0].replace('\'','')

            age_runner = elem[4]
            weight_runner = elem[5]
            bend = elem[6]

            split = ''.join(filter(str.isdigit, elem[8]))
            final_time = ''.join(filter(str.isdigit, elem[7]))

            if split == '':
                split = 'null'
            else:
                split = float(split) / 100.0

            if final_time == '':
                final_time = 'null'
            else:
                final_time = float(final_time) / 100.0

            str_odd = elem[9]
            index_space = str_odd.find(' ')
            index_bar = str_odd.find('/')
            digit_odd = ''.join(filter(str.isdigit, str_odd))

            if digit_odd != '':
                if index_space > 0:
                    return_odd = str_odd[0:index_bar]
                    cost_odd = str_odd[(index_bar + 1):index_space]
                    odd_price = float(float(return_odd) / float(cost_odd))
                else:
                    return_odd = str_odd[0:index_bar]
                    cost_odd = str_odd[(index_bar + 1):9999]
                    odd_price = float(float(return_odd) / float(cost_odd))
            else:
                odd_price = 0


            # print("####")
            # print('final position:',final_position)
            # print('trap:', trap)
            # print('name_runner:', name_runner)
            # print('age_runner:', age_runner)
            # print('weight_runner:', weight_runner)
            # print('bend:', bend)
            # print('final_time:', final_time)
            # print('split:', split)


            string_insert = """
            insert into {}.{} values ('{}','{}','{}','{}','{}','{}','{}',{},{},'{}',{},{},'{}',{},{},{})
            """.format(schema_name,table_name,eachday,time_race,local_race,order_race,grade_race,distance_race,full_url
                       ,trap,final_position,name_runner,age_runner,weight_runner,bend,final_time,split,odd_price)

            #print(string_insert)
            db.execute_string(string_insert)

