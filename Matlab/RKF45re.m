function TX = RKF45re( t0,tfinal,tol,x0,F )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
t=t0:0.001:tfinal;
x=zeros(length(t),length(x0));
y=zeros(length(t),length(x0));
x(1,:)=x0;
%h=1;
%h=0.1;
h=0.01;
i=2;
while t(i-1)<tfinal
    [ tnew,xnew,ynew ] = RKF45Step( t(i-1),x(i-1,:),h,F );
    erro=max(abs(xnew-ynew));
    if erro<tol/2
        t(i)=tnew;
        x(i,:)=xnew;
        y(i,:)=ynew;
        i=i+1;
    else
        h=(tol/(2*erro))^(1/4).*h;
    end
    if i==length(t)
        break
    end
end
TX=zeros(i-1,1+length(x0));
for k=1:i-1
    TX(k,1)=t(k);
    TX(k,2:(length(x0)+1)) = x(k,:);
end


