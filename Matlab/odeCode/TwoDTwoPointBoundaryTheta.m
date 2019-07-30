a=0;
tfinal=5;
height=1;
L=10;
xa=[0; height];
xb=[L; 0];
%theta=pi/6;
%theta=pi/4;
theta=pi/3;
F=@(t,x) TwoPointsFun4(t,x);
v=TwoDSolverTheta( a,xa,xb,theta,F );
x0=[xa; v];
event=@(t,x) HitBack(t,x);
options=odeset('events',event);
[t,x,te,xe,ie]=ode45(F,[a tfinal],x0,options);
[t,x]=ode45(F,[a te],x0);
plot(x(:,1),x(:,2))