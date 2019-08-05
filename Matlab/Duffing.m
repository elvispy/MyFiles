delta=0.25;
beta=-1;
alpha=1;
omega=1;
gamma=0.4;
t0=0;
tfinal=5000;
h=1e-2;
F=@(t,x) Duffingfun( t,x,delta,alpha,beta,gamma,omega );
x0=[0.2 0 0];
lambda = LyapunovExponent( F,t0,tfinal,h,x0 );
plot(lambda)