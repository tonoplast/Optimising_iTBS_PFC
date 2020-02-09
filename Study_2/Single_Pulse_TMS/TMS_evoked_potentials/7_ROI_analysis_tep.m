clear; close all; clc;
tic
%SETTINGS

ID = {'101';'102';'103';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'};

Sesh = {'50';'75';'100'};
    
timePoint = {'T0';'T1';'T2'};

elec = {'FC1','FCZ','FC2'};

inPath = 'F:\Data\EEG\1_Intensity\SP_analysis\';
outPath = 'F:\Data\EEG\1_Intensity\ROI\stats\';

time = -1000:1:1000;
fs = 1000;

peaks_neg = [45 120];
peak_window_neg = [15 35];

peaks_pos = [65 200];
peak_window_pos = [20 40];

peak_replace_neg = [44 120];
peak_replace_pos = [60 200];

%%


%Calculate ROI / extract time series

clear ROI;
tic


for x = 1:size(ID,1)
     
    for y = 1:size(Sesh,1)
        
        for z = 1:size(timePoint,1)
        %LOAD DATA 
        EEG = pop_loadset('filename', [ID{x,1} '_TMSEEG_' Sesh{y,1} '_' 'final_' timePoint{z,1} '.set'], 'filepath',[inPath ID{x,1} filesep]);
        
        %CALCULATE ROI
        id = (['H_' ID{x,1}]);
        s = (['S_' Sesh{y,1}]);
        
        ROI.(id).(s).(timePoint{z,1}) = ROI_analysis(EEG.data,EEG.chanlocs,elec); %electrodes of interest
        end
    end
end

toc

%%

%CALCULATE PEAKS

for x = 1:size(ID,1)
     
    for y = 1:size(Sesh,1)
        
        for z = 1:size(timePoint,1)
            
        id = (['H_' ID{x,1}]);
        s = (['S_' Sesh{y,1}]);
                   
       ROI.(id).(s).(timePoint{z,1}) = peak_detection_negative(ROI.(id).(s).(timePoint{z,1}),time,fs,peaks_neg,peak_window_neg,peak_replace_neg);
       ROI.(id).(s).(timePoint{z,1}) = peak_detection_positive(ROI.(id).(s).(timePoint{z,1}),time,fs,peaks_pos,peak_window_pos,peak_replace_pos);
            end
      end
end





%%

%CHECK PEAKS

for x = 1:size(ID,1)
     
    for y = 1:size(Sesh,1)
        
        for z = 1:size(timePoint,1)
         
        id = (['H_' ID{x,1}]);
        s = (['S_' Sesh{y,1}]);
        
        ROI.(id).(s).(timePoint{z,1}) = peak_check(ROI.(id).(s).(timePoint{z,1}),time);
       
    end
  end
end


%%
save([outPath 'ROI_analysis_Intensity_' strjoin(elec, '_')], 'ROI');


