c1=1;
c2=-1;
a11=0.5;
a12=1;
a21=1;
a22=-0.5;
t0=0;
tfinal=7;
h=0.1;
t=t0:h:tfinal;
x=zeros(length(t),2);
x(1,:) = [1 0.1];
for step=2:length(t)
    x(step,:)=x(step-1,:)+h.*Lotka(t(step-1),x(step-1,:),c1,c2,a11,a12,a21,a22);
end

plot(t,x(:,1),'r');
hold on;
plot(t,x(:,2),'b');
figure
plot(x(:,1),x(:,2),'-*');