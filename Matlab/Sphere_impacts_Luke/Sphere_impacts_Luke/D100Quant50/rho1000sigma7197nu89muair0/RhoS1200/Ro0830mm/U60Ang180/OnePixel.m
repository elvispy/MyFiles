clear
clc
close all

load('tvec.mat','tvec')
load('U0.mat','U0')
load('numl.mat','numl')
load('Ang.mat')
cd ..
load('Ro.mat','Ro')
cd ..
load('rhoS.mat')
cd ..
load('g.mat','g')
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

load('Fr.mat','Fr')
load('z.mat','z')
load('vz.mat')
load('etaOri.mat','etaOri')
load('tend.mat')

fi = figure;

% load('ModelComparison_Data_1aU1.dat')
% MatRadu = ModelComparison_Data_1aU1;
% tRadu = MatRadu(:,1)*U0/Ro; %Radu's times in dimensionless form
% zNorthRadu = MatRadu(:,2)/(10*Ro); %Radu's North Pole location in dimensioless form
% zCoMRadu = MatRadu(:,3)/(10*Ro); %Radu's CoM location in dimensioless form
% zSouthRadu = MatRadu(:,4)/(10*Ro); %Radu's South pole location in dimensioless form
% etaOriRadu = MatRadu(:,5)/(10*Ro); %Radu's fluid under south pole location in dimensioless form
% 
% indaux = find(zCoMRadu<1,1);
% t1 = tRadu(indaux);
% t0 = tRadu(indaux-1);
% z1 = zCoMRadu(indaux);
% z0 = zCoMRadu(indaux-1);
% delt = (z0-1)*(t1-t0)/(z0-z1);
% tshiftRadu = t0+delt;
% 
% hold on
% plot(tRadu-tshiftRadu,etaOriRadu,'--','color',[0 0 1],'LineWidth',2)
% plot(tRadu-tshiftRadu,zSouthRadu,'--','color',[ 0.4660    0.6740    0.1880],'LineWidth',2)
% plot(tRadu-tshiftRadu,zCoMRadu,'--','color',[0 0 0],'LineWidth',2)
% plot(tRadu-tshiftRadu,zNorthRadu,'--','color',[1 0 0],'LineWidth',2)

indaux = find(z<0,1);
t1 = tvec(indaux);
t0 = tvec(indaux-1);
z1 = z(indaux);
z0 = z(indaux-1);
delt = z0*(t1-t0)/(z0-z1);
tshift = t0+delt;

FreeSurf = plot(tvec(1:length(etaOri))-tshift,etaOri,'color',[0 0 1],'LineWidth',2)
hold on
South = plot(tvec(1:length(z))-tshift,z,'color',[ 0.4660    0.6740    0.1880],'LineWidth',2)

Center = plot(tvec(1:length(z))-tshift,z+1,'k','LineWidth',2)
North = plot(tvec(1:length(z))-tshift,z+2,'color',[ 1 0 0],'LineWidth',2)
set(gca,'FontSize',16,'xlim',[0 tend],'ylim',[1.1*min(min(z)) 1.1*(max(max(z))+2)])
xlabel('   $tV_0/R_o $   ','interpreter','LaTeX','FontSize',24)
ylabel('   $\frac{z}{R_o}\ \ \ $    ','interpreter','LaTeX','FontSize',32,'Rotation',0)
% plot(tvec(1:length(numl))-tshift,numl/10)
title(['$R_0\, =\ $',num2str(round(10000*Ro)/1000),'$\, mm$, $\rho_s\, =\ $',num2str(rhoS),'$\, gr/cm^3$, $V_0\, =\ $',num2str(U0),'$\, cm/s$'],'interpreter','LaTeX','FontSize',20)
legend([North,Center,South,FreeSurf],...%'Free surface (DNS)','South pole (DNS)','Centre of mass (DNS)','North pole (DNS)',...
    'North pole (KM)','Centre of mass (KM)','South pole (KM)','Free surface (KM)','location','NorthEast')% daspect([.83 .73/5 1])
grid on
% %
saveas(gcf,['CenterLineRadius',num2str(10*Ro),'mmRho',num2str(rhoS),'U',num2str(U0),'.fig'],'fig')
print(fi,'-depsc','-r300',['CenterLineRadius',num2str(10*Ro),'mmRho',num2str(rhoS),'U',num2str(U0),'.eps'])

index1 = find(z>0,1);
index2 = find(z-etaOri>2*eps,1);

tendBounce = (tvec(index1)+tvec(index1-1))/2;save('tendBounce.mat','tendBounce')
tendBounceReal = (tvec(index2)+tvec(index2-1))/2;save('tendBounceReal.mat','tendBounceReal')
Uend = (vz(index1)+vz(index1-1))/2;save('Uend.mat','Uend')
UendReal = (vz(index2)+vz(index2-1))/2;save('UendReal.mat','UendReal')
CRref = -Uend/U0; save('CRref.mat','CRref')
CR2Real = (UendReal.^2+(z(index2)+z(index2-1))/Fr)/U0^2;
save('CR2Real.mat','CR2Real')
pDepth = abs(min(z)); save('pDepth.mat','pDepth')
pDepthReal = abs(min(etaOri)); save('pDepthReal.mat','pDepthReal')
