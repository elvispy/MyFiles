function y = intetra( k,t,fun )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
y=0;
for j=2:k
    y=y+(t(j)-t(j-1)).*(fun(j-1)+fun(j))./2;

end

