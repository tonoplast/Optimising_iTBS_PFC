clear; close all; clc;

%%This will create TEP waveforms to visualise singple-pulse and paired-pulse together for both before and after

% choose which one to visualise
Sesh = 'iTBS'; % 'SH' , 'iTBS' , 'cTBS'

% pre
cond1 = ['SPTMS_' Sesh '_final_T0']; % single
cond2 = ['PPTMS_' Sesh '_final_T0']; % paired 

% post
cond3 = ['SPTMS_' Sesh '_final_T1']; % single
cond4 = ['PPTMS_' Sesh '_final_T1']; % paired

%Path
inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\ROI\ft\';


% figure legends
comp1 = 'Pre-SP';
comp2 = 'Pre-PP';

comp3 = 'Post-SP';
comp4 = 'Post-PP';


xtick = 0.05;

ploterrorbars = 0 ; % [1 | 2 | 0] - ['SEM'| '95% CI' | 'none' ]

% box setting for peaks
N40bar = 1;
P60bar = 1; % [1|0] - 1 is yes
N100bar = 1; % [1|0] - 0 is no
P200bar = 1;

N40time = [0.030 0.05]; 
P60time = [0.055 0.075]; 
N100time = [0.090 0.140]; 
P200time = [0.16 0.24];


% last graph (for publication) peak amplitude
ymin = -6; ymax = 6;
gmfaymin = 0; gmfaymax = 6;

ft_defaults;


% loading files
filename1 = [cond1,'_ft_ga'];
load([inPath,filename1]);
D1 = grandAverage;

filename2 = [cond2,'_ft_ga'];
load([inPath,filename2]);
D2 = grandAverage;

filename3 = [cond3,'_ft_ga'];
load([inPath,filename3]);
D3 = grandAverage;

filename4 = [cond4,'_ft_ga'];
load([inPath,filename4]);
D4 = grandAverage;




% channels of interest
cfg = [];
cfg.channel     =  {'F3','FC3','F1','FC1'};
cfg.xlim = [-0.05 0.50];



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

%%%%%

avgD3 = mean(D3.individual); %average across participants of D1
sqavgD3 = squeeze(avgD3);    %Squeezing (getting rid of 1 dimention)

StdevD3 = std(D3.individual); SEMD3 = std(D3.individual)/sqrt(size((D3.individual),1)); CI95D3 = 1.96 * SEMD3; % Stdev , SEM , CI95
sqStdevD3 = squeeze(StdevD3); sqSEMD3 = squeeze(SEMD3); sqCI95D3 = squeeze(CI95D3);

avgD4 = mean(D4.individual); %average across participants of D2
sqavgD4 = squeeze(avgD4);    %Squeezing (getting rid of 1 dimention)

StdevD4 = std(D4.individual); SEMD4 = std(D4.individual)/sqrt(size((D4.individual),1)); CI95D4 = 1.96 * SEMD4;% Stdev and SEM
sqStdevD4 = squeeze(StdevD4); sqSEMD4 = squeeze(SEMD4); sqCI95D4 = squeeze(CI95D4);



indsqavgD1 = sqavgD1(chanidx,:); %finding only D1 data of channels (from cfg.channel designated above)
indsqavgD2 = sqavgD2(chanidx,:); %finding only D2 data of channels (from cfg.channel designated above)
indsqavgD3 = sqavgD3(chanidx,:); %finding only D1 data of channels (from cfg.channel designated above)
indsqavgD4 = sqavgD4(chanidx,:); %finding only D2 data of channels (from cfg.channel designated above)

indsqStdevD1 = sqStdevD1(chanidx,:); indsqSEMD1 = sqSEMD1(chanidx,:); indsqCI95D1 = sqCI95D1(chanidx,:);
indsqStdevD2 = sqStdevD2(chanidx,:); indsqSEMD2 = sqSEMD2(chanidx,:); indsqCI95D2 = sqCI95D2(chanidx,:);
indsqStdevD3 = sqStdevD3(chanidx,:); indsqSEMD3 = sqSEMD3(chanidx,:); indsqCI95D3 = sqCI95D3(chanidx,:);
indsqStdevD4 = sqStdevD4(chanidx,:); indsqSEMD4 = sqSEMD4(chanidx,:); indsqCI95D4 = sqCI95D4(chanidx,:);

avgindsqavgD1 = mean(indsqavgD1); % averaging those found D1 data
avgindsqavgD2 = mean(indsqavgD2); % averaging those found D2 data
avgindsqavgD3 = mean(indsqavgD3); % averaging those found D1 data
avgindsqavgD4 = mean(indsqavgD4); % averaging those found D2 data

avgindsqStdevD1 = mean(indsqStdevD1); avgindsqSEMD1 = mean(indsqSEMD1); avgindsqCI95D1 = mean(sqCI95D1);
avgindsqStdevD2 = mean(indsqStdevD2); avgindsqSEMD2 = mean(indsqSEMD2); avgindsqCI95D2 = mean(sqCI95D2);
avgindsqStdevD3 = mean(indsqStdevD3); avgindsqSEMD3 = mean(indsqSEMD3); avgindsqCI95D3 = mean(sqCI95D3);
avgindsqStdevD4 = mean(indsqStdevD4); avgindsqSEMD4 = mean(indsqSEMD4); avgindsqCI95D4 = mean(sqCI95D4);


d1t = round(D1.time,4); % rounding up decimals to 4
tdx1 = find(d1t == t1); % finding where it is
tdx2 = find(d1t == t2); % finding where it is

   

%%


