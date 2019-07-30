function y = CirEle( t,x,u )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
y=zeros(1,2);
y(1)=x(2);
y(2)=-x(1)-u.*(x(1)^2-1)*x(2);
end

