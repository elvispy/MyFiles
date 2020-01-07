%% This file is the main file to control all parts
clc;

%First we set a dictionary of faults
faults = [];

%%Read the .tdms file (for now manually)

[ConvertedData,ConvertVer,ChanNames,GroupNames,ci]=convertTDMS(false);

[~, ~, signal] = ConvertedData.Data.MeasuredData.Data;

[archive_name, ~, ~, ~, inter, ~] = ConvertedData.Data.Root.Property.Value;
archive_name = cell2mat(archive_name);
%BEWARE OF THE ID


%%
%Extracting the components via VMD

%Preliminar settings for the algorithm
alpha = 2000;        % moderate bandwidth constraint
tau = 0;            % noise-tolerance (no strict fidelity enforcement)
K = 6;              % 3 modes
DC = 0;             % no DC part imposed
init = 1;           % initialize omegas uniformly
tol = 1e-10;        %Tolerance of the method in VMD
N = 1200;            %Number of iterations before quitting.

[imfs, ~, ~] = VMD(signal, alpha, tau, K, DC, init, tol, N);


%%Now Lets procede to the feature extraction via LSVD
%Number of partitions in the LSVD Method
N_ = 30;
lsvd = LSVD(imfs, N_);

%%Now Feature Extraction via Entropy Methods

%Number of partitions in the entropy distribution;
epartition = 30;
[HMS, HMSf, HMSEE, SE] = H2(imfs, inter, epartition);

%A third element: Feature Extraction via S-Transform

ST = Stransform(signal);

Z = SEntropy(ST);

%%
%Now we need to use the train model in order to predict results

%Something is missing here
%[labelHE, scoreHE] = predict(ModeloHE, HMSEE);
%[labelSE, scoreSE] = predict(ModeloSE, SE);


%Now using LSVD (in fact, we will focus on this one).
load('ModeloLSVD-1.mat'); %to check whether the condition is fault
load('ModeloLSVD-2.mat'); %to check wheter it is known
load('ModeloLSVD-3.mat');%to classify fault
[~, scoreLSVD1] = predict(ModeloLSVD1, lsvd);
if scoreLSVD1 < 0 %check if <0 means fault condition
    [~, scoreLSVD2] = predict(ModeloLSVD2, lsvd);

    if scoreLSVD2 >0 %check if >0 means that the fault condition is known

        [labelLSVD3, scoreLSVD3] = predict(ModeloLSVD3, lsvd);

        status = faults(labelLSVD3);
        scoreLSVD = scoreLSVD3;
    else
        status = 'Possible unknown Fault';
        scoreLSVD = scoreLSVD2;
    end
else
    status = "Normal Condition";
    scoreLSVD = scoreLSVD1;
end



%%
%Here we export the data

%First we update the Summary file
TblSummary2 = readtable('Summary.csv');
TblSummary.Archive = archive_name;
TblSummary.status = status;
TblSummary.ScoreLSVD = scoreLSVD;
TblSummary.ConfirmedLSVD = false;
TblSummary.ScoreHE = 0;
TblSummary.ConfirmedHE = false;
TblSummary.ScoreSE = 0;
TblSummary.ConfirmedSE = false;
TblSummary.N_IMF = K;
TblSummary = [TblSummary2 ; TblSummary];
writetable(TblSummary, 'Summary.csv');


%Now lets create the new archive, for the HMS
headers = {'Frequencies', 'IMF1', 'IMF2', 'IMF3', 'IMF4', 'IMF5', ...
    'IMF6', 'IMF7', 'IMF8', 'IMF9', 'IMF10', 'IMF11', 'IMF12'};
varTypes = {'double', 'double', 'double', 'double', 'double', 'double',...
    'double', 'double', 'double', 'double', 'double', 'double', 'double'};

csvHMS = table('Size', [size(HMS, 1), K+1], 'VariableNames',...
    headers(1:(K+1)), 'VariableTypes', varTypes(1:(K+1)));
csvHMS(:, 1) = table(HMSf(:));
for i = 1:K
    csvHMS(:, i+1) =  table(HMS(:, i));
end

writetable(csvHMS, archive_name + ".csv");
