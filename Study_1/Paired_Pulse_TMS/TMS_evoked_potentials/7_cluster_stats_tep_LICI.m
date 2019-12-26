clear; close all;
% ##### CLUSTER-BASED PERMUTATION STATISTICS #####

% This script runs cluster-based permutation statistics between two within
% subject conditions across a pre-determined time window of interest (TOI)

posneg = 'pos'; %% 'pos' or  'neg'
sesh = 'iTBS'; %% 'iTBS', 'cTBS' or 'SH'

%Condition 1
cond1 = ['PPTMS_' sesh '_LICI' posneg '_T1']; % single 

%Condition 2
cond2 = ['PPTMS_' sesh '_LICI' posneg '_T0']; % paired 

% for comparison between conditions (example)
% %Condition 1
% cond1 = ['PPTMS_iTBS_LICIdiff_' posneg '_T1']; % single
% cond2 = ['PPTMS_cTBS_LICIdiff_' posneg '_T1']; % paired 


inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\ROI\ft\';

cd(inPath);

if strcmp(posneg, 'neg')
    
TOINAMES = {'N40';'N120'};
TOI = {[0.030,0.050];[0.09,0.14]}; 

elseif strcmp(posneg, 'pos')

TOINAMES = {'P60';'P185'};
TOI = {[0.055,0.075];[0.160,0.240]}; 

end

ft_defaults;

for f = 1:size(TOI,1)
    
      if TOI{f,1} == [0.030,0.050]

        TOINAME = TOINAMES{1};

    elseif TOI{f,1} == [0.055,0.075]

        TOINAME = TOINAMES{1};

    elseif TOI{f,1} == [0.09,0.14]

        TOINAME = TOINAMES{2};

    elseif TOI{f,1}  == [0.160,0.240]


        TOINAME = TOINAMES{2};

    end




%set filename
filename1 = [cond1,'_ft_ga'];
load([inPath,filename1]);

    D1 = grandAverage;

filename2 = [cond2,'_ft_ga'];
load([inPath,filename2]);

    D2 = grandAverage;



%Load neighbours template
load('neighbours_template.mat');


%Run cluster-based permutation statistics
cfg = [];
cfg.channel     = {'all'};
cfg.minnbchan        = 2;
cfg.clusteralpha = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.alpha       = 0.025; %0.025 for two-tailed, 0.05 for one-tailed
cfg.latency     = TOI{f,1};
cfg.avgovertime = 'yes'; %can change this between no and yes depending if you want time included
cfg.avgoverchan = 'no';
cfg.statistic   = 'depsamplesT';
cfg.numrandomization = 5000;
cfg.correctm    = 'cluster';
cfg.method      = 'montecarlo'; 
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.neighbours  = neighbours;
cfg.parameter   = 'individual';

%enter number of participants
subj = size(D1.individual,1);
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
[stat] = ft_timelockstatistics(cfg, D1, D2);

%Save stats
tempTOI = TOI;
TOI = TOI{f,1};
save ([inPath, 'stats_', cond1,'_V_',cond2,'_',TOINAME], 'stat','TOI');

%Draw clusterplot for significant findings
% close all;

cfg=[];
cfg.alpha = 0.025;
cfg.zparam = 'stat';
cfg.layout =  'quickcap64.mat'; % 'easycapM11.mat'; % 'quickcap64.mat';
cfg.gridscale=100;
cfg.colorbar='yes'; % yes for on, no for off
cfg.highlightcolorpos = [0 0 1];
cfg.highlightcolorneg = [1 1 0];
cfg.colormap = jet;
cfg.subplotsize               = [1 1];
cfg.zlim = [-4 4];
cfg.highlightsymbolseries     =['*','x','+','o','.']; %1x5 vector, highlight marker symbol series (default ['*','x','+','o','.'] for p < [0.01 0.05 0.1 0.2 0.3]
cfg.highlightsizeseries       =[10 10 10 10 10 ];%1x5 vector, highlight marker size series   (default [6 6 6 6 6] for p < [0.01 0.05 0.1 0.2 0.3])

try
ft_clusterplot(cfg,stat);
catch
end

TOI = tempTOI;

    fprintf('%s''stats complete!  ',TOINAME); 

    
end
