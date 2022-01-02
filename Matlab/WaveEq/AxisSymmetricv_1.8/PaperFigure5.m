%Plotter to see stored data

close all;
[file, path] = uigetfile('*.*', 'Seleccionar el historial', 'simulations\');
if isequal(file, 0)
    return;
else
    values = readtable(fullfile(path, file), 'PreserveVariableNames', true);
end
values = values(:, {'ID', 'surfaceTension', 'radius'});

%% Settings of radii to be plotted
symbol = {'o'; '>'; 's'; '>'; 'x'; 'v'; '+'; '<'; 'v'; 'p'; '^'; 'p'; 'h'; 'v'; 'd'; '+'};

cats = {0.35; 0.5; 0.795; 0.85; 0.9; 0.95; 0.995; 1.15; 1.25; 1.35; 1.75; 2; 2.38; 2.78; 3; 3.175};
configs = struct('radius', cats, 'symbols', symbol);
LL = length(configs);


%% Coefficient of restitution

figureCoefOfRestitution = figure(1);
set(gcf,'position',[100, 100, 560, 420], 'Units', 'pixels');

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
  'XTick'       , 0:0.25:2  , ...
  'LineWidth'   , 1         );
hold on; grid on;
xlim([0 1.45]);
ylim([0.6, 1.05]);
xlabel('$ V_{i} $', 'Interpreter', 'latex', 'FontSize', 24);
ylabel('$\alpha\ \ \ \ $', 'Interpreter', 'latex', 'Rotation', 0, ...
      'FontSize', 24);




for ii = 1:height(values)
    load(fullfile("simulations", sprintf("simul%g_%g_%d.mat", values{ii, 'surfaceTension'}, ...
        values{ii, 'radius'}, values{ii, 'ID'})),...
        'coefOfRestitution', 'v_k', 'rS', 'Tm', 'mu');

    v_k = abs(v_k); 
    A = scatter(v_k, sqrt(coefOfRestitution), ...
        'filled', 'black');   
    for jj = 1:length(cats)
        if abs(rS - cats{jj}) < 0.01
            break;
        end
    end
    %jj = mod(mod(ceil(1e+7 * rS), 2011), 10)+1; % le asignamos un marker al azar
    set(A                               , ...
        'LineWidth'       , 1.2         , ...
        'SizeData'        , 75         , ...
        'MarkerEdgeColor' , [.2 .2 .2]     , ...
        'MarkerFaceColor' , [.7 .7 .7] , ... %[.1+rS/3.5 .1+rS/3.5 .1+rS/3.5]     , ...
        'Marker'          , configs(jj).symbols ); 
    
end

% a = gca;
% xx = a.XLim;
% yy = a.YLim;
% xrange = (xx(2) - xx(1))/10;
% yrange = (yy(2) - yy(1))/10;
% xx(1) = xx(1) - xrange;
% xx(2) = xx(2) + xrange;
% yy(1) = yy(1) - yrange;
% yy(2) = yy(2) + yrange;
% a.XLim = xx;
% a.YLim = yy;
%tt = text(.05, 2.75, '$a)$', 'Interpreter', 'latex', 'FontSize', 16);
print(figureCoefOfRestitution, '-depsc', '-r300', 'Graficos/coefOfRestitutionNew.eps');
