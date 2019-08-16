#you can load libraries by using the library function
library(dslabs)

#popular libraries are dplyr, dslabs, ggplot2, gapminder

df <- dslabs::murders

#see the following functions
head(df) # will print the first values of the data frame
names(df) #will print out the names of the columns

df$abb #will print all the data in that column (check that indeed abb is an column)

#first, observe that the modulusoperator is denoted by %%
#the filter function will return a subtable with the rows that satisfy certain
#conditions

filter(df, population%%2 ==1, population < 1000000)

#the select function will return a subtable with only a few specified columns
select(df, state, total)


#the pipe operator can summarize these lines

df2 <- df %>% filter(population < 1000000) %>% select(state, region, total)


#nrow() will count the number of rows in your data frame
nrow(df2)


#there is another way of creating data frames
column1 <- c(3, 2, 3, 2, 1)
column2 <- c(T, F, F, T, T)
column3 <- c("Hola", "cmamo", "chau", "321","xd")
mydf <- data.frame(myc1 = column1, cmam = column3, third = column2)


#subtlelty: all columns of a data frame created in this form are transformed into factors
#to avoid, this, change the stringAsFacors variable to FALSE (TRUE by default)
mydf2 <- data.frame(myc1 = column1, cmam = column3, third = column2, stringsAsFactors = FALSE)
#now
class(mydf2$myc1) #will return numeric
