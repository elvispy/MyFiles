import pandas as pd
from matplotlib import pyplot as plt

plt.style.use('fivethirtyeight')

#ages = [18, 19, 21, 25, 26, 26, 30, 32, 38, 45, 55]

bins = list(range(10,101,10)) #this will show up all values between 10 and 60




data = pd.read_csv('data6.csv')
ids = data['Responder_id']
ages = data['Age']

median_age = 29
color = '#fc4f30'

plt.hist(ages, bins = bins, edgecolor = 'black', log = True)



plt.title('Ages of Respondents')
plt.xlabel('Ages')
plt.ylabel('Total Respondents')

plt.axvline(median_age, color = color, label = 'Age Median')

plt.legend()

plt.tight_layout()

plt.show()
