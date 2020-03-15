clear; close all;
Sesh = '75';
para = 'final';
nback = '3back';
type = 'CR';

cond1 = ['ERP_' Sesh '_' type '_' nback '_' para '_T1']; % single - important, do not put a _ before the extension
cond2 = ['ERP_' Sesh '_' type '_' nback '_' para '_T0']; % paired - important, do not put a _ before the extension

%Path
inPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\ERP\stats\';

cd(inPath);

TOINAME = 'P160'; % {'N100';'P160';'N230';'P350'};

load ([inPath, 'stats_', cond1,'_V_',cond2,'_',TOINAME '.mat']);

%Draw clusterplot for significant findings
% close all;

cfg=[];
cfg.alpha = 0.025;
cfg.zparam = 'stat';
cfg.layout =  'quickcap64.mat'; %'easycapM11.mat'; % 'quickcap64.mat';
cfg.gridscale=100;
cfg.colorbar='yes'; % yes for on, no for off
cfg.highlightcolorpos = [0 0 1];
cfg.highlightcolorneg = [1 1 0];
% cfg.colormap = jet;
cfg.subplotsize               = [1 1];
cfg.zlim = [-3 3];
cfg.highlightsymbolseries     =['*','x','+','o','.']; %1x5 vector, highlight marker symbol series (default ['*','x','+','o','.'] for p < [0.01 0.05 0.1 0.2 0.3]
cfg.highlightsizeseries       =[10 10 10 10 10 ];%1x5 vector, highlight marker size series   (default [6 6 6 6 6] for p < [0.01 0.05 0.1 0.2 0.3])

try
    ft_clusterplot(cfg,stat);
    
set(gca,'FontSize',12,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')

catch
    display('s nothing to plot.');
    close;
end

% movie2gif(M, 'gamma.gif', 'LoopCount', 10, 'DelayTime', 0);

t=figure;
ft_topoplotER(cfg,stat);
set(t, 'position', [500 200 600 600]);
set(gca,'FontSize',26,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')
