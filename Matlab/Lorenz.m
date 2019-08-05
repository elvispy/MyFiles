s=10;
b=8./3;
r=28;
F=@(t,x) Lorenzfun( t,x,s,r,b );
x0=[10 10 10]';
t0=0;
tfinal=20;
event=@(t,x) SecaoTransversal(t,x,r,b);
options=odeset('events',event);
[t,x,te,xe,ie]=ode45(F,[t0 tfinal],x0,options);
plot3(x(:,1),x(:,2),x(:,3))
hold on

indS = xe(:,1).^2 +xe(:, 2).^2 < b.*(r-1);
plot3(xe(indS,1),xe(indS,2),xe(indS,3),'*r')