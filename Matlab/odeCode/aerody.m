function y = aerody( t,x )
%UNTITLED2 Summary of this function goes here
%   y = (h , alpha , h' , alpha')
m=1;
l=1;
kh=1;
ka=1;
c=1;
vc=((6*kh*kh*(l^4)+54*ka*ka+18*kh*ka*l*l)/(9*kh*c*l*l))^(1/2);
v=vc-0.01;
M=[m m*l/2; m*l/2 m*l*l/3];
Q=[kh c*v*v; 0 ka+c*l*v*v/2];
y=zeros(1,4);
y(1:2)=x(3:4);
y(3:4) = -(inv(M)*Q*x(1:2)')';
end

