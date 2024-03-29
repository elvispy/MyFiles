
save_path = pwd;

cd D:\GITRepos\MyFiles\Matlab\WaveEq\'Other Scripts'\
plotter = @plotResults;

% filePaths = ["KM_vacuum_Tm70_experimental.csv", ...
%     "KM_vacuum_Tm70_uniform.csv", ...
%     "KM_vacuum_Tm99_experimental.csv", ...
%     "KM_vacuum_Tm107_experimental.csv", ...
%     "KM_vacuum_Tm115_experimental.csv", ...
%     "experimental_equivalents.csv"];
 filePaths = ["KM_vacuum_Tm70_experimental_rho793.csv", ...
     "KM_vacuum_Tm99_experimental_rho793.csv", ...
     "KM_vacuum_Tm107_experimental_rho793.csv", ...
     "KM_vacuum_Tm115_experimental_rho793.csv", ...
     "experimental_equivalents_rho793"];
%     "KM_vacuum_Tm99_experimental.csv", ...
%     "KM_vacuum_Tm107_experimental.csv", ...
%     "KM_vacuum_Tm115_experimental.csv", ...
%     "experimental_equivalents.csv"];
close all;
for ii = 1:length(filePaths)
    file = filePaths(ii);
    
    plotter(fullfile(save_path, file), 'velocities0203_rho793', 50*ii, true, save_path);
    
end

cd(save_path);