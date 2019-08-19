options(scipen = 999) #Turn off scientific notation

library (ggplot2)
data("midwest", package = "ggplot2") #load the data
#midwest <- read.csv("http://goo.gl/G1K41K") # alt source 

#normal ggplot syntax
g <- ggplot(midwest, aes(x = area, y = poptotal)) + geom_point() 
g <- g + geom_smooth(method = "lm") #added geom_smooth method

#changing X and Y axes.
g + xlim(c(0,0.1)) +  ylim(c(0, 1000000));

#the previos line of code deletes the points outside the scope
#there is a way of zomming in without deleting points:
g1 <- g + coord_cartesian(xlim = c(0,0.1) , ylim = c(0, 1000000));


#adding label and titles
g1 + labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")


print(g1)

print(g) #plotting g
