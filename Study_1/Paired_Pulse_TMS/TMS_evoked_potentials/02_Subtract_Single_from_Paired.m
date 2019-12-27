clear; close all; clc;

%This script will subtract single-pulse TEPs from Paired-Pulse TEPs
%SETTINGS

inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\';
outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\';

tp = {'T0';'T1'};

Sesh = {'cTBS';'iTBS';'SH'};

time = -1000:1:1000;

fs = 1000; %note that sample rate is 1000

ID= {'H001'; 'H002'; 'H003'; 'H004'; 'H005'; 'H006' ; 'H007' ; 'H008' ; 'H009' ; 'H010'};


for x = 1:size(ID,1)
    
    for y = 1:size(Sesh,1)
        
        for z = 1:size(tp,1)

        %LOAD DATA
        %Single-pulse data
        EEG = pop_loadset('filename',[ID{x,1} '_SPTMS_' Sesh{y,1} '_final_' tp{z,1} '.set'], 'filepath',[inPath filesep ID{x,1} filesep Sesh{y,1} filesep]);
        S = EEG;
        %Paired-pulse data
        EEG = pop_loadset('filename',[ID{x,1} '_PPTMS_' Sesh{y,1} '_final_' tp{z,1} '.set'], 'filepath',[inPath filesep ID{x,1} filesep Sesh{y,1} filesep]);
        P = EEG;
             
        %Take average over trials
        avgS = nanmean(S.data,3);
        avgP = nanmean(P.data,3);
        
        %Reallign single test pulse with paired conditioning pulse
        avgS(:,1:100)=[];
        avgP(:,1901:2000)=[];
        
        %Subtract single from paired
        avgPC = avgP-avgS;
        avgPC(:,1901:2000) = NaN;
          
        %save
        save([outPath filesep ID{x,1} filesep Sesh{y,1} filesep [ID{x,1} '_' Sesh{y,1} '_'  tp{z,1} '_PP_final_corrected']], 'avgPC');
        
        
    t1 = -300;
    t2 = 600;
    tp1 = find(EEG.times == t1);
    tp2 = find(EEG.times == t2);
    
    
% Plotting to check       
    
    COI = {EEG.chanlocs.labels};  % channel of interest
    IND = 14; % change the number for the channel of interest
    
    figure;
    
    plot(EEG.times(:,tp1:tp2), avgPC(IND,tp1:tp2),'k'); hold on;
    plot(EEG.times(:,tp1:tp2), avgS(IND,tp1:tp2),'r') ; hold on;

    title([ID{x,1}, '__' Sesh{y,1} '__' tp{z,1} '_' COI{IND}]);
    legend(['PP_' tp{z,1}], ['SP_' tp{z,1}]);
    

      end    
   end
end

