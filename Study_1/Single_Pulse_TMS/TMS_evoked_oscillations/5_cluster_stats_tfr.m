clear; close all;
% ##### CLUSTER-BASED PERMUTATION STATISTICS #####

% This script runs cluster-based permutation statistics between two within
% subject conditions following time frequency analysis across a
% pre-determined frequency band (FOI) and time window of interest (TOI).
% The script averages across both time and frequency, but takes in to
% account space (i.e. electrode positions).


%Condition 1
cond1 = 'SPTMS_iTBS_T1'; 

%Condition 2
cond2 = 'SPTMS_iTBS_T0';

%Path
inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';
outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\stats\';


cd(outPath);

FOINames = {'theta';'alpha';'beta';'gamma'}; % running frequencies of interest

timewin = 'all'; 

FOI = {[5,7];[8,12];[13,30];[31,70]};


for f = 1:size(FOI,1);
    
    if FOI{f,1} == [5,7]
        FOIName = FOINames{1};
        TOI = [0.050,0.250];  
     elseif FOI{f,1} == [8,12]
         FOIName = FOINames{2};
         TOI = [0.050,0.250]; 
     elseif FOI{f,1} == [13,30];
         FOIName = FOINames{3};
         TOI = [0.050,0.250]; 
    elseif FOI{f,1}  == [30,70];
        FOIName = FOINames{4};
         TOI = [0.025,0.125];
    end


ft_defaults;

%%%set filename
filename1 = [cond1,'_ftWaveBc_ga'];
load([inPath,filename1]);
D1 = grandAverage;


filename2 = [cond2,'_ftWaveBc_ga'];
load([inPath,filename2]);
D2 = grandAverage;


%Load neighbours template
load('neighbours_template.mat');

%Run cluster-based permutation statistics
cfg = [];
cfg.channel     = {'all'};
cfg.minnbchan        = 2; %minimum number of channels for cluster
cfg.clusteralpha = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.alpha       = 0.025;% 0.025 for two tailed, 0.05 for one tailed
cfg.latency     = TOI;
cfg.frequency   = FOI{f,1};
cfg.avgovertime = 'yes'; %can change this between no and yes depending if you want time included
cfg.avgoverchan = 'no'; %can change this between no and yes depending if you want all channels included
cfg.avgoverfreq = 'yes'; %can change this between no and yes depending if you want all frequencies included
cfg.statistic   = 'depsamplesT';
cfg.numrandomization = 5000;
cfg.correctm    = 'cluster';
cfg.method      = 'montecarlo'; 
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.neighbours  = neighbours;
% cfg.parameter   = 'individual';

%enter number of participants
subj = size(D1.powspctrm,1);
design = zeros(2,2*subj);
for i = 1:subj
  design(1,i) = i;
end
for i = 1:subj
  design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design = design;
cfg.uvar  = 1;
cfg.ivar  = 2;

%define variables for comparison
[stat] = ft_freqstatistics(cfg, D1, D2);

%Save stats
tempFOI = FOI;
FOI = FOI{f,1};
save ([outPath,'stats_',cond1,'_V_',cond2,'_',FOIName , '_' timewin], 'stat','TOI','FOI');



%Draw clusterplot for significant findings
% close all;

cfg=[];
cfg.alpha = 0.025;
cfg.parameter = 'stat';
cfg.layout = 'quickcap64.mat';
cfg.highlightcolorpos = [0 0 1];
cfg.highlightcolorneg = [1 1 0];

try
ft_clusterplot(cfg,stat);
catch
end

FOI = tempFOI;
    fprintf('%s''stats complete',FOIName);
    fprintf('\n');
end
