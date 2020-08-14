clear
clc
close all

load('U0.mat','U0')
load('Ang.mat')

cd ..
load('Ro.mat','Ro')

cd ..
load('rhoS.mat')

cd ..
load('rho.mat','rho')
load('sigma.mat','sigma')
load('g.mat','g')
load('nu.mat')
load('muair.mat')

cd ..
load('nr.mat')
load('dr.mat')

cd(['rho',num2str(1000*rho),'sigma',num2str(round(100*sigma)),'nu',num2str(round(10000*nu)),'muair',num2str(muair)])

if rhoS < 1
    cd(['RhoS0',num2str(1000*rhoS)])
else
    cd(['RhoS',num2str(1000*rhoS)])
end

if Ro <.1
    cd(['Ro0',num2str(10000*Ro),'mm'])
else
    cd(['Ro',num2str(10000*Ro),'mm'])
end

cd(['U',num2str(U0),'Ang',num2str(Ang)])
load('tvec.mat','tvec')
load('numl.mat','numl')
load('z.mat','z')
load('vz.mat')
load('etaOri.mat','etaOri')
load('tend.mat')

last = tend+1;

etaAux = [];
for ii = 1:last
    load(['etaMatPer',num2str(ii),'.mat'])
    etaAux = [etaAux,etaMatPer];
end
etaMatPer = etaAux;
clear etaAux

maxdrEta = 0;
drEta = (etaMatPer(2:end,:)-etaMatPer(1:end-1,:))/dr;
for ii = 1:size(drEta,2)
    if max(drEta(:,ii)) > maxdrEta
        maxdrEta = max(drEta(:,ii));
    end
end
maxdrEta
save('maxdrEta.mat','maxdrEta')

ntimes = size(etaMatPer,2);

zmin = min(min(etaMatPer));
zmax = max(max(z));

npower = 8;
thetaS = 0:2*pi/(2^npower):2*pi;
zS = sin(thetaS);
rS = cos(thetaS);

%Finding the profile at min
[~,indexOfMin] = min(z);
profOfMin = etaMatPer(:,indexOfMin);
save('profOfMin.mat','profOfMin')

vidObj = VideoWriter('WavesAndSphere2D.mp4','MPEG-4');
set(vidObj,'Quality',100,'FrameRate',100)
open(vidObj);

% for ii = 1:size(etaMatPer,2)
%     plot(rS,1+zS+z(ii),'k','LineWidth',2) 
%     hold on
%     plot(dr*(-nr+1:nr-1),[etaMatPer(end:-1:2,ii);etaMatPer(:,ii)],'LineWidth',2)
%     axis equal
%     grid on
%     set(gca,'xlim',[-4 4],'ylim',[1.1*zmin 1.1*(zmax+2)],'FontName','Times','FontSize',16);
%     xlabel('   $r/R_o$   ','interpreter','latex','FontName','Times','FontSize',16)
%     ylabel('   $\frac{z}{R_o}\ \ $   ','interpreter','latex','FontName','Times','FontSize',24,'rotation',0)
%     title(['$R_0\, =\ $',num2str(round(10000*Ro)/1000),'$\, mm$, $\rho_s\, =\ $',num2str(rhoS),...
%         '$\, gr/cm^3$, $V_0\, =\ $',num2str(U0),'$\, cm/s$'],'interpreter','LaTeX','FontSize',20)
%     
%     drawnow
%     currFrame = getframe(gcf);
%     writeVideo(vidObj,currFrame);
%     hold off
% 
% end
% close(vidObj);






