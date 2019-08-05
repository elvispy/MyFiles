a=0;
tfinal=5;
shootheight=1;
L=10;
xa=[0; shootheight];
xb=[L; 0];
%Module=10;
%Module=15;
Module=20;
F=@(t,x) TwoPointsFun4(t,x);
v=TwoDSolverModule( a,xa,xb,Module,F );
x0=[xa; v];
event=@(t,x) HitBack(t,x);
options=odeset('events',event);
[t,x,te,xe,ie]=ode45(F,[a tfinal],x0,options);
[t,x]=ode45(F,[a te],x0);
plot(x(:,1),x(:,2))
for i=1:size(x)*[1;0]
        if x(i,1)<1.5e4
            continue
        else
            diff=min(x(i-1,2)-1e3,x(i,2)-1e3)
            break
        end
end