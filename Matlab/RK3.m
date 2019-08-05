function x = RK3( t0,tfinal,h,x0,F )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
t=t0:h:tfinal;
x=zeros(length(t),length(x0));
x(1,:)=x0;
for i=2:length(t)
    k1=F(t(i-1),x(i-1,:));
    k2=F(t(i-1)+h/2,x(i-1,:)+k1.*h./2);
    k3=F(t(i),x(i-1,:)+(-k1+2.*k2).*h);
    x(i,:)=x(i-1,:)+(k1+4.*k2+k3).*h./6;
end

