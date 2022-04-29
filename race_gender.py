import pandas as pd
import gender_guesser.detector as gender
from ethnicolr import pred_census_ln
# reading data
CASU_ = pd.read_csv("cleaned_data/CASU_2011-2020.csv")
GA = pd.read_csv("analysis_data/GT+ratings/GA_2018-2021.csv")
IL_ = pd.read_csv("cleaned_data/IL_2011-2021.csv", encoding='latin-1')
NC21 = pd.read_csv("cleaned_data/NC_2021.csv")
TN21 = pd.read_csv("cleaned_data/TN_2021.csv")


data = [CASU_, GA, IL_, NC21, TN21]#place desired datasets in this array

for x in data:

	final = pred_census_ln(x, 'Last Name').drop(columns=['white_mean','white_std','white_lb','white_ub',
		'black_mean','black_std','black_lb','black_ub',
		'api_mean','api_std','api_lb','api_ub',
		'hispanic_mean','hispanic_std','hispanic_lb','hispanic_ub'])
	final = final.rename(columns={'race':'Pred_Race'})


	d = gender.Detector()
	gender = []
	for person in x['First Name']:
		gender.append(d.get_gender(person))
	final = final.join(pd.Series(gender).rename('Pred_Gender'))
	final = final.drop(columns=['rowindex'])
	final.to_csv("data+rg/"+x['State'][0]+".csv")
