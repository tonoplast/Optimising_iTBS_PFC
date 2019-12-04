clear; %close all


%Condition 1
cond1 = 'SPTMS_iTBS_final_T1'; 

%Condition 2
cond2 = 'SPTMS_iTBS_final_T0'; 

FOINAME = 'theta'; % 'theta'; 'alpha' ; 'beta'; 'gamma' ;
%Path
inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\stats\';
cd(inPath);

timewin = 'all';

load ([inPath, 'stats_', cond1,'_V_',cond2,'_',FOINAME, '_' timewin]);



%Draw clusterplot for significant findings
% close all;

cfg=[];
cfg.alpha = 0.025;
cfg.zparam = 'stat';
cfg.layout =  'quickcap64.mat';
cfg.gridscale=100;
cfg.colorbar='yes'; % yes for on, no for off
cfg.highlightcolorpos = [0 0 1];
cfg.highlightcolorneg = [1 1 0];
cfg.comment = 'no';
% cfg.colormap = jet;
cfg.subplotsize               = [1 1];
cfg.zlim = [-3 3];
cfg.highlightsymbolseries     =['*','x','+','o','.']; %1x5 vector, highlight marker symbol series (default ['*','x','+','o','.'] for p < [0.01 0.05 0.1 0.2 0.3]
cfg.highlightsizeseries       =[10 10 10 10 10 ];%1x5 vector, highlight marker size series   (default [6 6 6 6 6] for p < [0.01 0.05 0.1 0.2 0.3])
ft_clusterplot(cfg,stat);

t=figure;
ft_topoplotER(cfg,stat);
set(t, 'position', [300 200 600 600]);
set(gca,'FontSize',12,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')
