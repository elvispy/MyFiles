function x = Euler( t0,tfinal,h,x0,F )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
t=t0:h:tfinal;
x=zeros(length(t),length(x0));
x(1,:)=x0;
for i=2:length(t)
    x(i,:)=x(i-1,:)+F(t(i-1),x(i-1,:)).*h;
end

