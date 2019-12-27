clear; close all; clc;

cond = 'iTBS';
diffcond_1 = 'iTBS';
diffcond_2 = 'cTBS';

% input file names
cond1 = ['PPTMS_' cond '_LICI_T0']; % 
cond2 = ['PPTMS_' cond '_LICI_T1'];% 

cond1title = ['Pre-' cond];
cond2title = ['Post-' cond];

diffcontitle = [diffcond_1 '-' diffcond_2];

%Path
inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';
cd(inPath);

indi = 1; %which participant number for individual viewing
whichspect= 'powspctrm';%'logpowspctrm';%'powspctrm' % 'indipow'; -> indipow for individual participant (define at indi = X)

Bc = 'ftWaveBc'; % 'ftWaveBc';
whichylim = [5 70];
whicyxlim = [-0.05 0.65];
whichzlim = []; %[1 4]; [-1 1] for norms[-50 150]
whichzlimdiff = [];%[-0.5 0.5]; [-1 1] for norms[-50 50]

chanF = {'F1','F3','FC1','FC3'}; % channel(s) of interest



ft_defaults;

%set filename
filename1 = [cond1,'_' Bc '_ga'];
load([inPath,filename1]);
D1 = grandAverage;
D1.indipow = D1.powspctrm(indi,:,:,:);

filename2 = [cond2,'_' Bc '_ga'];
load([inPath,filename2]);
D2 = grandAverage;
D2.indipow = D2.powspctrm(indi,:,:,:);

Diff = grandAverage;
Diff.powspctrm = [];
Diff.powspctrm = D2.powspctrm - D1.powspctrm;
Diff.indipow = D2.indipow - D1.indipow;
   

%% multiplot
cfg =[];
cfg.xlim = whicyxlim;
cfg.ylim = whichylim;
cfg.colorbar = 'yes';
cfg.parameter = whichspect;
cfg.layout = 'quickcap64.mat';% 'quickcap64.mat';


figure;
ft_multiplotTFR(cfg,D1);

figure;
ft_multiplotTFR(cfg,D2);


%% F3
cfg=[];
cfg.parameter=whichspect;
cfg.xlim = whicyxlim;
 cfg.ylim = whichylim;
cfg.zlim = whichzlim;
cfg.channel = chanF;
cfg.colorbar = 'yes';


t1 = cfg.xlim(1,1);
t2 = cfg.xlim(1,2);
labels = t1*1000:50:t2*1000;

figure;
subplot(3,1,1);
ft_singleplotTFR(cfg,D1);
title(cond1title, 'fontsize', 12, 'fontweight','bold');
set(gca,'XTick',[cfg.xlim(1):0.05:cfg.xlim(2)]); 
set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
xlabel('Time(ms)', 'FontSize',11,'FontWeight','bold');
ylabel('Frequency(Hz)','FontSize',11,'FontWeight','bold');
box off

