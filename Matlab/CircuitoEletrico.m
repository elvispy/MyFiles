t0=0;
tfinal=10;
tol=1e-3;
m=10;
x01=linspace(-2,2,m);
x02=linspace(2,-2,m);
x0=zeros(length(x01)*length(x02),2);
for i=1:length(x01)
    for j=1:length(x02)
        x0(i*j,:)=[x01(i) x02(j)];
    end
end
u=[1/10 1/2 2];
F=@(t,x) CirEle(t,x,u(3)/2);
for i=1:length(x01)*length(x02)
    tx = RKF45re( t0,tfinal,tol,x0(i,:),F );
    plot(tx(:,1),tx(:,2))
    hold on
end