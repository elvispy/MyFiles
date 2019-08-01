from matplotlib import pyplot as plt
import numpy as np
import csv
import pandas as pd
from collections import Counter #this will count the languages

plt.style.use("fivethirtyeight")

##with open("data2.csv", "r") as languages:
##    csv_reader = csv.DictReader(languages)
##
##    language_counter = Counter()
##
##    for row in csv_reader:
##        language_counter.update(row['LanguagesWorkedWith'].split(";"))

data = pd.read_csv('data2.csv')
ids = data['Responder_id']
lang_responses = data['LanguagesWorkedWith']

language_counter = Counter()

for response in lang_responses:
    language_counter.update(response.split(";"))

languages = []
popularity = []
for item in language_counter.most_common(15): # the most_common() method will return the most common one
    languages.append(item[0])
    popularity.append(item[1])
else:
    languages.reverse()
    popularity.reverse()
#plt.bar(languages, popularity) this is a vertical bar

plt.barh(languages,popularity)

plt.title("Most common languages")
#plt.xlabel("Programming languages")
plt.xlabel("Number of people who use it")

plt.tight_layout()

plt.show()
    #row = next(csv_reader)
    #print(row['LanguagesWorkedWith'].split(";"))
    

##ages_x = [25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]
##
##x_indexes = np.arange(len(ages_x))
##
##width = 0.25
##
##dev_y = [38496, 42000, 46752, 49320, 53200,
##         56000, 62316, 64928, 67317, 68748, 73752]
##plt.bar(x_indexes - width, dev_y, color="#444444", label="All Devs", width = width)
##
##py_dev_y = [45372, 48876, 53850, 57287, 63016,
##             65998, 70003, 70000, 71496, 75370, 83640]
##plt.bar(x_indexes, py_dev_y, color="#008fd5", label="Python", width = width)
##
##js_dev_y = [37810, 43515, 46823, 49293, 53437,
##             56373, 62375, 66674, 68745, 68746, 74583]
##plt.bar(x_indexes + width, js_dev_y, color="#e5ae38", label="JavaScript", width = width)
##
##plt.legend()
##
##plt.xticks(ticks = x_indexes, labels = ages_x)
##
##plt.title("Median Salary (USD) by Age")
##plt.xlabel("Ages")
##plt.ylabel("Median Salary (USD)")
##
##plt.tight_layout()
##
##plt.show()
