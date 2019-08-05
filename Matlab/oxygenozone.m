k1=3e-12;
k2=1.22e-33;
k3=5.5e-4;
k4=6.86e-16;
m=9e17;
tol=1e-3;
t0=0;
tfinal=40;
tspan=[t0 tfinal];
h=1e-3;
x0=[4e16 2e16 2e16]';
F=@(t,x) oxyozofun( t,x,k1,k2,k3,k4,m );
t=t0:h:tfinal;
x = CrankNicolson( t0,tfinal,h,x0,F,k1,k2,k3,k4,m );
plot(t,x(1,:))
hold on
plot(t,x(2,:))
plot(t,x(3,:))