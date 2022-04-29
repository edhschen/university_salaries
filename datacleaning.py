import pandas as pd

# reading data
CASU11 = pd.read_csv("data/CASU-2011.csv")
CASU12 = pd.read_csv("data/CASU-2012.csv")
CASU13 = pd.read_csv("data/CASU-2013.csv")
CASU14 = pd.read_csv("data/CASU-2014.csv")
CASU15 = pd.read_csv("data/CASU-2015.csv")
CASU16 = pd.read_csv("data/CASU-2016.csv")
CASU17 = pd.read_csv("data/CASU-2017.csv")
CASU18 = pd.read_csv("data/CASU-2018.csv")
CASU19 = pd.read_csv("data/CASU-2019.csv")
CASU20 = pd.read_csv("data/CASU-2020.csv")

CASU = [CASU11, CASU12, CASU13, CASU14, CASU15, CASU16, CASU17, CASU18, CASU19, CASU20]


index=0
last = []
for CA1 in CASU:
	# CA1 = CA1[CA1['Base Pay'] > 0] #remove non-positive salaries
	CA1 = CA1.join(CA1['Employee Name'].str.split(expand=True)[0])
	temp = CA1['Employee Name'].str.split(expand=True).drop(columns=[0])
	for i, col in temp.iterrows():
		if col.iloc[0] == None: # only first name
			last.append("")
			j = 0
		elif len(col.iloc[0]) == 1: # yes middle initial
			j = 2
			if (col.iloc[1] != None):
				last.append(col.iloc[1])
			else:
				last.append("")
		else: #no middle initial
			j = 1
			last.append(col.iloc[0])

		while(j<len(col) and col.iloc[j] != None):
			last[i] += " "+col.iloc[j]
			j+=1
	CA1=CA1.join(pd.Series(last).rename('Last Name'))
	CA1 = CA1.drop(columns=['Overtime Pay','Other Pay', 'Benefits', 'Total Pay', 'Notes', 'Status', 'Total Pay & Benefits', 'Employee Name'])
	CA1 = CA1.rename(columns={'Job Title':'Title', 'Base Pay': 'Salary', 'Agency':'Institution', 0:'First Name'})
	CA1["Department"]=None
	CA1["State"]="CA"
	CA1 = CA1[["State","Year","First Name","Last Name","Institution","Department","Title","Salary"]]
	CASU[index] = CA1
	index = index + 1

CASUfinal = pd.concat(CASU)
CASUfinal.to_csv("cleaned_data/CASU_2011-2020.csv")

###########################################################################################

IL11 = pd.read_csv("data/IL-2011.csv")
IL12 = pd.read_csv("data/IL-2012.csv")
IL13 = pd.read_csv("data/IL-2013.csv")
IL14 = pd.read_csv("data/IL-2014.csv")
IL15 = pd.read_csv("data/IL-2015.csv")
IL16 = pd.read_csv("data/IL-2016.csv")
IL17 = pd.read_csv("data/IL-2017.csv")
IL18 = pd.read_csv("data/IL-2018.csv")
IL19 = pd.read_csv("data/IL-2019.csv")
IL20 = pd.read_csv("data/IL-2020.csv")
IL21 = pd.read_csv("data/IL-2021.csv")

IL = [IL11, IL12, IL13, IL14, IL15, IL16, IL17, IL18, IL19, IL20, IL21]

index=0
last = []
for IL1 in IL:
	IL1 = IL1.join(IL1['Name'].str.split(expand=True)[0])
	temp = IL1['Name'].str.split(expand=True).drop(columns=[0])
	for i, col in temp.iterrows():
		if col.iloc[0] == None: # only first name
			last.append("")
			j = 0
		elif col.iloc[0].find(".") != -1: # yes middle initial
			j = 2
			if (col.iloc[1] != None):
				last.append(col.iloc[1])
			else:
				last.append("")
		else: #no middle initial
			j = 1
			last.append(col.iloc[0])

		while(j<len(col) and col.iloc[j] != None):
			last[i] += " "+col.iloc[j]
			j+=1
	IL1=IL1.join(pd.Series(last).rename('Last Name'))
	IL1 = IL1.drop(columns=['Additional Compensation', 'Position', 'Name'])
	IL1 = IL1.rename(columns={'Base Salary': 'Salary', 'Institution/System Office':'Institution', 0:'First Name'})
	IL1["Department"]=None
	IL1["State"]="IL"
	IL1["Year"] = 2011 + index
	IL1 = IL1[["State","Year","First Name","Last Name","Institution","Department","Title","Salary"]]
	IL[index] = IL1
	index = index + 1

