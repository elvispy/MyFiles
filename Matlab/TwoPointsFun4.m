function dx = TwoPointsFun4( t,x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dx=zeros(4,1);
dx(1)=x(3);
dx(2)=x(4);
dx(3)=0;
dx(4)=-9.8;
end

