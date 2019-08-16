#Now lets see some structures in R


#the if statement is quite simple
a<- V | F; #a is TRUE
b <- 2;
if(a == 4) {
  print("esto va a ser printeado")
} else if (a == TRUE) {
  print("o esto")
} else {
  b <- 1
} #end if statement




#now the for structure
for (i in 1:12){
  
  if (i %% 3){ #just as in python, R makes coercions when 
    #recieving non logical values.
    
    print(i)
    
  } #end if
  
}#end for


#we can define our own functions, also. use the return function
#to return values.

fun <- function(x, y = 1){
  if (x>0){
    result <- x*y;
  }else{
    result<- x+y
  } #end if
  
  return(result);
}#end function definition

#if you dont put a return statement, the last line of 
#the function will determine the value to be returned.

fun2 <- function(x, y = 1){
  if (x>0){
    result <- x*y;
  }else{
    result<- x+y
  } #end if
  
  result
}
#you can check that fun(x, y) == fun2(x, y), for all posible values.


#in R you also have multi returning.

multi_return <- function() {
  my_list <- list("color" = "red", "size" = 20, "shape" = "round")
  return(my_list) 
} #will return a "data frame"
