%% This file is the main file to control all parts 
clc;

%%Read the .tdms file (for now manually)

[ConvertedData,ConvertVer,ChanNames,GroupNames,ci]=convertTDMS(false);

[~, ~, signal] = ConvertedData.Data.MeasuredData.Data;

[archive_name, ID, ~, interruptor_name, inter, date] = ConvertedData.Data.Root.Property.Value;

%%Extracting the components via VMD

%Preliminar settings for the algorithm
alpha = 2000;        % moderate bandwidth constraint
tau = 0;            % noise-tolerance (no strict fidelity enforcement)
K = 6;              % 3 modes
DC = 0;             % no DC part imposed 
init = 1;           % initialize omegas uniformly
tol = 1e-10;        %Tolerance of the method in VMD
N = 1200;            %Number of iterations before getting out

[IMFS, ~, ~] = VMD(signal, alpha, tau, K, DC, init, tol, N);


%%Now Let's procede to the feature extraction via LSVD

