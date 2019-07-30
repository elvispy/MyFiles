function dx = TwoPointsFun( t,x )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
dx=zeros(1,2);
dx(1)=x(2);
dx(2)=2*x(1)^2;        %Objective1(i)
%dx(2)=-4*x(2)-13*x(1); %Objective1(ii)
%dx(2)=t*(5-t)+2*x(1);   %Objective1(iii)
%dx(2)=-10*sin(x(1));   %Elastica Problem
%dx(2)=-t;              %Steady-State Problem
end