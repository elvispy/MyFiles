t0=0;
tfinal=10;
h=0.1;
%h=0.5;
%h=1;
t=t0:h:tfinal;
tol=1e-10;
m=10;
x01=linspace(-2,2,m);
x02=linspace(2,-2,m);
x0=zeros(length(x01)*length(x02),2);
for i=1:length(x01)
    for j=1:length(x02)
        x0(i*j,:)=[x01(i) x02(j)];
    end
end
F=@(t,x) CirEle(t,x,1);
for i=1:length(x01)*length(x02)
    x = RK4( t0,tfinal,h,x0(i,:),F );
    plot(t,x(:,1))
    hold on
end