clear; close all; clc;

%% This will create many different plots, including ROI (region of analysis), GMFP (Global mean field potentials),
% Butterfly plot and voltage distributions. This script is not very user-friendly, and possibly out-dated

%Condition 1
cond1 = 'SPTMS_iTBS_final_T0'; % single - important, do not put a _ before the extension

%Condition 2
cond2 = 'SPTMS_iTBS_final_T1'; % paired - important, do not put a _ before the extension



%Path
inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\ROI\ft\';


comp1 = 'Pre';
comp2 = 'Post';

if exist('cond3') == 1;
comp3 = 'Post-Sham';
end

ploterrorbars = 0 ; % [1 | 2 | 0] - ['SEM'| '95% CI' | 'none' ]

xtick = 0.05;
% box setting for peaks
N40bar = 1;
P60bar = 1; % [1|0] - 1 is yes
N100bar = 1; % [1|0] - 0 is no
P200bar = 1;

N40time = [0.030 0.05]; 
P60time = [0.055 0.075]; 
N100time = [0.090 0.135]; 
P200time = [0.16 0.24];


% last graph (for publication) peak amplitude
ymin = -6; ymax = 6;
gmfaymin = 0; gmfaymax = 6;

ft_defaults;
try
%%%set filename
filename1 = [cond1,'_ft_ga'];
load([inPath,filename1]);
D1 = grandAverage;

filename2 = [cond2,'_ft_ga'];
load([inPath,filename2]);
D2 = grandAverage;

if exist('cond3') == 1;
filename3 = [cond3,'_ft_ga'];
load([inPath,filename3]);
D3 = grandAverage;
end

catch
%%set filename
filename1 = [cond1,'_ft_ga'];
load([inPath,filename1]);
D1 = grandAverageNorm;

filename2 = [cond2,'_ft_ga'];
load([inPath,filename2]);
D2 = grandAverageNorm;


if exist('cond3') == 1;
filename3 = [cond3,'_ft_ga'];
load([inPath,filename3]);
D3 = grandAverageNorm;
end
end



% % Figures
cfg = [];
cfg.showlabels  = 'yes';
cfg.layout = 'quickcap64.mat';
cfg.xlim = [-0.05 0.5];
if exist('cond3') == 1;
figure; ft_multiplotER(cfg,D1, D2, D3);
else
figure; ft_multiplotER(cfg,D1, D2);
end


cfg = [];
cfg.channel     =  {'F3','FC3','F1','FC1'};
cfg.xlim = [-0.05 0.50];
if exist('cond3') == 1;
figure; ft_singleplotER(cfg,D1, D2, D3);
else
figure; ft_singleplotER(cfg,D1, D2);
end


