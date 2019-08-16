# if we have a logical vector, then which() will return the indices
#of the values which are true
lis <- c(F, T, T, T, F, F, T, F);
which(lis) # will return 2 3 4 7

#a list can recieve a logical as an input, provided that list has the same
#length as the original.
#example
lis[lis == FALSE] #in this case, lis == FALSE will return a logical

#the logical or is | and the logical and is &.
T & F
#F and T are shorthands for FALSE and TRUE, respectively

# the %in% operator returns a logical list. 
a <- c(10, 32, 21, 5)
b <- c(1, 2, 3, 4, 5, 6, 21)
b %in% a # (b %in% a)[i] == TRUE iff b[i] belongs to a. So length(b) = length(b %in% a)


