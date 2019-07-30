t0=0;
tfinal=4*pi;
tol=1e-3;
x0=[0 0];
a=0;
b=1;
c=2;
w=1;
F=@(t,x) ressfun(a,b,c,w,t,x);
TX = RKF45re( t0,tfinal,tol,x0,F );
plot(TX(:,1),TX(:,2))
hold on
w=0.9;
F=@(t,x) ressfun(a,b,c,w,t,x);
TX = RKF45re( t0,tfinal,tol,x0,F );
plot(TX(:,1),TX(:,2))
w=1.1;
F=@(t,x) ressfun(a,b,c,w,t,x);
TX = RKF45re( t0,tfinal,tol,x0,F );
plot(TX(:,1),TX(:,2))