t0=-15;
a=18;
epes=0.25;
tol=0.001;
T=t0:epes:t0+a;
x0=[0 1];
h=0.01;
m=epes/h+1;
Xold=zeros(m,2);
Xold(:,2)=ones(m,1);
erro=1;
t=t0:h:T(2);
F = @(t,x) Airy(t,x);
while erro>tol
    Xnew=Picard(t,Xold,F);
    erro=max(max(abs(Xold-Xnew)));
    Xold=Xnew;
end
for i=2:length(T)-1
    t=t0:h:T(i+1);
    Xold=[Xold(1:end-1,:);ones(m,1)*Xold(end,:)];
    erro=1;
    while erro>tol
        Xnew=Picard(t,Xold,F);
        erro=max(max(abs(Xold-Xnew)));
        Xold=Xnew;
    end
end
plot(t,Xold(:,1))