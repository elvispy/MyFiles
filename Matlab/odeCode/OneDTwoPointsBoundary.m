a=0;
b=1;
xa=0;
xb=0;
h=0.001;
%h=1; %This code is to show the importance of time step
t=a:h:b;
F=@(t,x) TwoPointsFun(t,x);
v=OneDSolver( a,b,xa,xb,F );
x0=[xa v];
x = RK4( a,b,h,x0,F );
plot(t,x(:,1))