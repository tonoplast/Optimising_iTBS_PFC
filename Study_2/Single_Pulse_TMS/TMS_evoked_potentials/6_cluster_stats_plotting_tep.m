clear; close all;

% final = within group comparison; norm = between group comparison
para = 'norm'; % para = 'final' ; 'norm'

%Condition 1
cond1 = 'TMSEEG_75_' para '_T1'; 

%Condition 2
cond2 = 'TMSEEG_100_' para '_T1'; 

TOINAME = 'N120'; % 'N40' ; 'N120' ;' P60';'P200' ;

%Path
inPath = 'F:\Data\EEG\1_Intensity\ROI\stats\';
cd(inPath)

load ([inPath, 'stats_', cond1 '_V_',cond2, '_',aud '_' TOINAME '_subplot' ]);

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
cfg.comment = 'no';
cfg.subplotsize               = [1 1];
cfg.zlim = [-3 3];
cfg.highlightsymbolseries     =['*','x','+','o','.']; %1x5 vector, highlight marker symbol series (default ['*','x','+','o','.'] for p < [0.01 0.05 0.1 0.2 0.3]
cfg.highlightsizeseries       =[10 10 10 10 10 ];%1x5 vector, highlight marker size series   (default [6 6 6 6 6] for p < [0.01 0.05 0.1 0.2 0.3])


try
    
ft_clusterplot(cfg,stat);
set(gca,'FontSize',24,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')

catch
    display('s nothing to plot.');
    close;
end

t=figure;
ft_topoplotER(cfg,stat);
set(t, 'position', [500 200 600 600]);
set(gca,'FontSize',26,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')

