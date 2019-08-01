/*plotting*/

x = linspace(1,100,200)

y = x .^2

//plot(x,y)
//plot(x, cos(x), 'r*')
//----------------------------------

//now i will make a polar plot
theta = 0:.01:3*%pi

//polarplot(sin(2*theta), cos(2*theta))
//xtitle('Using PolarPlot')
//----------------------------------

//now an histogram

n = rand(1, 10e4, 'normal')

bins = 30

//histplot(bins, n)

title('Histogram plotting random numbers in normal distribution')

xlabel('x')

ylabel('y')
//------------------------------------
//program to plot using grayplot
x = -10:10
y = -10:10
m = rand(21,21)
//grayplot(x,y,m)
xtitle('Using grayplot for random numbers')
xlabel('x')
ylabel('y')

//-------------------------

x = linspace(-1, 1, 10)
y = linspace(-2, 0, 10)
[X, Y] = meshgrid(x, y)

fy = 3.*Y

fx = 0.5.*X

champ(x, y, fx', fy')

xtitle('Using champ function to plot vector field')

xlabel('x')
ylabel('y')
