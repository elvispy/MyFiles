library(ggplot2)

data("midwest", package = "ggplot2") #load the data

gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state), size=3) +  # Set color to vary based on state categories.
  geom_smooth(method="lm", col="firebrick", size=2) + 
  coord_cartesian(xlim=c(0, 0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset",
       y="Population", x="Area", caption="Midwest Demographics")

# Change Axis Texts
#formatting with sprintf
gg + scale_x_continuous(breaks=seq(0, 0.1, 0.01), 
                        labels = sprintf("%1.2f%%", seq(0, 0.1, 0.01))) + 
  scale_y_continuous(breaks=seq(0, 1000000, 200000), 
                     labels = function(x){paste0(x/1000, 'K')})
#giving a function to labels.