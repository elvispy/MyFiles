function x = ImplicitEuler( t0,tfinal,h,x0,F,k1,k2,k3,k4,m )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
t=t0:h:tfinal;
I=[1 0 0;
   0 1 0;
   0 0 1];
Jf=@(x) h.*[-k2.*m.*x(2)-k4.*x(3) 2*k1-k2.*m.*x(1) k3-k4.*x(1);
   -k2.*m.*x(2)+2*k4.*x(3) -k1-k2.*m.*x(1) k3+2*k4.*x(1);
   k2.*m.*x(2)-k4.*x(3) k2.*m.*x(1) -k3-k4.*x(1)]-I;
tol=1e10;
y=zeros(3,2e5);
x=zeros(3,length(t));
x(:,1)=x0;
for i=2:length(t)
    y(:,1)=x(:,i-1);
    for k=1:2e5
        if max(abs((h.*F(t(i),y(:,k))-y(:,k)+x(:,i-1))))>tol
            dy=Jf(y(:,k))\(-h.*F(t(i),y(:,k))+y(:,k)-x(:,i-1));
            y(:,k+1)=y(:,k)+dy;
        else
            break
        end
    end
    x(:,i)=y(:,k);
end

