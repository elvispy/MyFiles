%%%%
% This script will select a file and reproduce a video out of a sequence of
% plots
%%%%
clear variables;
export_video = true; % if you want to export an .avi file out of this script


%% Reading the file to be analyzed
[file, path] = uigetfile('*.mat', 'Select a File', ...
    '..\AxisSymmetricv_1.8\simulations\');
load(fullfile(path, file), 'recordedEta', 'recordedu_k', 'recordedz_k', ...
    'mu', 'Tm', 'rt', 'N', 'rS');
Lunit = rS;
Vunit = sqrt(Tm/mu);

width = 3 * N;
xplot = linspace(0, width/N, width);
EtaX = [-fliplr(xplot(2:end)), xplot] * Lunit;
EtaU = zeros(1, 2*width - 1);
step = ceil(N/15);



v = VideoWriter(fullfile(path, strrep(file, '.mat', '.avi')));
open(v);

%% Plot Settings
figure(1);
hold on; grid on; 
xlim([-width*rS/N, width*rS/N]);
axis equal;
set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.02 .02] , ...
      'XMinorTick'  , 'on'      , ...
      'YMinorTick'  , 'on'      , ...
      'YGrid'       , 'on'      , ...
      'XColor'      , [.3 .3 .3], ...
      'YColor'      , [.3 .3 .3], ...
      'YTick'       , -5*rS:rS:5*rS    , ...
      'XTick'       ,  -width*rS/N:rS:width*rS/N , ...
      'LineWidth'   , 1         );
% xlabel('Distancia del centro (mm)', ...
%     'FontSize',15, 'FontWeight', 'bold', ...
%     'FontName', 'Cambria', 'interpreter', 'latex');
% ylabel('Distancia vertical del centro (mm)', ...
%     'FontSize', 16, 'FontWeight', 'bold', ...
%     'FontName', 'Cambria', 'interpreter', 'latex');
cVar = false;
%% Recording
for ii = 1:10:size(recordedEta, 1)
    z_k = recordedz_k(ii);
    Eta_k = recordedEta(ii, :);
    u_k = recordedu_k(ii, :);
    
    %PLOT RESULTS
    cla;
    ylim([z_k-2 * rS, z_k+2*rS]); 
    ball = rectangle('Position', [-rS, (z_k-rS), 2*rS, 2*rS], ...
        'Curvature', 1, 'Linewidth', 2);
    
    plot([-width*Lunit/N, width*Lunit/N], [0, 0], '--', 'Color', [.8 .8 .8], 'LineWidth', 2.5);
    EtaY = [Eta_k(width:-1:2), Eta_k(1:width)];
    EtaV = [  u_k(width:-1:2), u_k(1:width)];
    plot(EtaX,EtaY,'LineWidth',2);
    if cVar == false
        quiver(EtaX(1:step:end), EtaY(1:step:end), EtaU(1:step:end), EtaV(1:step:end), 0);
    else
        quiver(EtaX(1:step:end), EtaY(1:step:end), EtaU(1:step:end), EtaV(1:step:end));
    end
    if Eta_k(1) + rS == z_k
        cVar = true;
    end
    
    title(sprintf('t = %5.2f ms', rt*ii), 'interpreter', 'latex', ...
        'FontSize',16, 'FontName', 'Cambria Math');
    drawnow;
    
    writeVideo(v, getframe(gcf));
end

close(v);