% graph settings. 
figure;
plot(D1.time(tdx1:tdx2), avgindsqavgD1(tdx1:tdx2), 'b--', 'LineWidth',2); hold on;
plot(D2.time(tdx1:tdx2), avgindsqavgD2(tdx1:tdx2), 'r--', 'LineWidth',2); hold on;
plot(D3.time(tdx1:tdx2), avgindsqavgD3(tdx1:tdx2), 'b', 'LineWidth',3); hold on;
plot(D4.time(tdx1:tdx2), avgindsqavgD4(tdx1:tdx2), 'r', 'LineWidth',3); hold on;



if ploterrorbars == 1
SEMfill1 = fill([D1.time(tdx1:tdx2),fliplr(D1.time(tdx1:tdx2))],[avgindsqavgD1(tdx1:tdx2)-avgindsqSEMD1(tdx1:tdx2),fliplr(avgindsqavgD1(tdx1:tdx2)+avgindsqSEMD1(tdx1:tdx2))], 'b');
set(SEMfill1, 'FaceAlpha' ,0.1); set(SEMfill1,'EdgeColor', 'none');
SEMfill2 = fill([D2.time(tdx1:tdx2),fliplr(D2.time(tdx1:tdx2))],[avgindsqavgD2(tdx1:tdx2)-avgindsqSEMD2(tdx1:tdx2),fliplr(avgindsqavgD2(tdx1:tdx2)+avgindsqSEMD2(tdx1:tdx2))], 'r');
set(SEMfill2, 'FaceAlpha' ,0.1); set(SEMfill2, 'EdgeColor', 'none');
SEMfill3 = fill([D3.time(tdx1:tdx2),fliplr(D3.time(tdx1:tdx2))],[avgindsqavgD3(tdx1:tdx2)-avgindsqSEMD3(tdx1:tdx2),fliplr(avgindsqavgD3(tdx1:tdx2)+avgindsqSEMD3(tdx1:tdx2))], 'g');
set(SEMfill3, 'FaceAlpha' ,0.1); set(SEMfill3, 'EdgeColor', 'none');
SEMfill4 = fill([D4.time(tdx1:tdx2),fliplr(D4.time(tdx1:tdx2))],[avgindsqavgD4(tdx1:tdx2)-avgindsqSEMD4(tdx1:tdx2),fliplr(avgindsqavgD4(tdx1:tdx2)+avgindsqSEMD4(tdx1:tdx2))], 'k');
set(SEMfill4, 'FaceAlpha' ,0.1); set(SEMfill4, 'EdgeColor', 'none');

else
end


if ploterrorbars == 2
SEMfill1 = fill([D1.time(tdx1:tdx2),fliplr(D1.time(tdx1:tdx2))],[avgindsqavgD1(tdx1:tdx2)-avgindsqCI95D1(tdx1:tdx2),fliplr(avgindsqavgD1(tdx1:tdx2)+avgindsqCI95D1(tdx1:tdx2))], 'b');
set(SEMfill1, 'FaceAlpha' ,0.1); set(SEMfill1, 'EdgeColor', 'none');
SEMfill2 = fill([D2.time(tdx1:tdx2),fliplr(D2.time(tdx1:tdx2))],[avgindsqavgD2(tdx1:tdx2)-avgindsqCI95D2(tdx1:tdx2),fliplr(avgindsqavgD2(tdx1:tdx2)+avgindsqCI95D2(tdx1:tdx2))], 'r');
set(SEMfill2, 'FaceAlpha' ,0.1); set(SEMfill2, 'EdgeColor', 'none');
else
end


axis([cfg.xlim(1) cfg.xlim(2) ymin ymax]);    % axis[xmin xmax ymin ymax] 
labels = t1*1000:xtick*1000:t2*1000;
set(gca,'XTick',[cfg.xlim(1):xtick:cfg.xlim(2)]); 

set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
set(gca,'FontSize',24)
xlabel('Time (ms)', 'FontSize',24,'FontWeight','bold');
ylabel('Amplitude (µV)','FontSize',24,'FontWeight','bold');
h_legend = legend(comp1,comp2,comp3,comp4);
set(h_legend,'FontSize',20, 'Location','northeast');
set(gca,'FontSize',24,'fontWeight','bold','LineWidth',3)
set(findall(gcf,'type','text'),'FontSize',25,'fontWeight','bold')

legend boxoff
box off



% this is line at 0
refline = 1;
refposition = [0 0]; 
refposition2 = [-100 -100]; 

if refline >0
    h = line(refposition, get(gca, 'YLim'), 'Color', [0 0 0],'LineStyle',':', 'LineWidth',3);
  if refline==2
    h = line(refposition2, get(gca, 'YLim'), 'Color', [0 0 0],'LineStyle',':','LineWidth',3);
  end
end 


% creating a box
if N40bar == 1
xN40 = [N40time(1) N40time(2) N40time(2) N40time(1)];
y = [ymin ymin ymax ymax];
p1=patch(xN40,y,'r');
set(p1,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end

if P60bar == 1
xP60 = [P60time(1) P60time(2) P60time(2) P60time(1)];
y = [ymin ymin ymax ymax];
p2=patch(xP60,y,'r');
set(p2,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end


if N100bar == 1 
xN100 = [N100time(1) N100time(2) N100time(2) N100time(1)];
y = [ymin ymin ymax ymax];
p3=patch(xN100,y,'r');
set(p3,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end


if P200bar == 1 
xP200 = [P200time(1) P200time(2) P200time(2) P200time(1)];
y = [ymin ymin ymax ymax];
p4=patch(xP200,y,'r');
set(p4,'FaceAlpha',0.1, 'FaceColor','k', 'EdgeColor','none');
else
end


    set(gcf, 'Position', [350 300 1000 600]);

    


