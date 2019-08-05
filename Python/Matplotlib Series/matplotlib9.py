import random
from itertools import count
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

plt.style.use('fivethirtyeight')
'''
x_vals = []
y_vals = []

#plt.plot(x_vals, y_vals)


index = count()

def animate(i):
    This function is generating random numbers from 0 to 5 and plotting them
    in real time. It seems like FuncAnimation below is giving one argument to
    animate, so even though the argument i is not being used, it is esssential
    to the code
    x_vals.append(next(index))
    y_vals.append(random.randint(0, 5))

    plt.cla() #this clears the last plot
    plt.plot(x_vals, y_vals)
    

ani = FuncAnimation(plt.gcf(), #this will get the current figure
                    animate, #this is the function we want to animate
                    interval = 100) #this is the interval of time in which we want to update

'''
#------------ now another example ------------------
index = count()

def animate(i):
    
    data = pd.read_csv('data9.csv')
    x = data['x_value']
    y1 = data['total_1']
    y2 = data['total_2']

    plt.cla()
    plt.plot(x, y1, label = 'Channel 1')
    plt.plot(x, y2, label = 'Channel 2')

    plt.legend(loc = 'upper left')
    plt.tight_layout()
    

ani = FuncAnimation(plt.gcf(), #this will get the current figure
                    animate, #this is the function we want to animate
                    interval = 100) #this is the interval of time in which we want to update

plt.show()