ILfinal = pd.concat(IL)
ILfinal.to_csv("cleaned_data/IL_2011-2021.csv")
###########################################################################################

NC21 = pd.read_csv("data/NC-2021.csv")
NC21 = NC21.drop(columns=['INITIAL HIRE DATE', 'INIT', 'AGE', 'JOB CATEGORY'])
NC21 = NC21.rename(columns={'FIRST NAME': 'First Name', 'LAST NAME':'Last Name', 'INSTITUTION NAME':'Institution', 'EMPLOYEE ANNUAL BASE SALARY':'Salary', 'EMPLOYEE HOME DEPARTMENT': 'Department',"PRIMARY WORKING TITLE":'Title'})
NC21["State"]="NC"
NC21["Year"] = 2021
NC21 = NC21[["State","Year","First Name","Last Name","Institution","Department","Title","Salary"]]

NC21.to_csv("cleaned_data/NC_2021.csv")
###########################################################################################

TN21 = pd.read_csv("data/TN-2021.csv")

TN21 = TN21.drop(columns=['web-scraper-order', 'web-scraper-start-url', 'FTE', 'pages', 'pages-href'])
TN21 = TN21.rename(columns={'Job Title': 'Title'})
TN21["State"]="TN"
TN21["Year"] = 2021
TN21 = TN21[["State","Year","First Name","Last Name","Institution","Department","Title","Salary"]]

TN21.to_csv("cleaned_data/TN_2021.csv")
###########################################################################################

TX21 = pd.read_csv("data/TX-2021.csv")

last =[]
TX21 = TX21.join(TX21['full_name'].str.split(expand=True)[0])
temp = TX21['full_name'].str.split(expand=True).drop(columns=[0])
for i, col in temp.iterrows():
	if col.iloc[0] == None: # only first name
		last.append("")
		j = 0
	elif len(col.iloc[0]) == 1: # yes middle initial
		j = 2
		if (col.iloc[1] != None):
			last.append(col.iloc[1])
		else:
			last.append("")
	else: #no middle initial
		j = 1
		last.append(col.iloc[0])

	while(j<len(col) and col.iloc[j] != None):
		last[i] += " "+col.iloc[j]
		j+=1
TX21=TX21.join(pd.Series(last).rename('Last Name'))
TX21 = TX21.drop(columns=['employment_time', 'hire_date', 'id', 'data_date'])
TX21 = TX21.rename(columns={'agency': 'Institution', 'job_title':'Title', 'department':'Department', 0:'First Name', 'salary':'Salary', 'race':'Race', 'gender':'Gender'})
TX21["State"]="TX"
TX21["Year"] = 2021
TX21 = TX21[["State","Year","First Name","Last Name","Institution","Department","Title","Salary","Race","Gender"]]

TX21.to_csv("cleaned_data/TX_2021.csv")

###########################################################################################

GA18 = pd.read_csv("analysis_data/GT+ratings/GA2018.csv")
GA19 = pd.read_csv("analysis_data/GT+ratings/GA2019.csv")
GA20 = pd.read_csv("analysis_data/GT+ratings/GA2020.csv")
GA21 = pd.read_csv("analysis_data/GT+ratings/GA2021.csv")

GA = [GA18, GA19, GA20, GA21]

index=0
last = []
for GA1 in GA:
	GA1 = GA1.drop(columns=['Travel', 'Name'])
	GA1 = GA1.rename(columns={'Organization': 'Institution', 'FiscalYear':'Year'})
	GA1["Department"]=None
	GA1["State"]="GA"
	GA1 = GA1[["State","Year","First Name","Last Name","Institution","Department","Title","Salary", "Rating"]]
	GA[index] = GA1
	index = index + 1

GAfinal = pd.concat(GA)
GAfinal.to_csv("analysis_data/GT+ratings/GA_2018-2021.csv")


