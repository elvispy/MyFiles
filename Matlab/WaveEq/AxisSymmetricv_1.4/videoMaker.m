%%%%
% This script will select a file and reproduce a video out of a sequence of
% plots
%%%%
clear variables;
export_video = true;

[file, path] = uigetfile('*.mat', 'Select a File', ...
    'simulations\');
load(fullfile(path, file), 'recordedEta', 'recordedz_k', 'rt', 'N', 'rS');
width = 3 * N;
xplot = linspace(0, width/N, width) * rS;

v = VideoWriter(fullfile(path, strrep(file, '.mat', '.avi')));
open(v);

%% Plot Settings
figure(1);
hold on;
xlim([-width*rS/N, width*rS/N]);


%% Recording
for ii = 1:size(recordedEta, 1)
    z_k = recordedz_k(ii);
    Eta_k = recordedEta(ii, :);
    %PLOT RESULTS
    cla;
    ylim([z_k-2 * rS, z_k+2*rS]);
    rectangle('Position', [-rS, (z_k-rS), 2*rS, 2*rS], ...
        'Curvature', 1, 'Linewidth', 2);
    
    axis equal;

    plot([-fliplr(xplot(2:end)),xplot],[fliplr(Eta_k(2:width)),Eta_k(1:width)],'LineWidth',2);
    quiver([-fliplr(xplot(2:end)), xplot] , [fliplr(Eta_k(2:width)),Eta_k(1:width)],...
                zeros(1,2*width-1), [flipud(u_k(2:width));u_k(1:width)]');
%     title(['   t = ',sprintf('%0.2f (ms)', t*Tunit),'   ','nl = ', ...
%         sprintf('%.0f', cPoints),' vz = ', sprintf('%0.5f (mm/ms)', v_k*Vunit)],'FontSize',16);
    drawnow;
    
    writeVideo(v, getframe(gcf));
end

close(v);