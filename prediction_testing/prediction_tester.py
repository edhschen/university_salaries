import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
TX = pd.read_csv("prediction_testing/TX.csv")
from sklearn.metrics import confusion_matrix


TX.drop(TX[TX['Race'] == 'Declined to Specify'].index, inplace = True)
TX.drop(TX[TX['Race'] == 'Unknown'].index, inplace = True)
TX.drop(TX[TX['Race'] == 'Not Provided'].index, inplace = True)
TX.drop(TX[TX['Race'] == 'Not Specified'].index, inplace = True)
TX.drop(TX[TX['Race'] == 'Not Hispanic'].index, inplace = True)
TX.drop(TX[TX['Race'] == 'NSPEC'].index, inplace = True)
TX.drop(TX[TX['Race'] == 'Not Available'].index, inplace = True)

TX['Gender'] = TX['Gender'].replace(['Male'], 'male')
TX['Gender'] = TX['Gender'].replace(['Female'], 'female')

TX['Race'] = TX['Race'].replace(['White'], 'white')
TX['Race'] = TX['Race'].replace(['WHITE'], 'white')
TX['Race'] = TX['Race'].replace(['Asian'], 'api')
TX['Race'] = TX['Race'].replace(['Asian '], 'api')
TX['Race'] = TX['Race'].replace(['ASIAN'], 'api')
TX['Race'] = TX['Race'].replace(['Black or African American'], 'black')
TX['Race'] = TX['Race'].replace(['BLACK OR AFRICAN AMERICAN'], 'black')
TX['Race'] = TX['Race'].replace(['Hispanic or Latino'], 'hispanic')
TX['Race'] = TX['Race'].replace(['Native Hawaiian or Other Pacific Islander'], 'api')
TX['Race'] = TX['Race'].replace(['Black/African American'], 'black')
TX['Race'] = TX['Race'].replace(['Hispanic'], 'hispanic')
TX['Race'] = TX['Race'].replace(['Native Hawaiian/Other Pacific Islander'], 'api')
TX['Race'] = TX['Race'].replace(['NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER'], 'api')
TX['Race'] = TX['Race'].replace(['AFRAM'], 'black')
TX['Race'] = TX['Race'].replace(['Hispanic/Latino'], 'hispanic')
TX['Race'] = TX['Race'].replace(['Pacific Islander'], 'api')
TX['Race'] = TX['Race'].replace(['Black'], 'black')
TX['Race'] = TX['Race'].replace(['Hispanic or Latino of any race'], 'hispanic')
TX['Race'] = TX['Race'].replace(['Pacific'], 'api')
TX['Race'] = TX['Race'].replace('Black ', 'black')
TX['Race'] = TX['Race'].replace(['Asian'], 'api')
TX['Race'] = TX['Race'].replace(['Pacific Islander,'], 'api')
TX['Race'] = TX['Race'].replace(['Pacific Islander, '], 'api')
TX['Race'] = TX['Race'].replace(['Native Hawaiian or Other Pacific'], 'api')

TX['Race'] = TX['Race'].replace(['American Indian or Alaska Native',
'American Indian or Alaskan Native',
'AMERICAN INDIAN OR ALASKA NATIVE',
'American Indian, ',
'American Indian, Asian, Pacific Islander, White',
'American Indian, Asian, White',
'American Indian, Black, ',
'American Indian, Black, White',
'American Indian, White',
'American Indian/Alaska Native',
'American Indian/Alaskan Native',
'AMIND',
'Asian, Black, ',
'Asian, White',
'Black, White',
'Multiple',
'Two or More Races',
'Two or more races',
'American Indian, Asian, Black, Pacific Islander, White'
], 'other')



TX.to_csv("prediction_testing/TX_filtered.csv")

print(confusion_matrix(TX['Pred_Race'], TX['Race'], labels=['white', 'hispanic', 'api', 'black', 'other']))
cm_race = confusion_matrix(TX['Pred_Race'], TX['Race'], labels=['white', 'hispanic', 'api', 'black', 'other'])
ax = sns.heatmap(cm_race/np.sum(cm_race), annot=True, 
            fmt='.2%', cmap='Blues')
ax.set_title('Predicted Race Confusion Matrix\n');
ax.set_xlabel('\nActual Race')
ax.set_ylabel('Predicted Race');

ax.xaxis.set_ticklabels(['white', 'hispanic', 'api', 'black', 'other'])
ax.yaxis.set_ticklabels(['white', 'hispanic', 'api', 'black', 'other'], rotation=0)

plt.show()

print(confusion_matrix(TX['Pred_Gender'], TX['Gender'], labels=['male', 'female', 'mostly_male', 'mostly_female', 'andy', 'unknown']))
cm_gender = confusion_matrix(TX['Pred_Gender'], TX['Gender'], labels=['male', 'female', 'mostly_male', 'mostly_female', 'andy', 'unknown'])
ax = sns.heatmap(cm_gender/np.sum(cm_gender), annot=True, 
            fmt='.2%', cmap='Blues')
ax.set_title('Predicted Gender Confusion Matrix\n');
ax.set_xlabel('\nActual Gender')
ax.set_ylabel('Predicted Gender ');

ax.xaxis.set_ticklabels(['male', 'female', 'mostly_male', 'mostly_female', 'andy', 'unknown'], rotation= 20)
ax.yaxis.set_ticklabels(['male', 'female', 'mostly_male', 'mostly_female', 'andy', 'unknown'], rotation=0)

plt.show()

TX['Pred_Gender'] = TX['Pred_Gender'].replace(['mostly_male'], 'male')
TX['Pred_Gender'] = TX['Pred_Gender'].replace(['mostly_female'], 'female')

print(confusion_matrix(TX['Pred_Gender'], TX['Gender'], labels=['male', 'female', 'andy', 'unknown']))
cm_gender = confusion_matrix(TX['Pred_Gender'], TX['Gender'], labels=['male', 'female', 'andy', 'unknown'])
ax = sns.heatmap(cm_gender/np.sum(cm_gender), annot=True, 
            fmt='.2%', cmap='Blues')
ax.set_title('Predicted Gender Confusion Matrix\n');
ax.set_xlabel('\nActual Gender')
ax.set_ylabel('Predicted Gender ');

ax.xaxis.set_ticklabels(['male', 'female', 'andy', 'unknown'], rotation= 20)
ax.yaxis.set_ticklabels(['male', 'female', 'andy', 'unknown'], rotation=0)

plt.show()