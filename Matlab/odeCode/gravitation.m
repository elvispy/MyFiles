G=1;
mass=[10 10];
t0=0;
tfinal=30;
tol=1e-3;
x0=[3 0 0 0 0 0 0 1 0 0 -1 0];
F=@(t,x) gravitationfun( t,x,mass,G );
TX = RKF45re( t0,tfinal,tol,x0,F );

for i = 1:length(TX)
    hold off
    plot3(TX(1:i,2),TX(1:i,3),TX(1:i,4),'b')
    hold on
    plot3(TX(1:i,5),TX(1:i,6),TX(1:i,7),'r')

    plot3(TX(i,2),TX(i,3),TX(i,4),'ob')
    plot3(TX(i,5),TX(i,6),TX(i,7),'or')
    pause(0.01)
end