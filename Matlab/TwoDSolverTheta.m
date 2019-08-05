function v = TwoDSolverTheta( a,xa,xb,theta,F )
%UNTITLED4 Summary of this function goes here
%   xa,xb are column vector
event=@(t,x) HitBack(t,x);
options=odeset('events',event);
v0=1*[cos(theta); sin(theta)];
tfinal=100;
vv=zeros(1000);
vv(1)=norm(v0,2);
for i=1:999
    xv0=[xa; vv(i)*[cos(theta); sin(theta)]];
    xvh0=[xa; (vv(i)+1e-4)*[cos(theta); sin(theta)]];
    [t,x,te,xe,ie]=ode45(F,[a tfinal],xvh0,options);
    xvh=xe(1);
    [t,x,te,xe,ie]=ode45(F,[a tfinal],xv0,options);
    xv=xe(1);
    f=xv-xb(1);
    fh=xvh-xb(1);
    df=1e4*(fh-f);
    vv(i+1)=vv(i)-f./df;
    difference=abs(vv(i+1)-vv(i));
    if difference<1e-3
        break
    end
end
v=vv(i+1)*[cos(theta); sin(theta)];