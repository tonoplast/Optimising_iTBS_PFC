clear; %close all; clc;

% this script will create Time-Frequency plots & topoplots

% files to be loaded / compared
cond1 = 'TMSEEG_75_final_T0'; 
cond2 = 'TMSEEG_75_final_T1';

cond1title = 'T0';
cond2title = 'T1';

diffcontitle = 'T1 - T0';


%Path
inPath = 'F:\Data\EEG\1_Intensity\ROI\Freq_analysis\';

indi = 1; %which participant number for individual viewing
whichspect= 'powspctrm';%'logpowspctrm';%'powspctrm' % 'indipow'; -> indipow for individual participant (define at indi = X)
whichylim = [4 8]; % define frequency range here (Theta example)
whicyxlim = [-0.05 0.500]; % define Time range here
whichzlim = [1 3]; 
whichzlimdiff = [-1 1];
xtick = 0.05;


chanF = {'FCZ'};; % channel(s) of interest


ft_defaults;

%set filename
filename1 = [cond1, '_ftWaveBc_ga'];
load([inPath,filename1]);
D1 = grandAverage;
D1.indipow = D1.powspctrm(indi,:,:,:);

filename2 = [cond2,'_ftWaveBc_ga'];
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
% cfg.zlim = whichzlim;
cfg.colorbar = 'yes';
% cfg.colormap = jet;
cfg.parameter = whichspect;
cfg.layout = 'quickcap64.mat';


%% Channel(s) of interest
cfg=[];
cfg.parameter=whichspect;
cfg.xlim = whicyxlim;
 cfg.ylim = whichylim;
cfg.zlim = whichzlim;
cfg.channel = chanF;
cfg.colorbar = 'yes';
% cfg.colormap = jet;


t1 = cfg.xlim(1,1);
t2 = cfg.xlim(1,2);
labels = t1*1000:xtick*1000:t2*1000;



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

labels = t1*1000:xtick*1000:t2*1000;

figure;
ft_singleplotTFR(cfg,Diff);
set(gca,'XTick',[cfg.xlim(1):xtick:cfg.xlim(2)]); 
set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
xlabel('Time (ms)', 'FontSize',10,'FontWeight','bold');
ylabel('Frequency (Hz)','FontSize',10,'FontWeight','bold');
box off

set(gca,'FontSize',14,'fontWeight','bold','linewidth',2)
set(findall(gcf,'type','text'),'FontSize',14,'fontWeight','bold')

set(gcf, 'Position', [450 250 850 400]);


set(gca,'FontSize',17,'fontWeight','bold','linewidth',3)
set(findall(gcf,'type','text'),'FontSize',20,'fontWeight','bold')

%% something to work on (power graph)

% freq = 5:1:45;       
% M = mean(ind_freq,1);%average frequencies across participants.
% SE = (std(ind_freq,0,1)./(sqrt(size(ind_freq,1)))); %calculates standard error
% t = figure; plot(freq,M,'b'); hold on; %plots mean frequency
% f = fill([freq,fliplr(freq)],[M-SE,fliplr(M+SE)],'b'); %plots shaded bar
% set(f,'FaceAlpha',0.3);set(f,'EdgeColor', 'none'); %makes shaded bar lighter

%freq lim (xlim)
freq = [4 8]; 
plotSEM = 1; % yes = 1;

%time range
t1 = [0.025, 0.250]; % for 1st plot
t2 = [0.400, 0.650]; % for 2nd plot


plotROI     =  {'FCZ'};

chaninfo = D1.label';

    for ii = 1:length(plotROI);
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


% D3 (for power graph)
if exist('cond3') == 1;
D3.spect =squeeze(mean(D3.powspctrm(:,plotROIidx,:,:),2));
D3.meanspect= squeeze(mean(D3.spect,1));
% SEM
D3.spectSEM = squeeze(std(D3.spect,[],1) / sqrt(size((D3.spect),1)));
end



% power graph for 3 condi (nicer one) -> First time ones
figure;
plot(D1.freq,mean(D1.meanspect(:,tdx11:tdx12),2)', 'Color', [0 0.447 0.741], 'LineWidth',1.5); hold on;
plot(D2.freq,mean(D2.meanspect(:,tdx11:tdx12),2)', 'Color', [0.85 0.325 0.098], 'LineWidth',1.5); 
if exist('cond3') == 1;
plot(D3.freq,mean(D3.meanspect(:,tdx11:tdx12),2)', 'Color', [0.929 0.694 0.125], 'LineWidth',1.5); 
end
if plotSEM == 1;
SEMfill1 = fill([D1.freq,fliplr(D1.freq)],[mean(D1.meanspect(:,tdx11:tdx12),2)'-mean(D1.spectSEM(:,tdx11:tdx12),2)',fliplr(mean(D1.meanspect(:,tdx11:tdx12),2)'+mean(D1.spectSEM(:,tdx11:tdx12),2)')], [0 0.447 0.741]);
set(SEMfill1, 'FaceAlpha' ,0.3); set(SEMfill1, 'EdgeColor', 'none');
SEMfill2 = fill([D2.freq,fliplr(D2.freq)],[mean(D2.meanspect(:,tdx11:tdx12),2)'-mean(D2.spectSEM(:,tdx11:tdx12),2)',fliplr(mean(D2.meanspect(:,tdx11:tdx12),2)'+mean(D2.spectSEM(:,tdx11:tdx12),2)')], [0.85 0.325 0.098]);
set(SEMfill2, 'FaceAlpha' ,0.3); set(SEMfill2, 'EdgeColor', 'none');
if exist('cond3') == 1;
SEMfill3 = fill([D3.freq,fliplr(D3.freq)],[mean(D3.meanspect(:,tdx11:tdx12),2)'-mean(D3.spectSEM(:,tdx11:tdx12),2)',fliplr(mean(D3.meanspect(:,tdx11:tdx12),2)'+mean(D3.spectSEM(:,tdx11:tdx12),2)')], [0.929 0.694 0.125]);
set(SEMfill3, 'FaceAlpha' ,0.3); set(SEMfill3, 'EdgeColor', 'none');
end
end
set(gca,'Xlim', freq);
xlabel('Frequency (Hz)');
ylabel('Amplitude (\muV)');
h_legend = legend(cond1title,cond2title);
if exist('cond3') == 1;
h_legend = legend(cond1title,cond2title,cond3title);
end

set(h_legend,'FontSize',12, 'Location','northeast');
title([char(plotROI) ': ' num2str(t1(1)*1000) '-' num2str(t1(2)*1000) 'ms'],'fontweight','bold');
box off


%% TOPOPLOT


cfg =[];
cfg.xlim = [0.05 0.250];
cfg.ylim = [5 7];
% cfg.zlim = whichzlim;
cfg.colorbar = 'yes';
% cfg.colormap = jet;
cfg.parameter = whichspect;
cfg.layout = 'quickcap64.mat';% 'quickcap64.mat';

figure;
ft_topoplotTFR(cfg,D1);

figure;
ft_topoplotTFR(cfg,D2);

figure;
ft_topoplotTFR(cfg,Diff);
