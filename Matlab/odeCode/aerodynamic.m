F=@(t,x) aerody(t,x);
t0=0;
tfinal=60;
tol=1e-3;
x0=[0  2  0 0];
TX = RKF45re( t0,tfinal,tol,x0,F );
plot(TX(:,1),TX(:,2))