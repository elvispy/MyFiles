#lets see some functions
#runif will create a list of elements between min and max with
#uniform distribution
runif(10, min = -1, max = 1)

#mean() and sd() will compute the mean and standard deviation
#respectively.

#Norm(x, p) will return the lp norm of x.

#Q-Q plots
tem <- airquality$Temp

#given p belonging to [0, 1], and a vector x of results,
#we say that q is the quantile of p with respect to x if
#P(x<=q) = p. The function quantiles achieves this

p<- seq(0, 1, 0.05)

q <- quantile(tem,p)

#sometimes we want to compare our data to known distributions
# we can generate quantiles of various types of distributions
#for example
theo <- qnorm(p, mean= mean(tem), sd = sd(tem))
#will generate the theoretical quantiles of a perfect normal distribution

#now we can plot theo against q. 
plot(theo, q)
abline(0,1) #plots ax+b?

#obs: we can do tem = scale(tem) and theo = qnorm(tem)
#since now mean(tem) = 0, sd(tem) =1.