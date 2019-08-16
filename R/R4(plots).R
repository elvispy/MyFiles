#lets see some plots
#airquality is a built-in data frame which i will use
head(airquality)


#plot will make an x-axis against y-axis plot.
plot(airquality$Day, airquality$Temp)


#Hist will make an histogram of the data
hist(airquality$Month)


#and also we can make a boxplot
boxplot(airquality$Ozone,
        main = "Mean ozone in parts per billion at Roosevelt Island",
        xlab = "Parts Per Billion",
        ylab = "Ozone",
        col = "lightblue",
        border = "black",
        horizontal = TRUE,
        notch = TRUE
)


#We can draw multiple boxplots in a single plot,
#by passing in a list, data frame or multiple vectors

ozone <- airquality$Ozone
temp <- airquality$Temp
ozone_norm <- rnorm(200, mean = mean(ozone, na.rm = TRUE), sd = sd(ozone, na.rm = TRUE))
temp_norm <- rnorm(200, mean = mean(temp, na.rm = TRUE), sd = sd(temp, na.rm = TRUE))

boxplot(ozone, ozone_norm, temp, temp_norm,
        main = "Multiple boxplots for comparision",
        at = c(1,2,4,5),
        names = c("ozone", "normal", "temp", "normal"),
        las = 1,
        col = c("orange","red"),
        border = "brown",
        horizontal = TRUE,
        notch = TRUE
)


#finally, we can group by name

boxplot(Temp~Month,
        data=airquality,
        main="Different boxplots for each month",
        xlab="Month Number",
        ylab="Degree Fahrenheit",
        col="orange",
        border="brown"
)
