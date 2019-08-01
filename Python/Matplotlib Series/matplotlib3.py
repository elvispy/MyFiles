from matplotlib import pyplot as plt

plt.style.use("fivethirtyeight")

# Colors:
# Blue = #008fd5
# Red = #fc4f30
# Yellow = #e5ae37
# Green = #6d904f

slices = [59219, 55466, 47544, 36443, 35917]# 31991, 27097, 23030, 20524, 18523, 18017, 7920, 7331, 7201, 5833]
labels = ['JavaScript', 'HTML/CSS', 'SQL', 'Python', 'Java']#, 'Bash/Shell/PowerShell', 'C#', 'PHP', 'C++', 'TypeScript', 'C', 'Other(s):', 'Ruby', 'Go', 'Assembly']
explode = [0,0, 0, 0.1, 0]


plt.pie(slices,labels = labels,
        wedgeprops = {'edgecolor':'black'},
        explode = explode, shadow = True, #explode and shadow
        startangle = 90, autopct = '%1.1f%%') #rotating and showing percentages
#to add colors, just add another argument color = list, with the list of colors

plt.title("My Awesome Pie Chart")
plt.tight_layout()
plt.show()
