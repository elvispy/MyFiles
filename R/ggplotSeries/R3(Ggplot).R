library(ggplot2)
data("midwest", package = "ggplot2") #load the data

gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state), size=3) +  # Set color to vary based on state categories.
  geom_smooth(method="lm", col="firebrick", size=2) + 
  coord_cartesian(xlim=c(0, 0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")
plot(gg)

#not just color, but size, shape, stroke and fill can be
#used to discriminate groupings.

gg+ theme(legend.position = "None") #taking out  legend

gg + scale_colour_brewer(palette = "Set1") #changing the palette