function y = fun210( t,x )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
y=zeros(length(t),2);
y(:,1) = x(1,:,2);
y(:,2) = -x(1,:,1)+2.*sin(t);

end

