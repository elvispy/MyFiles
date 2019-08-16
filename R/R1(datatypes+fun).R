#Comments are made with the numeral.
#Beware of the R compiler, it will compile only a portion of the code

#To make a vector, use the c function

a <- c(1, 2, 3, TRUE) #Vectors can only have one type of variable
#R will coerce that true value to a 1. If you put a string at the end of a, 
#it will transform all data to string type



#you can ask about the type of a variable
class(a)


#you can check for the length of a vector
length(a)

#you can create quick vectors just as in Matlab and Scilab
seq(1, 10) == 1:10
# all and any are acceptable functions in R
#seq can recieve a third argument of stepping



#you can try data coercion in R
as.character(a) # will print a character-type vector of a

#There is one more type apart from numeric. Is the integer type. You
#declare an integer value by putting an L after the number
class(12L)


#other useful functions for lists
#sort(list), or order(list), max(list), which.max(list)
#is.na(), sum(), mean()


#you ask for values in R using the brackets. The indexing in R begins with
#1
a[1]
