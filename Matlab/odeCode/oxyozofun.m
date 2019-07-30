function dx = oxyozofun( t,x,k1,k2,k3,k4,m )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
dx=zeros(3,1);
dx(1)=2*k1.*x(2)-k2.*m.*x(1).*x(2)+k3.*x(3)-k4.*x(1).*x(3);
dx(2)=-k1.*x(2)-k2.*m.*x(1).*x(2)+k3.*x(3)+2*k4.*x(1).*x(3);
dx(3)=k2.*m.*x(1).*x(2)-k3.*x(3)-k4.*x(1).*x(3);
end

