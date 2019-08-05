t0=0;
tfinal=10;
h=0.01;
m=11;
x01=linspace(1,3,m);
x02=linspace(1,3,m);
x0=zeros(m,2);
x0(:,1)=x01;
x0(:,2)=x02;
t = t0:h:tfinal;
F=@(t,x) funlevel(t,x);
x=zeros(length(t),2,m);
for i=1:m
    x(:,:,i) = RK4( t0,tfinal,h,x0(i,:),F );
end
for i=1:m
    plot(x(:,1,i),x(:,2,i))
    hold on
end