function y = interecr( t,fun )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
x=zeros(length(t),2);
for j=2:length(t)
    x(j,:)=(t(j)-t(j-1)).*fun(j,:);
end
y=cumsum(x);
