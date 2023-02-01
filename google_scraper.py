import pandas as pd
import datetime as dt
# import goslate
from pytrends.request import TrendReq
# from googletrans import Translator

def scrape(codes, terms, lang, time):
    # print(codes)
    # print(terms)
    # print(lang)
    # print(time)
    terms.sort()
    pytrends = TrendReq(hl='en-US', tz=360)
    # time = 'today 5-y'
    # print(time)

    # time = '2015-02-15 2020-02-15'

    # enter desired time in this section, will usually be 'today 5-y'
    # for the app
    # if lang != 'en': terms = trans(lang, terms)
    if lang != 'en': exit()
    ggl_complete = pd.DataFrame(columns = [] * len(terms) * 2)
    insufficient_data = 0
    for area in codes:
        search_count = 0
        while(len(terms) > search_count):
            try:
                pytrends.build_payload(kw_list= [terms[search_count]], timeframe = time, geo = area)
                ggl = pytrends.interest_over_time()
                ggl = ggl.drop(columns = 'isPartial')
                ggl_complete = pd.concat([ggl_complete, ggl], axis = 1)
                search_count += 1
            except Exception as ex:
                search_count += 1
                insufficient_data += 1
                print(ex)
                pass
    ggl_complete = ggl_complete.to_numpy()
    pd.DataFrame(ggl_complete).to_csv('ggl_complete.csv', index=False)
    pd.DataFrame([insufficient_data], columns=['incomplete_data']).to_csv('ggl_incomplete_data.csv', index=False)
    # pd.DataFrame(ggl_complete, columns=['dates']).to_csv('dates.csv', index=False)
    # print(ggl_complete)
    return [ggl_complete, insufficient_data]

def get_date(time):
    # time = '2015-02-15 2020-02-15'
    dates = []
    pytrends = TrendReq(hl='en-US', tz=360)
    pytrends.build_payload(kw_list= ['google'], timeframe = time, geo = 'US')
    data = pytrends.interest_over_time()
    indexes = data.index
    times = list(indexes.to_pydatetime())
    for i in range(0, len(times)):
        dates.append(times[i].strftime('%Y-%m-%d'))

    pd.DataFrame(dates, columns=['dates']).to_csv('dates.csv', index=False)
    return dates


# def trans(lang, terms):
#     # google trans code. Can use if the API gets fixed

#     # -----------------


#     # translator = Translator() # translate method
#     # # try:
#     # print(terms)
#     # print(lang)
#     # terms = translator.translate(terms, dest=lang) # tries to translates terms to desired language, will be an object
#     # # except Exception:
#     # print('translation not working')
#     # # return # returns NoneType if primary language of area is not supported by google translate (there are a few like this)
#     # count = 0 # count for list indexing
#     # for trans in terms:
#     #     terms[count] = trans.text # changes object to text
#     #     count += 1

#     gs = goslate.Goslate()
#     translations = []
#     for term in terms:
#         translations.append(gs.translate(term, lang))
#         time.sleep(1)
#     print(translations)

#     return translations # returns translated terms


# def get_range():
#     curr_week = dt.date.today().isocalendar()[1]
#     start_date = dt.datetime.strptime(f'2017-W{curr_week}-1', "%Y-W%W-%w")
#     start_date = str(start_date).split(" ")[0]
#     end_date = str(dt.date.today())
#     return start_date + ' ' + end_date

# file = scrape(['US-AL', 'US-AK', 'US-AZ', 'US-AR', 'US-CA', 'US-CO', 'US-CT', 'US-DE', 'US-DC', 'US-FL', 'US-GA', 'US-HI', 'US-ID', 'US-IL', 'US-IN', 'US-IA', 'US-KS', 'US-KY', 'US-LA', 'US-ME', 'US-MD', 'US-MA', 'US-MI', 'US-MN', 'US-MS', 'US-MO', 'US-MT', 'US-NE', 'US-NV', 'US-NH', 'US-NJ', 'US-NM', 'US-NY', 'US-NC', 'US-ND', 'US-OH', 'US-OK', 'US-OR', 'US-PA', 'US-RI', 'US-SC', 'US-SD', 'US-TN', 'US-TX', 'US-UT', 'US-VT', 'US-VA', 'US-WA', 'US-WV', 'US-WI', 'US-WY'], ['flu', 'cough', 'sore throat', 'tamiflu'], 'en');
# file = scrape(['US-CA', 'US-TX', 'US-NY'], ['flu', 'cough', 'sore throat', 'tamiflu'], 'en');
# file = scrape(['GR-A', 'GR-I', 'GR-G', 'GR-C', 'GR-F', 'GR-D', 'GR-B', 'GR-M', 'GR-L', 'GR-J', 'GR-H', 'GR-E', 'GR-K'], ['flu', 'cough', 'sore throat', 'tamiflu'], 'el');
# file = scrape(['GR'], ['flu', 'cough', 'sore throat', 'tamiflu'], 'el');
# print(file)
# print(get_date())
# print(dates)
# file.to_csv('test.csv');

# scrape(['US'], ['cough', 'flu', 'tamiflu', 'sore throat'], 'en', 'today 5-y')


import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--function',
        choices=['get_date', 'scrape'],
        required=False,
        type=str
    )
    parser.add_argument(
        '--get_date_time',
        type=str
    )
    parser.add_argument(
        '--codes',
        nargs='*',
        type=str,
    )
    parser.add_argument(
        '--terms',
        nargs='*',
        type=str
    )
    parser.add_argument(
        '--lang',
        default='en',
        type=str
    )
    parser.add_argument(
        '--scrape_time',
        type=str
    )
    args = parser.parse_args()
    
    function_name = args.function
    if function_name == 'get_date':
        time = args.get_date_time
        get_date(time)

    elif function_name == 'scrape':
        codes = args.codes
        terms = args.terms
        lang = args.lang
        time = args.scrape_time
        scrape(codes, terms, lang, time)

# terms = ['cough', 'flu', 'tamiflu', 'sore throat']
# code = ['US']
# 
