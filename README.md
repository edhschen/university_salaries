# prof-pay

README is organized into directory structure, execution, and then script description

## Directory Structure

### Folders:

* `data`:
	this folder contains our raw data directly from the osurce website or our raw file generated from collecting it.
		
* `cleaned_data`:
	this folder contains our data once we had conformed them all to the same columns and titles
	All data in this folder is in the format:
	State, Year, First Name, Last Name, Institution, Department, Title, Salary

* `data+rg`:
	this folder contains our data after we performed our race and gender predictions. This is the output of race_gender.py run on 'cleaned_data'

* `analysis_data`:
	This folder contains our data after we had partitioned it into our generalize roles: Faculty, Lecturer, Instructor, Professor 
	it also contains our generealized divsion for professor: Professor, Associate Professor, Assistant Professor
	Each folder withing this one contains the data partitioned as described above for the state in the folders name.
	Within these folders each csv file is labeled accordingly and professor_generalized files contain the professor data with the titles consolidated to our three

* `final_partitioned`:
	This folder is the output of `finalmerge.r` and contains the final level of cleaned data with a file for each of our datasets.
	Files ending in "_i" indicate that they are for intersectional analysis and that their race and gender columns have been combined.
	This is the data used by `reg.r`

* `model_coef`
	This folder contains files of the coefficient names, values and significance levels for the linear model for each of the data sets in final_partitioned

* `model_results`
	This folder contains the regression performance results of all of the models created in `reg.r` 
	This is what was used to determine the best model for each data set

* `prediction_testing`
	* `prediction_tester.py`
	
		This code consolidates the race and gender columns in the TX dataset to match the output of our race and gender predictions and then creates and
		outputs the confusion matrix for gender, for gender where mostly male and mostly female have been merged into the corresponding male or female
		category, and then a confusion matrix for race where all race not in the output of our model but in the TX dataset have been consolidated into
		one "other" category 

		You run this file by running the following command in the prediction testing directory:
			`python prediction_tester.py`
	* `TX.csv`		
		This file is the output of running `race_gender.py` on the TX_2021.csv data in cleaned_data
	* `TX_filtered.csv`
		This is the output of `prediction_tester.py` which includes actual race and gender consolidated to the appropriate categories, and the predictions
* `ratings`
	* `rating_normalization`
		This contains the normalization files for ratings, primarily in a notebook
	This folder contains the scraping regiment for gathering ratings data
* `ratings_data`
	* This folder contains the ratings data resulting from the scraping. Named by table, and also a sql format.

## Execution

Needed Packages:
Python:
```
	Pandas
	gender_guesser
	ethnicolr
	matplotlib
	numpy
	sklearn
	seaborn
```

Install:
```
	python -m pip install -U pip

	pip install pandas
	pip install gender-guesser
	pip install ethnicolr
	python -m pip install -U matplotlib
	pip install numpy
	pip install -U scikit-learn
	pip install seaborn
```

R:
```
	MASS
	e1071
	caret
	neuralnet
	glmnet
	mltools
	data.table
	janitor
	corrplot
	dplyr
	jtools
	crs
	earth
```

R scripts should install necessary packages

## Scripts:
R:
* `finalmerge.r`

	This file takes the partitioned data from analysis_data and performs one final cleaning removing the appropriate columns and merging the
	approppriate state files into the final csv files to be used in regression, and also creates the intersectional daata files by merging 
	the race and gender columns. The output of this file is stored in the final_partitioned folder
	You run this file by opening it in RStudio, clicking the "Code" tab and Clicking "Source"
* `reg.r`

	This script partitioned the data into test and training data and creates 3-4 models trained on the training partion for each data set, 
	and stores the performance of each model on the test set into the model_results folder
	You run this file by opening it in RStudio, clicking the "Code" tab and Clicking "Source"
* `bestmodels.r`

	This script takes teh data output by `finalmerge.r` and creates what was evaluated to be the best model for each datset and trains it on 
	all the data and then stores the summary output including names, coefficients, and p-value of each model into the model_coef folder.
	You run this file by opening it in RStudio, clicking the "Code" tab and Clicking "Source"

Python:
* `datacleaning.py`

	this file is used to clean the raw data and consolidate down to the appropriately names rows. The output of this file is in the cleaned_data folder
	You run this file by running the following command in the main directory:
		`python datacleaning.py`

* `race_gender.py`

	This file is used to predict the gender and race based off of the first name and last name columns from the cleaned_data folder, respectively. 
	The output of this file goes to the data+rg folder
	You run this dile by runnig the follwoing command in the main directory:
		`python race_gender.py`
