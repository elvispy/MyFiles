clear all;
t=[0:0.0001:0.4];
A1=0.15;
t1=0.015;
f1=1200;
mu_1=80;
A2=0.2;
t2=0.050;
f2=3000;
mu_2=50;

V1=A1.*exp(-mu_1*(t-t1)).*sin(2*%pi*f1*(t-t1)).*heaviside(t-t1);
V2=A2*exp(-mu_2*(t-t2)).*sin(2*%pi*f2*(t-t2)).*heaviside(t-t2);
V=V1+V2;

plot(V)
