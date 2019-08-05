function dx = Lotka( t,x,c1,c2,a11,a12,a21,a22 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
dx=zeros(1,2);
dx(1)=c1.*x(1).*(1-a11.*x(1)-a12.*x(2));
dx(2)=c2.*x(2).*(1-a21.*x(1)-a22.*x(2));

end

