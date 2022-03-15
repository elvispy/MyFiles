clc
clear
close all

% load('r.mat')
% load('zs.mat','zs')
% load('Gamma.mat')
% load('wzero.mat')
% load('g.mat')
% load('thetaZero.mat')
% load('xdrop.mat')
% load('zdrop.mat')
% 
% load('z.mat')
% load('etaOri.mat')
% load('tvec.mat')
% 
% load('etaMatPer1.mat')
% etaMatPer1 = etaMatPer;
% load('etaMatPer2.mat')
% etaMatPer2 = etaMatPer;
% load('etaMatPer3.mat')
% etaMatPer3 = etaMatPer;
% load('etaMatPer4.mat')
% etaMatPer4 = etaMatPer;
% load('etaMatPer5.mat')
% etaMatPer5 = etaMatPer;
% load('etaMatPer6.mat')
% etaMatPer6 = etaMatPer;
% load('etaMatPer7.mat')
% etaMatPer7 = etaMatPer;
% 
% etaMatPer = [etaMatPer1,etaMatPer2,etaMatPer3,etaMatPer4,etaMatPer5,etaMatPer6,etaMatPer7];
%[file, path] = uigetfile('*.mat', 'Select a File', ...
%        'simulations\');
file = 'simul2_1_Mon185409.mat';
%file = 'simul27_0.795_1214.mat';
path = 'D:\GITRepos\MyFiles\Matlab\WaveEq\AxisSymmetricv_1.8\simulations\';
load(fullfile(path, file), 'recordedEta', 'recordedz_k', ...
    'recordedTimes', 'N', 'rt', 'rS');
dr = 1/N;
indexes = mod(recordedTimes + rt/2048, rt) < rt/1024;
recordedTimes = recordedTimes(indexes);
recordedEta = recordedEta(indexes, :)/rS;
recordedz_k = recordedz_k(indexes)/rS;
[ntimes, Ntot] = size(recordedEta);

%zplot = z;
%etaOriplot = etaOri;

zmin = min(recordedEta(:));
zmax = max(recordedEta(:));
%caxis([zmin zmax]);

vidObj = VideoWriter(replace(file, 'mat', 'mp4'),'MPEG-4');
set(vidObj,'Quality',100,'FrameRate',100)
open(vidObj);

%zb = g*Gamma/(wzero^2)*cos(wzero*tvec+thetaZero);
%zbplot=zb;

thetaplot = 0:pi/180:2*pi;
%Ntot = ceil(R_f * N);
TOTALPOINTS = min(10000, size(recordedEta, 2));
[rsurf,thetasurf] = meshgrid((0:(TOTALPOINTS-1))*dr,thetaplot);

% g = @(x) x/sqrt(1-x^2);
% thetadrop = 0:pi/180:pi;
% [rdropsurf,thetadropsurf] = meshgrid(xdrop,thetadrop);
%[zdropsurf,~] = meshgrid(zdrop,thetadrop);
[xdrop, ydrop, zdrop] = sphere(100);

thetaplot2 = 0:pi/1000:2*pi; nbOfCircles = 15;
[rsurf2,thetasurf2] = meshgrid(linspace(0, (TOTALPOINTS-1)*dr, nbOfCircles),thetaplot2);

thetaplot3 = (0:pi/5:2*pi) + pi/10; 
[rsurf3,thetasurf3] = meshgrid((0:(TOTALPOINTS-1))*dr,thetaplot3);

for ii = round(linspace(1, ntimes, 1000))
   
    [zsurf,~] = meshgrid(recordedEta(ii,1:TOTALPOINTS),thetaplot);
    
    %w = surf(rsurf.*cos(thetasurf),rsurf.*sin(thetasurf),zsurf,...
    %    'FaceColor',[.15 .25 .95],'LineStyle','none');%[.5 .5 1]
    %alpha(w, .4);
    %hold on;
    [zsurf2,~] = meshgrid(recordedEta(ii,round(linspace(1, TOTALPOINTS, nbOfCircles))),thetaplot2);
    circles = plot3(rsurf2.*cos(thetasurf2),rsurf2.*sin(thetasurf2),zsurf2,...
        'Color','b');%,'LineStyle','none');%[.5 .5 1]
    hold on;
    
    [zsurf3, ~] = meshgrid(recordedEta(ii, 1:TOTALPOINTS), thetaplot3);
    radialLines = plot3((rsurf3.*cos(thetasurf3))', (rsurf3.*sin(thetasurf3))', zsurf3', ...
        'Color', 'b');
    
    %     contour(rsurf.*cos(thetasurf),rsurf.*sin(thetasurf),zbplot(ii)+zsurf)
    axis equal
    axis off
    grid on
    d = surf(xdrop, ydrop, zdrop + recordedz_k(ii),...
        'LineStyle','none','FaceColor',[0 .85 .25]);
    alpha(d, .6);

%     hold on
%     grid on
%     set(gca,'xlim',[-1 1],'ylim',[-.2 .5],'FontName','Times','FontSize',24);
%     xlabel('   x[mm]   ','FontName','Times','FontSize',24)
%     ylabel('   y [mm]   ','FontName','Times','FontSize',24)
%     t = (ii-1)/360;
%     to = floor(t);
%     t1 = floor(10*(t-to));
%     t2 = round(100*(t-to-t1/10));
%     if t2 == 10
%         t2=0;
%         t1=t1+1;
%     end
%     if t1 == 10
%         t1 = 0;
%         to = to+1;
%     end
%     title(['   t/T_f = ',num2str(to),'.',num2str(t1),num2str(t2)],'FontName','Times','FontSize',24)
    
    luz  = light('Position',[0 0 100],'style','local');
%     luz1 = light('Position',[-10   0 .1])%,'style','local')
    luz2 = light('Position',[-100 0 25]);%,'style','local');
%     luz3 = light('Position',.2*[-12 -.3 .4],'style','local')
%     luz4 = light('Position',.2*[-12 -.4 .4],'style','local')
%     luz5 = light('Position',.2*[-12 -.5 .4],'style','local')
    material shiny;%([0 0 1])
%     Camera([5, 5, 5], [0, 0, 0], PI/4):
%     for xx = -10:10
%         for yy = -10:10
%             for zz = -10:10
%                 campos([xx, yy, zz]*10);
%                 camtarget([0 0 .05])
%                 pause(0.05);
%             end
%         end
%     end
    campos([14 0 4]*10)
    camtarget([0 0 .05])
    camzoom(3)
    %camva(pi)
    %view(105, 19);

    drawnow
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);
    hold off;

end
close(vidObj);






