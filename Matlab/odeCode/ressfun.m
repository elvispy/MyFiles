function dx = ressfun( a,b,c,w,t,x )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
dx=zeros(1,2);
dx(1)=x(2);
dx(2)=-b^2*x(1)-a*x(2)+c*sin(w*t);
end

