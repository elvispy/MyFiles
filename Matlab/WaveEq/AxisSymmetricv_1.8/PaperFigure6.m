% This script will summarize relevant information about pressure at contact
% points in the kinematic match.

close all; clearvars;
snapshots = 4; plot_video = false;


%% Plotting contact area

area = figure();
%title('Área presionada en función del tiempo', ...
%        'FontSize', 14, 'FontName', 'Cambria');

set(gca, ...
  'Box'         , 'on'      , ...
  'FontSize'    , 16        , ...
  'TickDir'     , 'in'      , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         , ...
  'XTick'       , 0:20:10000);
hold on;
Legends = cell(snapshots, 1);

figure(area); grid on; hold on;
%% Reading the file to be analyzed
% As of 04/01, we are using 
%simul27_0.795_1214 
%simul27_0.795_733
%simul27_0.795_5711
%simul27_0.795_5040
% in that order, in the paper

for ii = 1:snapshots
    [file, path] = uigetfile('*.mat', 'Select a File', ...
        'simulations\');
    fprintf('Used %s \n', file);
    load(fullfile(path, file), 'recordedPk', 'recordedTimes', 'rt', 'N', 'rS','Tm', 'mu', 'v_k');
    fprintf('U = %.5g \n\n', v_k/sqrt(Tm/mu));
    [mii, Ntot] = size(recordedPk);
    Tunit = rS/sqrt(Tm/mu);
    recordedTimes = recordedTimes/Tunit;
    rt = rt/Tunit; % Dimensionless recorded time
    Punit = Tm/rS;
    recordedPk = recordedPk/Punit;

    xAxis = linspace(0, 1, Ntot); YtickMax = (12/10) * max(recordedPk(:));


    carea = zeros(mii, 1);
    for jj = 1:mii
        carea(jj) = length(recordedPk(jj, abs(recordedPk(jj, :)) > 0.0001)) / Ntot;
    end

    plot([0; recordedTimes], [0; carea], ...
        'LineWidth'   , 2, ...
        'Color'       , [1 1 1] * (ii/4 - 0.1)); 
    U = abs(v_k/sqrt(Tm/mu));
    exponent = floor(log10(U));
    base = U * 10^abs(exponent);
    Legends{ii} = sprintf('$V_{0}/C = %.2f \\times 10^{%g} $', base, exponent);
end


xlim([-0.55, 150]);
ylim([0, 0.5]);
xlabel('$tC/R$', 'FontSize', 20, 'Interpreter', 'latex');
ylh = ylabel(gca, '$\frac{r_{c}}{R} $', 'FontSize', 24, ...
    'Rotation', 0, 'Interpreter', 'latex');
dy = 4.5;
ylh.Position(1) = ylh.Position(1) - dy;
a = gca;
a.Position(1) = a.Position(1) * 15/10;
legend(Legends, 'Location', 'NorthEast', 'FontSize', 12, 'Interpreter', 'latex');
print(area, '-depsc', '-r300', 'Graficos/contactArea2.eps');