set(gca,'FontSize',12,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')


subplot(3,1,2);
ft_singleplotTFR(cfg,D2);
title(cond2title, 'fontsize', 12, 'fontweight','bold');
set(gca,'XTick',[cfg.xlim(1):0.05:cfg.xlim(2)]); 
set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
xlabel('Time(ms)', 'FontSize',11,'FontWeight','bold');
ylabel('Frequency(Hz)','FontSize',11,'FontWeight','bold');
box off

set(gca,'FontSize',12,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')



%% differences

cfg=[];
cfg.parameter=whichspect;
cfg.xlim = whicyxlim;
cfg.channel = chanF;
cfg.ylim = whichylim;
cfg.zlim = whichzlimdiff;
cfg.colorbar = 'yes';

t1 = cfg.xlim(1,1);
t2 = cfg.xlim(1,2);

labels = t1*1000:50:t2*1000;

% figure;
subplot(3,1,3);
ft_singleplotTFR(cfg,Diff);
title(diffcontitle, 'fontsize', 12, 'fontweight','bold');
set(gca,'XTick',[cfg.xlim(1):0.05:cfg.xlim(2)]); 
set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
xlabel('Time(ms)', 'FontSize',11,'FontWeight','bold');
ylabel('Frequency(Hz)','FontSize',11,'FontWeight','bold');
box off


set(gcf, 'Position', [500 100 700 900]);
set(gca,'FontSize',12,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold')

%% something to work on (power graph)

%freq lim (xlim)
freq = [5 25]; 
plotSEM = 1; % yes = 1;

%time range
t1 = [0.02, 0.250]; % for 1st plot
t2 = [0.400, 0.650]; % for 2nd plot

plotROI     =  {'F1','F3','FC1','FC3'}; % channel(s) of interest;

chaninfo = D1.label';

    for ii = 1:length(plotROI)
    plotROIidx(ii) = find(strcmp(plotROI{1,ii}, chaninfo));
    end

    
    
d1t = round(D1.time,4); % rounding up decimals to 4
tdx11 = find(d1t == t1(1)); % finding where it is
tdx12 = find(d1t == t1(2)); % finding where it is  

tdx21 = find(d1t == t2(1)); % finding where it is
tdx22 = find(d1t == t2(2)); % finding where it is  
    
% D1
D1.spect =squeeze(mean(D1.powspctrm(:,plotROIidx,:,:),2)); % mean for multiple electrodes
D1.meanspect = squeeze(mean(D1.spect,1));
% SEM
D1.spectSEM = squeeze(std(D1.spect,[],1) / sqrt(size((D1.spect),1)));


% D2
D2.spect =squeeze(mean(D2.powspctrm(:,plotROIidx,:,:),2));
D2.meanspect= squeeze(mean(D2.spect,1));
% SEM
D2.spectSEM = squeeze(std(D2.spect,[],1) / sqrt(size((D2.spect),1)));



% average over time point
figure;
plot(D1.freq,mean(D1.meanspect(:,tdx11:tdx12),2)', 'b', 'LineWidth',1.5); hold on;
plot(D2.freq,mean(D2.meanspect(:,tdx11:tdx12),2)', 'r', 'LineWidth',1.5); 
if plotSEM == 1
SEMfill1 = fill([D1.freq,fliplr(D1.freq)],[mean(D1.meanspect(:,tdx11:tdx12),2)'-mean(D1.spectSEM(:,tdx11:tdx12),2)',fliplr(mean(D1.meanspect(:,tdx11:tdx12),2)'+mean(D1.spectSEM(:,tdx11:tdx12),2)')], 'b');
set(SEMfill1, 'FaceAlpha' ,0.3); set(SEMfill1, 'EdgeColor', 'none');
SEMfill2 = fill([D2.freq,fliplr(D2.freq)],[mean(D2.meanspect(:,tdx11:tdx12),2)'-mean(D2.spectSEM(:,tdx11:tdx12),2)',fliplr(mean(D2.meanspect(:,tdx11:tdx12),2)'+mean(D2.spectSEM(:,tdx11:tdx12),2)')], 'r');
set(SEMfill2, 'FaceAlpha' ,0.3); set(SEMfill2, 'EdgeColor', 'none');
end
set(gca,'Xlim', freq);
xlabel('Frequency (Hz)');
ylabel('Amplitude (\muV)');
h_legend = legend(cond1title,cond2title);
set(h_legend,'FontSize',12, 'Location','northeast');
title([char(plotROI) ': ' num2str(t1(1)*1000) '-' num2str(t1(2)*1000) 'ms'],'fontweight','bold');
box off


% average of two time points (a)
figure;
plot(D1.freq,mean(D1.meanspect(:,tdx21:tdx22),2)', 'b', 'LineWidth',1.5); hold on;
plot(D2.freq,mean(D2.meanspect(:,tdx21:tdx22),2)', 'r', 'LineWidth',1.5); 
if plotSEM == 1
SEMfill1 = fill([D1.freq,fliplr(D1.freq)],[mean(D1.meanspect(:,tdx21:tdx22),2)'-mean(D1.spectSEM(:,tdx21:tdx22),2)',fliplr(mean(D1.meanspect(:,tdx21:tdx22),2)'+mean(D1.spectSEM(:,tdx21:tdx22),2)')], 'b');
set(SEMfill1, 'FaceAlpha' ,0.3); set(SEMfill1, 'EdgeColor', 'none');
SEMfill2 = fill([D2.freq,fliplr(D2.freq)],[mean(D2.meanspect(:,tdx21:tdx22),2)'-mean(D2.spectSEM(:,tdx21:tdx22),2)',fliplr(mean(D2.meanspect(:,tdx21:tdx22),2)'+mean(D2.spectSEM(:,tdx21:tdx22),2)')], 'r');
set(SEMfill2, 'FaceAlpha' ,0.3); set(SEMfill2, 'EdgeColor', 'none');
end
set(gca,'Xlim', freq);
xlabel('Frequency (Hz)');
ylabel('Amplitude (\muV)');
h_legend = legend(cond1title,cond2title);
set(h_legend,'FontSize',12, 'Location','northeast');
title([char(plotROI) ': ' num2str(t2(1)*1000) '-' num2str(t2(2)*1000) 'ms'],'fontweight','bold');
box off




%% TOPOPLOT


cfg =[];
cfg.xlim = [0.05 0.250];
cfg.ylim = [5 7];
cfg.colorbar = 'yes';
cfg.parameter = whichspect;
cfg.layout = 'quickcap64.mat';% 'quickcap64.mat';

figure;
cfg.zlim = [1 5];
ft_topoplotTFR(cfg,D1);

figure;
cfg.zlim = [1 5];
ft_topoplotTFR(cfg,D2);

figure;
cfg.zlim = [-0.5 0.8];
ft_topoplotTFR(cfg,Diff);
