function dx = Duffingfun( t,x,delta,alpha,beta,gamma,omega )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
dx=zeros(1,3);
dx(1)=x(2);
dx(2)=-delta.*x(2)-beta.*x(1)-alpha.*(x(1).^3)-gamma.*omega.*sin(omega.*x(3));
dx(3)=1;

end

