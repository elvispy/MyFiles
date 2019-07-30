function x = Talor3( t0,tfinal,h,x0,F )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
t=t0:h:tfinal;
x=zeros(length(t),length(x0));
x(1,:)=x0;
F1=@(t,x) [(1-x(1))./(x(1).*x(2).*x(2)),(1-x(2))./(x(2).*x(1).*x(1))];
F2=@(t,x) [(-1+4*x(1)-2*x(1)^2-x(2))/(x(1)^2*x(2)^3),(1+x(1)-4*x(2)+2*x(2)^2)/(x(2)^2*x(1)^3)];
for i=2:length(t)
    x(i,:)=x(i-1,:)+F(t(i-1),x(i-1,:)).*h+F1(t(i-1),x(i-1,:)).*(h^2)/2+F2(t(i-1),x(i-1,:)).*(h^3)/6;
end
