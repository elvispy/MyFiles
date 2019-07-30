function dx = Lorenzfun( t,x,s,r,b )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dx=zeros(3,1);
dx(1)=-s*x(1)+s*x(2);
dx(2)=r*x(1)-x(2)-x(1)*x(3);
dx(3)=x(1)*x(2)-b*x(3);

end

