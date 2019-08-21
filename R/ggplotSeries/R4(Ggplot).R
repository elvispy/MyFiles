#how to change the X and Y axis text and its location?

#1) Set the breaks.

# Base plot
gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state), size=3) +  # Set color to vary based on state categories.
  geom_smooth(method="lm", col="firebrick", size=2) + 
  coord_cartesian(xlim=c(0, 0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")

# Change breaks
gg + scale_x_continuous(breaks=seq(0, 0.1, 0.01))
#begin at 0, ends at 0.1, step 0.01.
#See that this will generate ten breaks. We then say that our
#break has length 10. 


# 2) Change the labels. FOr that, you must specify a vector of
#strings of the same length of your break.

#change labels
gg + scale_x_continuous(breaks = seq(0, 0.1, 0.01), labels = letters[1:11])


#If you need to reverse the scale, use scale_x_reverse()

gg + scale_y_reverse()
#also the y axis can be reversed
