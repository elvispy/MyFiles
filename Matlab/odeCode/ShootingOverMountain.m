a=0;
tfinal=50;
shootheight=0;
L=8e4;
xa=[0; shootheight];
xb=[L; 0];
mountainposition=1e4;
mountainheight=1e3;
Module=2e3;
F=@(t,x) TwoPointsFun4(t,x);
event=@(t,x) HitBack(t,x);
options=odeset('events',event);
diff=-1;
while (diff<0)
    xb(1)=xb(1)+1;
    v=TwoDSolverModule( a,xa,xb,Module,F );
    x0=[xa; v];
    [t,x,te,xe,ie]=ode45(F,[a tfinal],x0,options);
    for i=1:size(x)*[1;0]
        if x(i,1)<mountainposition+xb(1)-L
            continue
        else
            diff=min(x(i-1,2)-mountainheight,x(i,2)-mountainheight);
            break
        end
    end
end
plot(x(:,1),x(:,2))
hold on
retreat=xb(1)-L
angle=acos(dot(v,[1;0])/norm(v,2))
plot([10^4+retreat,10^4+retreat],[0,1e3])