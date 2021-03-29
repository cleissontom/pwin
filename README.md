# PWIN - Statistical Model for Sport

This project was created to development statistical model to estimate probability win for players and to calculate optimal allocation asset if you need to use this probability for own betting.

## main file explanation

### read_data_betfair.py
- converter file uploded by betfair website to formated file
- input file: file C:\\Users\\caval\\data_betfair_ods\\Oct
- output file: 'oct_2020.csv'
 -  columns name
    -  [id_bet, name_racing, local_racing, time_racing, number_runners, number_winners, id, name, trap, winner, last_odd, type_bet]

### collect_data.py.py
- script import class time_form_crawler
- crawler from url: https://www.timeform.com/greyhound-racing/results/2021-03-02
- output file: '2021-03-02.csv'
