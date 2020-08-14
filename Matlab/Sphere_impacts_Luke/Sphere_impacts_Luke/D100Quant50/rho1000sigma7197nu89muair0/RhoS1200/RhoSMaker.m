clear
close all
clc

rhoS = 1.20; save('rhoS.mat','rhoS')%ball density in gr/cm^3

cd ..
load('nu.mat')
load('muair.mat')
load('rho.mat')
load('sigma.mat')

cd ..
load('D.mat')
load('quant.mat')

cd(['rho',num2str(1000*rho),'sigma',num2str(round(100*sigma)),'nu',num2str(round(10000*nu)),'muair',num2str(muair)])
load('rho.mat','rho')

if rhoS < 1
    cd(['RhoS0',num2str(1000*rhoS)])
else
    cd(['RhoS',num2str(1000*rhoS)])
end

Ma = 4*pi*rhoS/(3*rho); save('Ma.mat','Ma')
Ra = rhoS/rho; save('Ra.mat','Ra')