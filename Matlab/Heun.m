function x = Heun( t0,tfinal,h,x0,F )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
t=t0:h:tfinal;
x=zeros(length(t),length(x0));
x(1,:)=x0;
for i=2:length(t)
    k1=F(t(i-1),x(i-1,:));
    k2=F(t(i),x(i-1,:)+k1.*h);
    x(i,:)=x(i-1,:)+(k1+k2).*h.*0.5;
end

