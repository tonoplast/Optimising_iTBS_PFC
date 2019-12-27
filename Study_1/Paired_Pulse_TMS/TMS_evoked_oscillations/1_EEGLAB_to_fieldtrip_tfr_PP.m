clear; close all;

% This script converts eeglab files in to field trip files and then performs
% a Morlet wavelet time frequency analysis on the data -- Paired Pulse data

% ##### SETTINGS #####

ID = {'H001'; 'H002'; 'H003'; 'H004'; 'H005'; 'H006' ; 'H007' ; 'H008' ; 'H009' ; 'H010'};

Sesh = {'cTBS'; 'iTBS'; 'SH'};

tp = {'T0';'T1'};


inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\';
outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';

mkdir(outPath);
%%

ft_defaults;

for x=1:size(ID,1)
    
    for y = 1:size(Sesh,1)
        
        for z = 1:size(tp,1)
    
 
    %load EEGLAB data
    EEG = pop_loadset('filename', [ID{x,1},'_PPTMS_' Sesh{y,1} '_final_' tp{z,1},'.set'], 'filepath', [inPath,ID{x,1},filesep, Sesh{y,1}]);
    
    %convert to fieldtrip
    ftData = eeglab2fieldtrip(EEG, 'preprocessing');
    
    %Time-frequency analysis (frequency-dependent window) - wavelet
    cfg = [];
    cfg.channel = {'all'};
    cfg.method = 'wavelet';
    cfg.width = 3.5;
    cfg.output = 'pow';
    cfg.foi = [5:1:70];
    cfg.toi = -0.65:0.001:0.65;

    

    ftWave = ft_freqanalysis(cfg,ftData);
    
    %Subtracted from baseline
    cfg = [];
    cfg.baseline = [-0.65 -0.35]; 
    cfg.baselinetype = 'relative'; %'relchange';% 'absolute'; 'db'
    
    ftWaveBc = ft_freqbaseline(cfg,ftWave);
    
    
    %%
    %save


    save([outPath,[ID{x,1},'_PPTMS_' Sesh{y,1} '_final_' tp{z,1}, '_ftWaveBc']],'ftWave','ftWaveBc');
    
    fprintf('%s''s data converted from eeglab to fieldtrip, wavelet analysis performed, baseline correction\n', [ID{x,1} '_' Sesh{y,1} '_' tp{z,1}]); 
    
        end;
    end
end

