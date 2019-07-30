N=3;
d=2;
t0=0;
h=0.01;
tfinal=0.25;
t=t0:h:tfinal;
Gamma=zeros(N,length(t),d);
Gamma(1,:,1)=ones(1,length(t));
Gamma(1,:,2)=zeros(1,length(t));
x0=[1 0];
for i=2:N
    for k=1:length(t)
        Gamma(i,k,:)=x0+interec(k,t,fun210(t,Gamma(i-1,:,:)));
    end
end
plot(t,(1-t).*cos(t)+sin(t),'r')
hold on
for i=1:N
    plot(t,Gamma(i,:,1))
end
