t0=0;
tfinal=10;
tol=1e-5;
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

figure('units','normalized','position',[0.1 0.1 0.8 0.8]);

F=@(t,x) CirEle(t,x,u(1));
for i=1:length(x01)*length(x02)
    tx = RKF45re( t0,tfinal,tol,x0(i,:),F );
    
    fig1 = subplot(1,3,1);
    plot(tx(:,2),tx(:,3))
    hold on
end

F=@(t,x) CirEle(t,x,u(2));
for i=1:length(x01)*length(x02)
    tx = RKF45re( t0,tfinal,tol,x0(i,:),F );
    
    fig2 = subplot(1,3,2);
    plot(tx(:,2),tx(:,3))
    hold on
end

F=@(t,x) CirEle(t,x,u(3));
for i=1:length(x01)*length(x02)
    tx = RKF45re( t0,tfinal,tol,x0(i,:),F );
    
    fig3 = subplot(1,3,3);
    plot(tx(:,2),tx(:,3))
    hold on
end

title(fig1,sprintf('u = %g',u(1)))

title(fig2,sprintf('u = %g',u(2)))

title(fig3,sprintf('u = %g',u(3)))