%%
figure;
t1 = cfg.xlim(1,1);
t2 = cfg.xlim(1,2);
    
    ftchan = cfg.channel;
    for i = 1:length(ftchan);
    chanidx(i) = find(strcmp(ftchan{1,i}, D1.label'));
    end

    
avgD1 = mean(D1.individual); %average across participants of D1
sqavgD1 = squeeze(avgD1);    %Squeezing (getting rid of 1 dimention)

StdevD1 = std(D1.individual); SEMD1 = std(D1.individual)/sqrt(size((D1.individual),1)); CI95D1 = 1.96 * SEMD1; % Stdev , SEM , CI95
sqStdevD1 = squeeze(StdevD1); sqSEMD1 = squeeze(SEMD1); sqCI95D1 = squeeze(CI95D1);

avgD2 = mean(D2.individual); %average across participants of D2
sqavgD2 = squeeze(avgD2);    %Squeezing (getting rid of 1 dimention)

StdevD2 = std(D2.individual); SEMD2 = std(D2.individual)/sqrt(size((D2.individual),1)); CI95D2 = 1.96 * SEMD2;% Stdev and SEM
sqStdevD2 = squeeze(StdevD2); sqSEMD2 = squeeze(SEMD2); sqCI95D2 = squeeze(CI95D2);



if exist('cond3') == 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
avgD3 = mean(D3.individual); %average across participants of 3
sqavgD3 = squeeze(avgD3);    %Squeezing (getting rid of 1 dimention)

StdevD3 = std(D3.individual); SEMD3 = std(D3.individual)/sqrt(size((D3.individual),1)); CI95D3 = 1.96 * SEMD3; % Stdev and SEM
sqStdevD3 = squeeze(StdevD3); sqSEMD3 = squeeze(SEMD3); sqCI95D3 = squeeze(CI95D3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

indsqavgD1 = sqavgD1(chanidx,:); %finding only D1 data of channels (from cfg.channel designated above)
indsqavgD2 = sqavgD2(chanidx,:); %finding only D2 data of channels (from cfg.channel designated above)
if exist('cond3') == 1;
indsqavgD3 = sqavgD3(chanidx,:); %finding only D3 data of channels (from cfg.channel designated above)
end

indsqStdevD1 = sqStdevD1(chanidx,:); indsqSEMD1 = sqSEMD1(chanidx,:); indsqCI95D1 = sqCI95D1(chanidx,:);
indsqStdevD2 = sqStdevD2(chanidx,:); indsqSEMD2 = sqSEMD2(chanidx,:); indsqCI95D2 = sqCI95D2(chanidx,:);
if exist('cond3') == 1;
indsqStdevD3 = sqStdevD3(chanidx,:); indsqSEMD3 = sqSEMD3(chanidx,:); indsqCI95D3 = sqCI95D3(chanidx,:);
end

avgindsqavgD1 = mean(indsqavgD1); % averaging those found D1 data
avgindsqavgD2 = mean(indsqavgD2); % averaging those found D2 data
if exist('cond3') == 1;
avgindsqavgD3 = mean(indsqavgD3); % averaging those found D3 data
end

avgindsqStdevD1 = mean(indsqStdevD1); avgindsqSEMD1 = mean(indsqSEMD1); avgindsqCI95D1 = mean(sqCI95D1);
avgindsqStdevD2 = mean(indsqStdevD2); avgindsqSEMD2 = mean(indsqSEMD2); avgindsqCI95D2 = mean(sqCI95D2);
if exist('cond3') == 1;
avgindsqStdevD3 = mean(indsqStdevD3); avgindsqSEMD3 = mean(indsqSEMD3); avgindsqCI95D3 = mean(sqCI95D3);
end

d1t = round(D1.time,4); % rounding up decimals to 4

tdx1 = find(d1t == t1); % finding where it is
tdx2 = find(d1t == t2); % finding where it is



    

%%


% graph settings
figure;
plot(D1.time(tdx1:tdx2), avgindsqavgD1(tdx1:tdx2), 'b', 'LineWidth',3); hold on;
plot(D2.time(tdx1:tdx2), avgindsqavgD2(tdx1:tdx2), 'r', 'LineWidth',3); hold on;
if exist('cond3') == 1;
plot(D3.time(tdx1:tdx2), avgindsqavgD3(tdx1:tdx2), 'g', 'LineWidth',3);
end

if ploterrorbars == 1;
SEMfill1 = fill([D1.time(tdx1:tdx2),fliplr(D1.time(tdx1:tdx2))],[avgindsqavgD1(tdx1:tdx2)-avgindsqSEMD1(tdx1:tdx2),fliplr(avgindsqavgD1(tdx1:tdx2)+avgindsqSEMD1(tdx1:tdx2))], 'b');
set(SEMfill1, 'FaceAlpha' ,0.2); set(SEMfill1,'EdgeColor', 'none');
SEMfill2 = fill([D2.time(tdx1:tdx2),fliplr(D2.time(tdx1:tdx2))],[avgindsqavgD2(tdx1:tdx2)-avgindsqSEMD2(tdx1:tdx2),fliplr(avgindsqavgD2(tdx1:tdx2)+avgindsqSEMD2(tdx1:tdx2))], 'r');
set(SEMfill2, 'FaceAlpha' ,0.2); set(SEMfill2, 'EdgeColor', 'none');
if exist('cond3') == 1;
SEMfill3 = fill([D1.time(tdx1:tdx2),fliplr(D3.time(tdx1:tdx2))],[avgindsqavgD3(tdx1:tdx2)-avgindsqSEMD3(tdx1:tdx2),fliplr(avgindsqavgD3(tdx1:tdx2)+avgindsqSEMD3(tdx1:tdx2))], 'g');
set(SEMfill3, 'FaceAlpha' ,0.2); set(SEMfill3, 'EdgeColor', 'none');
end
else
end


if ploterrorbars == 2;
SEMfill1 = fill([D1.time(tdx1:tdx2),fliplr(D1.time(tdx1:tdx2))],[avgindsqavgD1(tdx1:tdx2)-avgindsqCI95D1(tdx1:tdx2),fliplr(avgindsqavgD1(tdx1:tdx2)+avgindsqCI95D1(tdx1:tdx2))], 'b');
set(SEMfill1, 'FaceAlpha' ,0.2); set(SEMfill1, 'EdgeColor', 'none');
SEMfill2 = fill([D2.time(tdx1:tdx2),fliplr(D2.time(tdx1:tdx2))],[avgindsqavgD2(tdx1:tdx2)-avgindsqCI95D2(tdx1:tdx2),fliplr(avgindsqavgD2(tdx1:tdx2)+avgindsqCI95D2(tdx1:tdx2))], 'r');
set(SEMfill2, 'FaceAlpha' ,0.2); set(SEMfill2, 'EdgeColor', 'none');
if exist('cond3') == 1;
SEMfill3 = fill([D1.time(tdx1:tdx2),fliplr(D3.time(tdx1:tdx2))],[avgindsqavgD3(tdx1:tdx2)-avgindsqCI95D3(tdx1:tdx2),fliplr(avgindsqavgD3(tdx1:tdx2)+avgindsqCI95D3(tdx1:tdx2))], 'g');
set(SEMfill3, 'FaceAlpha' ,0.2); set(SEMfill3, 'EdgeColor', 'none');
end
else
end


axis([cfg.xlim(1) cfg.xlim(2) ymin ymax]);    % axis[xmin xmax ymin ymax] 
labels = t1*1000:xtick*1000:t2*1000;
set(gca,'XTick',[cfg.xlim(1):xtick:cfg.xlim(2)]); 

set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
set(gca,'FontSize',24)
xlabel('Time (ms)', 'FontSize',24,'FontWeight','bold');
ylabel('Amplitude (µV)','FontSize',24,'FontWeight','bold');
if exist('cond3') == 1;
h_legend = legend(comp1,comp2, comp3);
else
h_legend = legend(comp1,comp2);
end
set(h_legend,'FontSize',24, 'Location','northeast');
set(gca,'FontSize',24,'fontWeight','bold','LineWidth',3)
set(findall(gcf,'type','text'),'FontSize',25,'fontWeight','bold')

legend boxoff
box off



% this is line at 0

refline = 1;
refposition = [0 0]; 
refposition2 = [-100 -100]; 

if refline >0;
    h = line(refposition, get(gca, 'YLim'), 'Color', [0 0 0],'LineStyle',':', 'LineWidth',3);
  if refline==2;
    h = line(refposition2, get(gca, 'YLim'), 'Color', [0 0 0],'LineStyle',':','LineWidth',3);
  end;
end ;


% creating a box
if N40bar == 1;   
xN40 = [N40time(1) N40time(2) N40time(2) N40time(1)];
y = [ymin ymin ymax ymax];
p1=patch(xN40,y,'r');
set(p1,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end


if P60bar == 1;   
xP60 = [P60time(1) P60time(2) P60time(2) P60time(1)];
y = [ymin ymin ymax ymax];
p2=patch(xP60,y,'r');
set(p2,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end


if N100bar == 1 ; 
xN100 = [N100time(1) N100time(2) N100time(2) N100time(1)];
y = [ymin ymin ymax ymax];
p3=patch(xN100,y,'r');
set(p3,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end

if P200bar == 1 ; 
xP200 = [P200time(1) P200time(2) P200time(2) P200time(1)];
y = [ymin ymin ymax ymax];
p4=patch(xP200,y,'r');
set(p4,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end


    set(gcf, 'Position', [350 300 1000 600]);

 

%%
%%%%%%%%%%%%%%%%%%%% GMFA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% MUST REPLOT THIS %%%%% FOR SOME REASON!!!%%%%%
N40time = [0.035 0.055];
P60time = [0.065 0.085]; % for graph (P60 - 55 80) GMFA : 65 85


cfg = [];

D1.avg = ft_timelockanalysis(cfg, D1);
D2.avg = ft_timelockanalysis(cfg, D2);
if exist('cond3') == 1;
D3.avg = ft_timelockanalysis(cfg, D3);
end


cfg.xlim = [-0.05 0.5];
cfg.method = 'amplitude';
GMFAD1 = ft_globalmeanfield(cfg, D1.avg); 
GMFAD2 = ft_globalmeanfield(cfg, D2.avg); 
if exist('cond3') == 1;
GMFAD3 = ft_globalmeanfield(cfg, D3.avg); 
end

figure;
plot(GMFAD1.time(tdx1:tdx2), GMFAD1.avg(tdx1:tdx2), 'b', 'LineWidth',3); hold on;
plot(GMFAD2.time(tdx1:tdx2), GMFAD2.avg(tdx1:tdx2), 'r', 'LineWidth',3); hold on;
if exist('cond3') == 1;
plot(GMFAD3.time(tdx1:tdx2), GMFAD3.avg(tdx1:tdx2), 'g', 'LineWidth',3); hold on;
end






axis([cfg.xlim(1) cfg.xlim(2) gmfaymin gmfaymax]);    % axis[xmin xmax ymin ymax] 
labels = t1*1000:xtick*1000:t2*1000;
set(gca,'XTick',[cfg.xlim(1):xtick:cfg.xlim(2)]); 



set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
set(gca,'FontSize',24)
xlabel('Time (ms)', 'FontSize',24,'FontWeight','bold');
ylabel('Amplitude (µV)','FontSize',24,'FontWeight','bold');
if exist('cond3') == 1;
h_legend = legend(comp1,comp2, comp3);
else
h_legend = legend(comp1,comp2);
end
set(h_legend,'FontSize',24, 'Location','northeast');
set(gca,'FontSize',24,'fontWeight','bold','LineWidth',3)
set(findall(gcf,'type','text'),'FontSize',25,'fontWeight','bold')

legend boxoff
box off




% this is line at 0

refline = 1;
refposition = [0 0]; 
refposition2 = [-100 -100]; 

if refline >0;
    h = line(refposition, get(gca, 'YLim'), 'Color', [0 0 0],'LineStyle',':','LineWidth',3);
  if refline==2;
    h = line(refposition2, get(gca, 'YLim'), 'Color', [0 0 0],'LineStyle',':','LineWidth',3);
  end;
end ;


% creating a box
if N40bar == 1;   
xN40 = [N40time(1) N40time(2) N40time(2) N40time(1)];
y = [ymin ymin ymax ymax];
p1=patch(xN40,y,'r');
set(p1,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end

if P60bar == 1;   
xP60 = [P60time(1) P60time(2) P60time(2) P60time(1)];
y = [ymin ymin ymax ymax];
p2=patch(xP60,y,'r');
set(p2,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end

if N100bar == 1 ; 
xN100 = [N100time(1) N100time(2) N100time(2) N100time(1)];
y = [ymin ymin ymax ymax];
p3=patch(xN100,y,'r');
set(p3,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end

if P200bar == 1 ; 
xP200 = [P200time(1) P200time(2) P200time(2) P200time(1)];
y = [ymin ymin ymax ymax];
p4=patch(xP200,y,'r');
set(p4,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end


    set(gcf, 'Position', [350 300 1000 600]);
    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Plot check (BUTTER)

plotROI     =  {'F3','FC3','F1','FC1'};

chaninfo = D1.label';

    for ii = 1:length(plotROI);
    plotROIidx(ii) = find(strcmp(plotROI{1,ii}, chaninfo));
    end
    
   mplotROID1 = mean(D1.individual(:,plotROIidx,tdx1:tdx2),1);
   sqm2plotROID1 = squeeze(mean(mplotROID1,2))';
    
   mplotROID2 = mean(D2.individual(:,plotROIidx,tdx1:tdx2),1);
   sqm2plotROID2 = squeeze(mean(mplotROID2,2))';  
   
   if exist('cond3') == 1;
   mplotROID3 = mean(D3.individual(:,plotROIidx,tdx1:tdx2),1);
   sqm2plotROID3 = squeeze(mean(mplotROID3,2))';
   end
   
   
   



    f1 = figure;
    
    if exist('cond3') == 1;
    subplot(1,3,1)
    else
    subplot(1,2,1)
    end

    plot(D1.time(tdx1:tdx2),squeeze(mean(D1.individual(:,:,tdx1:tdx2),1)),'color', [0 0.4470 0.7410]); hold on;

    plotROID1 = plot(D1.time(tdx1:tdx2),sqm2plotROID1,'r','LineWidth',3); 

    plot([0 0], [-10 10],'k--','LineWidth',2);

    set(gca,'Xlim', cfg.xlim);
    %labels = t1*1000:50:t2*1000;
    set(gca,'XTick',[cfg.xlim(1):0.05:cfg.xlim(2)]); 
    set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
    xlabel('Time (ms)', 'FontSize',15,'FontWeight','bold');
    ylabel('Amplitude (µV)','FontSize',15,'FontWeight','bold');
    title( comp1,'fontweight','bold');
  
        h_legend = legend(plotROID1, 'ROI');

    set(h_legend,'FontSize',15, 'Location','northeast');
    
    
    yScale = get(gca,'ylim');

        set(gca,'FontSize',15,'fontWeight','bold','LineWidth',3)

    box off
    
    if exist('cond3') == 1;
    subplot(1,3,2)
    else
    subplot(1,2,2)
    end
        plot(D2.time(tdx1:tdx2),squeeze(mean(D2.individual(:,:,tdx1:tdx2),1)),'color', [0 0.4470 0.7410]); hold on;

    plotROID2 = plot(D2.time(tdx1:tdx2),sqm2plotROID2,'r','LineWidth',3);hold on;

    plot([0 0], yScale,'k--','LineWidth',2);    
    set(gca,'Xlim', cfg.xlim,'ylim',yScale);
    set(gca,'XTick',[cfg.xlim(1):0.05:cfg.xlim(2)]); 
    set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
    xlabel('Time (ms)', 'FontSize',15,'FontWeight','bold');
    ylabel('Amplitude (µV)','FontSize',15,'FontWeight','bold');
    title(comp2 ,'fontweight','bold');

                h_legend = legend(plotROID2, 'ROI');

    set(h_legend,'FontSize',15, 'Location','northeast');
    
    if exist('cond3') == 1;
    subplot(1,3,3)
    plot(D3.time(tdx1:tdx2),squeeze(mean(D3.individual(:,:,tdx1:tdx2),1)),'color', [0 0.4470 0.7410]); grid on; hold on;
    plotROID3 = plot(D3.time(tdx1:tdx2),sqm2plotROID3,'r','LineWidth',2); grid on; hold on;

    plot([0 0], yScale,'k--','LineWidth',2);    
    set(gca,'Xlim', cfg.xlim,'ylim',yScale);
    set(gca,'XTick',[cfg.xlim(1):0.05:cfg.xlim(2)]); 
    set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
    xlabel('Time (ms)', 'FontSize',10,'FontWeight','bold');
    ylabel('Amplitude (µV)','FontSize',10,'FontWeight','bold');
    title(comp3 ,'fontweight','bold');
            h_legend = legend(plotROID3, 'F3 ROI');

    set(h_legend,'FontSize',10, 'Location','southeast');
    
    end
    
 
    set(gca,'FontSize',15,'fontWeight','bold','LineWidth',3)

    set(gcf, 'Position', [80 300 1800 450]);
    
% legend boxoff
box off

%%
    % TOPOPLOTs!!!!

D1.avg=squeeze(mean(D1.individual,1));
D2.avg=squeeze(mean(D2.individual,1));

if exist('cond3') == 1;
D3.avg=squeeze(mean(D3.individual,1));
end

if exist('cond3') == 1;
D1.prediff = D2.avg - D3.avg; %%% for diff conditions (for example, iTBS diff - cTBS diff)
end
D2.prediff = D2.avg - D1.avg; %%% better set D1 as Sham
if exist('cond3') == 1;
D3.prediff = D3.avg - D1.avg; %%% and D2 as iTBS maybe.
end

whichzlim = [-2 2];

N40time = [0.030 0.05]; 
P60time = [0.055 0.075]; 
N100time = [0.090 0.135]; 
P200time = [0.16 0.24];


%%%% TOPOPLOT D1

figure;
subplot(4,1,1);
cfg = [];
cfg.zlim = whichzlim; % [-0.5 0.5];
cfg.xlim = N40time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'avg';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D1);

subplot(4,1,2);
cfg = [];
cfg.zlim = whichzlim; %[-1 1];
cfg.xlim = P60time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'avg';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D1);

subplot(4,1,3);
cfg = [];
cfg.zlim = whichzlim;
cfg.xlim = N100time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'avg';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D1);


subplot(4,1,4);
cfg = [];
cfg.zlim = whichzlim;
cfg.xlim = P200time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'avg';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D1);



%%%% TOPOPLOT D2

figure;
subplot(4,1,1);
cfg = [];
cfg.zlim = whichzlim; 
cfg.xlim = N40time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'avg';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D2);

subplot(4,1,2);
cfg = [];
cfg.zlim = whichzlim;
cfg.xlim = P60time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'avg';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D2);

subplot(4,1,3);
cfg = [];
cfg.zlim = whichzlim;
cfg.xlim = N100time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'avg';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D2);


subplot(4,1,4);
cfg = [];
cfg.zlim = whichzlim;
cfg.xlim = P200time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'avg';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D2);




%% DIFFERENCES

% N40 Diff
figure;

subplot(4,1,1);
cfg = [];
cfg.zlim = [-1 1];%[-4 4];
cfg.xlim = N40time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'prediff';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D2);
title('Post-Pre N40' , 'fontsize',12,'fontweight','bold');
    
    
    
% P60 Diff

subplot(4,1,2);
cfg = [];
cfg.zlim = [-1 1];%[-4 4];
cfg.xlim = P60time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'prediff';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D2);
title('Post-Pre P60' , 'fontsize',12,'fontweight','bold');


subplot(4,1,3);
cfg = [];
cfg.zlim = [-1 1];%[-4 4];
cfg.xlim = N100time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'prediff';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D2);
title('Post-Pre N100' , 'fontsize',12,'fontweight','bold');
    
    
   
% P200 Diff

% figure;
subplot(4,1,4);
cfg = [];
cfg.zlim = [-1 1]; %[-5 5];
cfg.xlim = P200time;
cfg.comment='xlim';
cfg.commentpos = 'title';
cfg.layout = 'quickcap64.mat';
cfg.parameter = 'prediff';
cfg.channel = 'all';
cfg.colorbar = 'yes';
ft_topoplotER(cfg,D2);
title('Post-Pre P200' , 'fontsize',12,'fontweight','bold');







