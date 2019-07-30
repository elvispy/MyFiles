function y = interec( k,t,fun )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
y=zeros(1,2);
for j=2:k
    y=y+(t(j)-t(j-1)).*fun(j,:);

end
