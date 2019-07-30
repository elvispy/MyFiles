function y = Airy( t,x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
y=zeros(length(t),2);
y(:,1) = x(:,2);
y(:,2) = t'.*x(:,1);
end

