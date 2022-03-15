%%%%
% This script will select a file and reproduce a video out of a sequence of
% plots
%%%%
clear variables; close all;

% Using simul1_1_859
%% Reading the file to be analyzed
myDir = uigetdir(pwd, 'Select a folder to loop trough');
cd(myDir);
myFiles = dir(fullfile(myDir, '*.mat'));
for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    load(fullFileName, 'recordedEta', 'recordedz_k', ...
        'mu', 'Tm', 'recordedTimes', 'N', 'rS', 'cTime', 'v_k');
    Lunit = rS;
    Vunit = sqrt(Tm/mu);
    Tunit = Lunit/Vunit;

    Etas = recordedEta(:, 1);%/Lunit;
    %recordedTimes = recordedTimes;/Tunit;%(0:(length(Etas)-1))*rt/Tunit;
    %% Plot Settings
    close all; 
    myFigure = figure(1);
    myFigure.Position = [388, 242, 680, 400]; 
    hold on; grid on; 
    %xlim([-width*rS/N, width*rS/N]);

    set(gca, ...
          'Box'         , 'on'     , ...
          'FontSize'    , 16        , ...
          'TickDir'     , 'in'     , ...
          'TickLength'  , [.02 .02] , ...
          'XMinorTick'  , 'off'      , ...
          'YMinorTick'  , 'on'      , ...
          'XColor'      , [.3 .3 .3], ...
          'YColor'      , [.3 .3 .3], ...
          'YTick'       , -floor(5 * Lunit):.1:ceil(5*Lunit));
      xlabel('$t (ms)$', 'Interpreter', 'latex');
      ylabel('$z (mm)$', 'Interpreter', 'latex', 'Rotation', 90, ...
          'FontSize', 24);
    lim = min(12000, length(Etas));
    ymin = min(Etas(1:lim)); ymax = max(recordedz_k(1:lim) - Lunit);
    xmin = 0; xmax = recordedTimes(end);
    xlim([xmin-(xmax-xmin)/10,  xmax+(xmax-xmin)/10]);
    ylim([ymin-(ymax-ymin)/10,  ymax+(ymax-ymin)/10]);

    plot(recordedTimes(1:lim), recordedz_k(1:lim)- Lunit, 'Color', [.2 .2 .2], 'LineWidth', 6);
    plot(recordedTimes(1:lim), Etas(1:lim), 'color',[.7, .7, .7], 'LineWidth', 2); 
    if cTime > 6.5
        rho = 7.93;
    else
        rho = 3.25;
    end
    title(sprintf("South pole trajectory of the sphere and center of the membrane for \n $ R = %3.4g $(mm), $T = %4.4g $ N/m, $\\rho = %3.4g $(g/cm3), $v_i = %4.9g \\ m/s$", ...
        rS, Tm, rho, v_k), 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
    baseOutputName = replace(baseFileName, ".mat", "");
    baseOutputName = sprintf("%s_vi%3.6g_mu%3.3g", baseOutputName, v_k, rho);
    mkdir SouthPoleTrajectories Graficos
    saveas(myFigure, sprintf('SouthPoleTrajectories/Graficos/%s.fig', baseOutputName));
    mkdir SouthPoleTrajectories MatFiles
    save(fullfile(pwd, sprintf('SouthPoleTrajectories/MatFiles/%s.mat', baseOutputName)), 'recordedTimes', 'Etas', 'rS', 'mu', 'Tm', "v_k");
    
    %print(myFigure, '-depsc', '-r300', sprintf('Graficos/%s', replace(file, ".mat", ".eps"));
end