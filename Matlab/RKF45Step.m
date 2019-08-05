function [ tnew,xnew,ynew ] = RKF45Step( t,x,h,F )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tnew=t+h;
k1=F(t,x);
k2=F(t+h/4,x+k1.*h./4);
k3=F(t+3*h/8,x+3*k1.*h./32+9*k2.*h/32);
k4=F(t+12*h/13,x+1932*k1.*h/2197-7200*k2.*h/2197+7296*k3.*h/2197);
k5=F(t+h,x+439*k1.*h/216-8*k2.*h+3680*k3.*h/513-845*k4.*h/4104);
k6=F(t+h/2,x-8*k1.*h/27+2*k2.*h-3544*k3.*h/2565+1859*k4.*h/4104-11*k5.*h/40);
xnew=x+25*k1.*h./216+1408*k3.*h./2565+2197*k4.*h./4104-k5.*h./5;
ynew=x+16*k1.*h./135+6656*k3.*h./12825+28561*k4.*h./56430-9*k5.*h./50+2*k6.*h./55;

end

