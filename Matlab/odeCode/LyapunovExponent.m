function lambda = LyapunovExponent( F,t0,tfinal,h,x0 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
t=t0:h:tfinal;
x=zeros(length(t),length(x0));
xx=zeros(length(t),length(x0));
x(1,:)=x0;
xx(1,:)=x0;
N=length(t);
d0 = 1e-12;
dx0=d0.*ones(1,3);
LyapSum=0;
dx=zeros(N,3);
dx(1,:)=dx0;
lambda=zeros(N-1,1);
for i=2:N
    k1=F(t(i-1),x(i-1,:));
    k2=F(t(i-1)+h/2,x(i-1,:)+k1.*h./2);
    k3=F(t(i-1)+h/2,x(i-1,:)+k2.*h./2);
    k4=F(t(i),x(i-1,:)+k3.*h);
    k11=F(t(i-1),x(i-1,:)+dx(i-1,:));
    k22=F(t(i-1)+h/2,x(i-1,:)+k11.*h./2+dx(i-1,:));
    k33=F(t(i-1)+h/2,x(i-1,:)+k22.*h./2+dx(i-1,:));
    k44=F(t(i),x(i-1,:)+k33.*h+dx(i-1,:));
    x(i,:)=x(i-1,:)+(k1+2.*k2+2.*k3+k4).*h./6;
    xx(i,:)=x(i-1,:)+dx(i-1,:)+(k11+2.*k22+2.*k33+k44).*h./6;
    dx(i,:)=xx(i,:)-x(i,:);
    LyapSum=log(norm(dx(i,:),2)./norm(dx(i-1,:),2))+LyapSum;
    lambda(i-1)=LyapSum./((i-1).*h);
    dx(i,:) = d0.*(dx(i,:)./norm(dx(i,:),2));
end