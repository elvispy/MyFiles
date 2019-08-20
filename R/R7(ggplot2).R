library(ggplot2)
library(tidyverse)
library(dslabs)


#we begin win some random exmple of using ggplot2
param <- heights %>% filter(sex == "Male") %>% summarize(mean = mean(height), sd = sd(height))

heights %>% filter( sex == "Male") %>% ggplot(aes(sample = height)) + geom_qq(dparams = param)
heights %>% filter(sex == "Male") %>% ggplot(aes(x = height)) + geom_histogram()

ggplot(diamonds, aes(x = carat, y = price, color = cut)) + geom_point() + geom_smooth()
