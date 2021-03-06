clear; close all; clc;
tic

% Regiong of Interest (ROI) preparation for LICI

%SETTINGS
ID = {'H001'; 'H002'; 'H003'; 'H004'; 'H005'; 'H006' ; 'H007' ; 'H008' ; 'H009' ; 'H010'};
Sesh = {'cTBS';'iTBS';'SH'};
tp = {'T0';'T1'};

% electrodes of interest (average of these)
elec = {'F3', 'F1', 'FC3' , 'FC1'};

inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\';
outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\ROI\';
cd(inPath);

time = -1000:1:1000;
fs = 1000;

%% Peak settings %%
peaks_neg = [40 115];
peak_window_neg = [10 25];

peaks_pos = [65 200];
peak_window_pos = [10 40];

peak_replace_neg = [40 120];
peak_replace_pos = [60 200];

%%
%Calculate ROI

clear ROI;
tic


for x = 1:size(ID,1)
     
    for y = 1:size(Sesh,1)
        
        for z = 1:size(tp,1)
        %LOAD DATA 
        
        EEG = pop_loadset('filename',[ID{x,1} '_PPTMS_' Sesh{y,1} '_LICI_' tp{z,1} '.set'], 'filepath',[inPath filesep ID{x,1} filesep Sesh{y,1} filesep]);
        load ([inPath filesep ID{x,1} filesep Sesh{y,1} filesep [ID{x,1} '_' Sesh{y,1} '_'  tp{z,1} '_PP_final_LICI']]);
       
       
        %CALCULATE ROI
                ROI.(ID{x,1}).(Sesh{y,1}).(tp{z,1}) = ROI_analysis(LICI,EEG.chanlocs,elec); %electrodes of interest

        
        end
    end
end

toc

%%
%CALCULATE PEAKS


for x = 1:size(ID,1)
     
    for y = 1:size(Sesh,1)
        
        for z = 1:size(tp,1)
            

       ROI.(ID{x,1}).(Sesh{y,1}).(tp{z,1}) = peak_detection_negative(ROI.(ID{x,1}).(Sesh{y,1}).(tp{z,1}),time,fs,peaks_neg,peak_window_neg,peak_replace_neg);
       ROI.(ID{x,1}).(Sesh{y,1}).(tp{z,1}) = peak_detection_positive(ROI.(ID{x,1}).(Sesh{y,1}).(tp{z,1}),time,fs,peaks_pos,peak_window_pos,peak_replace_pos);
    
            end
       end
end




%%
%CHECK PEAKS

for x = 1:size(ID,1)
     
    for y = 1:size(Sesh,1)
        
        for z = 1:size(tp,1)
         
         ROI.(ID{x,1}).(Sesh{y,1}).(tp{z,1}) = peak_check(ROI.(ID{x,1}).(Sesh{y,1}).(tp{z,1}),time);
       
    end
  end
end

%%
save([outPath 'ROI_analysis_PP_LICI_' strjoin(elec, '_')], 'ROI');
