function v = TwoDSolverModule( a,xa,xb,Module,F )
%UNTITLED4 Summary of this function goes here
%   xa,xb are column vector
event=@(t,x) HitBack(t,x);
options=odeset('events',event);
tfinal=100;
theta0=0.001;
vtheta=zeros(1000);
vtheta(1)=theta0;
for i=1:999
    xv0=[xa; Module*[cos(vtheta(i)); sin(vtheta(i))]];
    xvh0=[xa; Module*[cos(vtheta(i)+1e-4); sin(vtheta(i)+1e-4)]];
    [t,x,te,xe,ie]=ode45(F,[a tfinal],xvh0,options);
    xvh=xe(1);
    [t,x,te,xe,ie]=ode45(F,[a tfinal],xv0,options);
    xv=xe(1);
    f=xv-xb(1);
    fh=xvh-xb(1);
    df=1e4*(fh-f);
    vtheta(i+1)=vtheta(i)-f./df;
    difference=abs(vtheta(i+1)-vtheta(i));
    if difference<1e-3
        break
    end
end
v=Module*[cos(vtheta(i+1)); sin(vtheta(i+1))];