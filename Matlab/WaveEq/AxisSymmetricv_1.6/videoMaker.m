%%%%
% This script will select a file and reproduce a video out of a sequence of
% plots
%%%%
clear variables;
export_video = true; % if you want to export an .avi file out of this script


%% Reading the file to be analyzed
[file, path] = uigetfile('*.mat', 'Select a File', ...
    'simulations\');
load(fullfile(path, file), 'recordedEta', 'recordedz_k', 'rt', 'N', 'rS');
width = 3 * N;
xplot = linspace(0, width/N, width) * rS;

v = VideoWriter(fullfile(path, strrep(file, '.mat', '.avi')));
open(v);

%% Plot Settings
figure(1);
hold on; grid on;
xlim([-width*rS/N, width*rS/N]);
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
xlabel('Distancia del centro (mm)', ...
    'FontSize',15, 'FontWeight', 'bold', ...
    'FontName', 'Cambria', 'interpreter', 'latex');
ylabel('Distancia vertical del centro (mm)', ...
    'FontSize', 16, 'FontWeight', 'bold', ...
    'FontName', 'Cambria', 'interpreter', 'latex');

%% Recording
for ii = 1:size(recordedEta, 1)
    z_k = recordedz_k(ii);
    Eta_k = recordedEta(ii, :);
    %PLOT RESULTS
    cla;
    ylim([z_k-2 * rS, z_k+2*rS]); axis equal;
    ball = rectangle('Position', [-rS, (z_k-rS), 2*rS, 2*rS], ...
        'Curvature', 1, 'Linewidth', 2);
    
    membrane = plot([-fliplr(xplot(2:end)),xplot],[fliplr(Eta_k(2:width)),Eta_k(1:width)],'LineWidth',2);
    title(sprintf('t = %5.2f ms', rt*ii), 'interpreter', 'latex', ...
        'FontSize',16, 'FontName', 'Cambria Math');
    drawnow;
    
    writeVideo(v, getframe(gcf));
end

close(v);