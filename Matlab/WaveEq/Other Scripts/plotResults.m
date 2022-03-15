function plotResults(fileExp, NAME, DATA_SIZE, export, savePath, TH)
    %Plotter to see stored data

     %% Handling default values
    arguments
       fileExp (1, 1) string = '' % Pointing to the place where data lies
       NAME (1, 1) string = '' % Output file identifiers
       DATA_SIZE (1, 1) {mustBePositive} = 100 % Markers data size
       export (1, 1) logical = false % Whether to export figures or not
       savePath (1, 1) string = pwd
       TH (1, 1) {mustBePositive} = 5; % Density treshold
    end
    
    % Usual file paths
    %pathExp = "D:\GITRepos\MyFiles\Matlab\WaveEq\AxisSymmetricv_1.8\DanSimulations\simulations\";
    %fileExp = "..\simulations\newMembraneVacuumHighLowTensions\simulations\KM_vacuum_highTension.csv";
    %fileExp = "..\simulations\newMembraneInVacuum\simulations\simulationDan_air_vacuum.csv";
    %fileExp = "..\simulations\DanSimulations_membrane1402\simulations\simulationDan_air_new.csv";
    if isequal(fileExp, 0)
        disp("Could not find your .csv file!")
        return;
    else
        valuesExp = readtable(fullfile( fileExp), 'PreserveVariableNames', true);
        exist = strcmp("labcTime", valuesExp.Properties.VariableNames);
        if exist(exist == 1)
            valuesExp{:, "cTime"} = valuesExp{:, "labcTime"};
            valuesExp{:, 'coefOfRestitution'} = valuesExp{:, "labcoefOfRestitution"};
        end
        % Lets discretize radius, tension, density
        valuesExp{:, "radiusDiscretized"} = discretize_points([0.1, 4], valuesExp{:, "radius"}); presentRadii = unique(valuesExp{:, "radiusDiscretized"});
        valuesExp{:, "tensionDiscretized"} = discretize_points([60, 120], valuesExp{:, "surfaceTension"}); presentTension = unique(valuesExp{:, "tensionDiscretized"});
        valuesExp{:, "densityDiscretized"} = discretize_points([1, 10], valuesExp{:, "Density"}); presentDensity = unique(valuesExp{:, "densityDiscretized"});
        valuesExp{:, "colorIdentifier"} = discretize_points([60, 120], valuesExp{:, "surfaceTension"}, ...
            [3, 8], valuesExp{:, "Density"}); 
        %disp(valuesExp{:, "colorIdentifier"});
        if isfile('colors.mat')
            load('colors.mat', 'colorMatrix');
        else
            colorMatrix = distinguishable_colors(600);
            save('colors.mat', 'colorMatrix');
        end
        
        %disp(valuesExp{:, "cTime"});
        %valuesExp{1:end, 'Density'} = 10 * rand(28, 1);
    end


    %% Plot settings for every radii
    symbol = {'o'; '>'; 's'; '<'; '^'; 'p'; 's'; 'v'; 'd'; '+'; "p"};
    catsList = [0.35; 0.5; 0.795; 1.25; 1.75; 2; 2.38; 2.78; 3; 3.175; 3.18/2];
    catsList = discretize_points([0.1, 4], catsList);
    cats = {0.35; 0.5; 0.795; 1.25; 1.75; 2; 2.38; 2.78; 3; 3.175; 3.18/2};
    configs = struct('radius', cats, 'symbols', symbol);
    LL = length(configs);


    %% PLOTTING CONTACT TIME

    figurectime = figure(1);
    set(gcf,'position',[100, 50, 600, 420]);% , 'Units', 'pixels');

    % NUMERICAL DATA, MAXIMUM TENSION
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
        'XTick'       , -0.2:0.1:2, ...
        'LineWidth'   , 1         );
    
    hold on; grid on;
    %previousLegends = get(gca, "children"); previousLegends = get(previousLegends, "DisplayName");
    %xlim([45, 1.2]);
    xlabel('$V_{0} \ (ms^{-1})$', 'Interpreter', 'latex', 'FontSize', 20);
    ylabel('$t_{c} \ (ms) $', 'Interpreter', 'latex', 'Rotation', 90, ...
        'FontSize', 20);
    ylim([-5, 12]);
    xlim([.25, .85]);


    FExp = cell(2*LL+6, 1);
    for ii = 1:length(presentRadii)
       for jj = 1:length(presentTension)
           for kk = 1:length(presentDensity)
               auxtbl = valuesExp(and(valuesExp.radiusDiscretized == presentRadii(ii), ...
                   and(valuesExp.tensionDiscretized == presentTension(jj), ...
                   valuesExp.densityDiscretized == presentDensity(kk))), :);
               if isempty(auxtbl) == false
                   FExp{2*ii} = scatter(abs(auxtbl{:, 'vi'}), auxtbl{:, 'cTime'}, ...
                       [], colorMatrix(auxtbl.colorIdentifier, :));
                   
                   currentMarker = symbol{catsList == auxtbl{1, "radiusDiscretized"}};
                   if isnan(auxtbl{1, "surfaceTension"})
                       displaystring = sprintf('$R = %6.3g$ mm, $\\rho = %6.3g$ g/cm3 (Experimental)',...
                           currentMarker, auxtbl{1, "Density"});
                   else
                       displaystring = sprintf('$R = %6.3g$ mm, $\\rho = %6.3g$ g/cm3, $T = %6.3g$ N/m',...
                           currentMarker, auxtbl{1, "Density"}, auxtbl{1, "surfaceTension"});
                   end
                   set(FExp{2*ii}                        , ...
                       'LineWidth'       , 2             , ...
                       'SizeData'        , DATA_SIZE     , ...
                       'DisplayName'     , displaystring , ...
                       'Marker'          , currentMarker );
               end
           end % First for end
       end % Second for end
    end % Third for end

    %FExp = FExp(~cellfun(@isempty,FExp));
    %FExp = [previousLegends(end:-1:1); FExp];
    legend('Location', 'SouthWest', 'FontSize', 13, 'Interpreter', 'latex');
    %tt = text(.05, 16.85, '$a)$', 'Interpreter', 'latex', 'FontSize', 16);
    if export == true
        print(figurectime, '-depsc', '-r300', fullfile(savePath, sprintf('ContactTime_%s.png', NAME)));
        saveas(figurectime, fullfile(savePath, sprintf('ContactTime_%s.png', NAME)));
    end
    %% MAXIMUM DEFLECTION

    figureDef = figure(2);
    set(gcf,'position',[700, 50, 600, 420], 'Units', 'pixels');

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
        'XTick'       , -0.2:0.1:2, ...
        'LineWidth'   , 1         );
    hold on; grid on;
    %previousLegends = get(gca, "children"); previousLegends = get(previousLegends, "DisplayName");
    %xlim([0, 1.35]);
    xlabel('$V_{0} \ (ms^{-1})$', 'Interpreter', 'latex', 'FontSize', 20);
    ylabel('$\delta \  (mm) $', 'Interpreter', 'latex', 'Rotation', 90, ...
        'FontSize', 20);
    ylim([0, 4]);
    xlim([.25, .85]);

    FExp = cell(2*LL+3, 1);
    for ii = 1:length(presentRadii)
       for jj = 1:length(presentTension)
           for kk = 1:length(presentDensity)
               auxtbl = valuesExp(and(valuesExp.radiusDiscretized == presentRadii(ii), ...
                   and(valuesExp.tensionDiscretized == presentTension(jj), ...
                   valuesExp.densityDiscretized == presentDensity(kk))), :);
               if isempty(auxtbl) == false
                   FExp{2*ii} = scatter(abs(auxtbl{:, 'vi'}), auxtbl{:, 'maxDeflection'}, ...
                       [], colorMatrix(auxtbl.colorIdentifier, :));
                   
                   currentMarker = symbol{catsList == auxtbl{1, "radiusDiscretized"}};
                   if isnan(auxtbl{1, "surfaceTension"})
                       displaystring = sprintf('$R = %6.3g$ mm, $\\rho = %6.3g$ g/cm3 (Experimental)',...
                           currentMarker, auxtbl{1, "Density"});
                   else
                       displaystring = sprintf('$R = %6.3g$ mm, $\\rho = %6.3g$ g/cm3, $T = %6.3g$ N/m',...
                           currentMarker, auxtbl{1, "Density"}, auxtbl{1, "surfaceTension"});
                   end
                   set(FExp{2*ii}                        , ...
                       'LineWidth'       , 2             , ...
                       'SizeData'        , DATA_SIZE     , ...
                       'DisplayName'     , displaystring , ...
                       'Marker'          , currentMarker );
               end
           end % First for end
       end % Second for end
    end % Third for end
    
    legend('Location', 'NorthWest', 'FontSize', 12, 'Interpreter', 'latex');
    %tt = text(.06, 5.5, '$b)$', 'Interpreter', 'latex', 'FontSize', 16);
    if export == true
        print(figureDef, '-depsc', '-r300', fullfile(savePath, sprintf('MaximumDeflection_%s.eps', NAME)));
        saveas(figureDef, fullfile(savePath, sprintf('MaximumDeflection_%s.png', NAME)));
    end
    
    %% COEF Of Restitution

    figureCoef = figure(3);
    set(gcf,'position',[350, 380, 600, 420], 'Units', 'pixels');

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
        'XTick'       , -0.2:0.1:2, ...
        'LineWidth'   , 1         );
    hold on; grid on;
    %previousLegends = get(gca, "children"); previousLegends = get(previousLegends, "DisplayName");
    %xlim([0, 1.35]);
    xlabel('$V_{0} \ (ms^{-1})$', 'Interpreter', 'latex', 'FontSize', 20);
    ylabel('$\alpha $', 'Interpreter', 'latex', 'Rotation', 0, ...
        'FontSize', 20);
    ylim([-.15, 1]);
    xlim([.25, .85]);

    FExp = cell(2*LL+3, 1);
    for ii = 1:length(presentRadii)
       for jj = 1:length(presentTension)
           for kk = 1:length(presentDensity)
               auxtbl = valuesExp(and(valuesExp.radiusDiscretized == presentRadii(ii), ...
                   and(valuesExp.tensionDiscretized == presentTension(jj), ...
                   valuesExp.densityDiscretized == presentDensity(kk))), :);
               if isempty(auxtbl) == false
                   FExp{2*ii} = scatter(abs(auxtbl{:, 'vi'}), auxtbl{:, 'coefOfRestitution'}, ...
                       [], colorMatrix(auxtbl.colorIdentifier, :));
                   
                   currentMarker = symbol{catsList == auxtbl{1, "radiusDiscretized"}};
                   if isnan(auxtbl{1, "surfaceTension"})
                       displaystring = sprintf('$R = %6.3g$ mm, $\\rho = %6.3g$ g/cm3 (Experimental)',...
                           currentMarker, auxtbl{1, "Density"});
                   else
                       displaystring = sprintf('$R = %6.3g$ mm, $\\rho = %6.3g$ g/cm3, $T = %6.3g$ N/m',...
                           currentMarker, auxtbl{1, "Density"}, auxtbl{1, "surfaceTension"});
                   end
                   set(FExp{2*ii}                        , ...
                       'LineWidth'       , 2             , ...
                       'SizeData'        , DATA_SIZE     , ...
                       'DisplayName'     , displaystring , ...
                       'Marker'          , currentMarker );
               end
           end % First for end
       end % Second for end
    end % Third for end
    
  
    legend('Location', 'SouthWest', 'FontSize', 12, 'Interpreter', 'latex');
    A = gca;
    A.Position(1) = 0.18;
    A.YLabel.Position(1) = A.YLabel.Position(1) - 0.01;

    %tt = text(.06, 5.5, '$b)$', 'Interpreter', 'latex', 'FontSize', 16);
    if export == true
        print(figureCoef, '-depsc', '-r300', fullfile(savePath, sprintf('CoefOfRestitution_%s.eps', NAME)));
        saveas(figureCoef, fullfile(savePath, sprintf('CoefOfRestitution_%s.png', NAME)));
    end
end


function cats = discretize_points(varargin)
    nb = length(varargin{2});
    identifier = zeros(nb, 1);
    for ii = 1:nargin
        if mod(ii, 2) == 1
            if length(varargin{ii}) ~= 2
                error("Not valid interval!");
            else
                xmin = varargin{ii}; xmax = xmin(2); xmin = xmin(1);
            end
        else
            if isnan(varargin{ii}(1))
                varargin{ii} = xmin * ones(nb, 1);
            end
            discretization = 10^((ii-2)/2) * discretize([varargin{ii}; linspace(xmin, xmax, 20)'], 20);
            identifier = discretization(1:nb) + identifier;
        end
    end
    %[~, ~, cats] = unique(identifier, 'sorted');
    cats = identifier;
end
