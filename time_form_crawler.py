from bs4 import BeautifulSoup
import re
import requests
import pandas as pd
import numpy as np


class Crawler_Site_TimeForm:

    def __init__(self):
        self._headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}



    def table_results(self,URL):

        len_data = 0

        page = requests.get(URL, headers=self._headers)

        # Parsing
        soup = BeautifulSoup(page.content, 'html.parser')

        # collect information greyhounds (table)
        # ======================================
        print('url crawing: ',URL)
        table = soup.find('tbody', class_='rrb')
        rows = table.find_all('tr', class_='rrb-runner-details')

        has_image = 0
        data = []
        for row in rows:
            cols = row.find_all('td')
            cols = [ele.text.strip() for ele in cols]
            if has_image % 2 == 0:  # Only even rows has image
                trap = row.find('img').get('alt')
                cols.append(trap)
            data.append([ele for ele in cols if ele])  # Get rid of empty values
            has_image += 1

        col = ['Pos', 'Btn', 'Greyhound', 'Age', 'Bend', 'Comments',
               'Comments2', 'ISP', 'TFR', 'Trap', 'Official_Time', 'Trainer', 'BSP']
        col = [c.lower() for c in col]

        df = pd.DataFrame(columns=col)

        #print(data)
        for i in range(0,12,2):

            if len(data[i:i+2])==0:
                continue

            db_values = np.concatenate(data[i:i + 2])
            #db_values = np.concatenate(elem[0])
            #print(db_values)
            db = dict(zip(col, db_values))
            len_data = len(db)
            try:
                db['official_time'], db['split'] = db['official_time'].split(' ')
                db['split'] = db['split'].replace('(', '').replace(')', '')
            except:
                db['split'] = 0

            df = df.append(db, ignore_index=True)

        df = df.drop('comments2', axis=1)



        #print('error link:', URL)
        #empty_df_cols = col + ['distance','local','time','grade','day','month','year','id_racing']
        #return (pd.DataFrame(columns=empty_df_cols))

        # collect information about time and local racing
        # ======================================
        table2 = soup.find('section', class_="rp-header rr-header w-container rp-container")
        rows2 = table2.find_all('h1', class_='w-header')

        paragraphs = []
        for x in rows2:
            paragraphs.append(str(x))
        time_local_regex = re.search("\\r\\n(.*)\\r\\n ", paragraphs[0])
        time_local = time_local_regex.group(1).strip()
        time_racing = time_local[0:5]
        local_racing = time_local[6:999]

        # collect information about racing
        # ======================================
        table3 = soup.find('section', class_="rp-header rr-header w-container rp-container")
        rows3 = table3.find_all('div', class_="rph-race-details-col")

        data = []
        for x in rows3:
            rows4 = x.find_all('b')
            cols = [ele.text.strip() for ele in rows4]
            data.append([ele for ele in cols if ele])  # Get rid of empty values

        day_racing = data[0][0].split(' ')[3]
        month_racing = data[0][0].split(' ')[4]
        year_racing = data[0][0].split(' ')[5]
        grade_racing = data[2][0].replace('(', '').replace(')', '')
        distance_racing = data[2][1]

        # collect information about id racing
        split_url = URL.split('results/')
        id_racing = split_url[len(split_url)-1]

        # add final information
        # ================================
        df['distance'] = distance_racing
        df['local'] = local_racing
        df['time'] = time_racing
        df['grade'] = grade_racing
        df['day'] = day_racing
        df['month'] = month_racing
        df['year'] = year_racing
        df['id_racing'] = id_racing

        #print(len_data)
        if len_data > 12:
            return df
        else:
            return(pd.DataFrame(columns=df.columns))

    def all_urls_racing_by_date(self,date):

        pre_url = 'https://www.timeform.com/'

        full_url = 'https://www.timeform.com/greyhound-racing/results/'+str(date)
        page = requests.get(full_url, headers=self._headers)
        soup = BeautifulSoup(page.content, 'html.parser')


        # collect all links about racing
        # ======================================
        table = soup.find('section', class_='w-archive-full')
        rows = table.find_all('a', class_='waf-header hover-opacity')

        data = []
        for x in rows:
            data.append(x.get('href'))

        data = [pre_url + s for s in data]

        return(pd.DataFrame({'links':data}))
