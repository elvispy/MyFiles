t0=0;
x0=pi/4;
tfinal=3;
h=0.01;
t=t0:h:tfinal;
x=zeros(length(t),1);
x(1)=x0;
for step=2:length(t)
    x(step)=x(step-1)+h.*coos(x(step-1));
end
plot(t,x-atan(1+t)')