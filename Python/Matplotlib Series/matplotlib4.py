from matplotlib import pyplot as plt

plt.style.use("fivethirtyeight")


days = [1, 2, 3, 4, 5, 6, 7, 8, 9]

player1 = [8, 6, 5, 5, 4, 2, 1, 1, 0]
player2 = [0, 1, 2, 2, 2, 4, 4, 4, 4]
player3 = [0, 1, 1, 1, 2, 2, 3, 3, 4]
labels = ['Player1', 'Player2', 'Player3']

plt.stackplot(days, player1, player2, player3,
              labels = labels,
              colors = ['#fc4f30', '#6d904f', '#008fd5'])

plt.legend(loc = (0.07, 0.05)) #or upper left or lower left etc etc
#plt.pie([1, 1, 1], labels=["Player 1", "Player2", "Player3"])

plt.title("My Awesome Stack Plot")
plt.tight_layout()
plt.show()

# Colors:
# Blue = #008fd5
# Red = #fc4f30
# Yellow = #e5ae37
# Green = #6d904f
