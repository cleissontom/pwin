import time
import pandas as pd
from time_form_crawler import Crawler_Site_TimeForm
from tqdm import tqdm
from visual_tools import Visual_Tools





timeform = Crawler_Site_TimeForm()
vt = Visual_Tools()


df_all_dates_to_crawler = pd.date_range(start="2021-04-01",end="2021-04-01")

for i in df_all_dates_to_crawler:
    date_crawler = str(i)[0:10]
    print('Date:',date_crawler)

    all_urls = timeform.all_urls_racing_by_date(date_crawler)

    df = pd.DataFrame()
    if len(all_urls) > 0:
        for i in vt.progressbar(range(0,len(all_urls)), date_crawler, 40):
            link = all_urls.iloc[i].values[0]
            df_results = timeform.table_results(link)
            df = pd.concat([df,df_results],ignore_index=True)
    else:
        print('There are not urls valid')

    df.to_csv(date_crawler+'.csv',index=False,sep='\t')




