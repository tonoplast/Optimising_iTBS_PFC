clear; close all;

% This script converts eeglab files in to field trip files and then performs
% a Morlet wavelet time frequency analysis on the data.

% ##### SETTINGS #####
ID = {'101';'102';'103';'104';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'};

Sesh= {'50'; '75'; '100'};

tp = {'T0' ; 'T1'; 'T2'};

inPath = 'F:\Data\EEG\1_Intensity\SP_analysis';
outPath = 'F:\Data\EEG\1_Intensity\ROI\Freq_analysis\'

mkdir(outPath);
cd(outPath)
%%

ft_defaults;

for x=1:size(ID,1);
    
    for y = 1:size(Sesh,1);
        
        for z = 1:size(tp,1);
    
 
    %load EEGLAB data
    EEG = pop_loadset('filename',[ID{x,1} '_TMSEEG_' Sesh{y,1} '_final_' tp{z,1} '.set'], 'filepath',[inPath filesep ID{x,1} filesep]);

    %convert to fieldtrip
    ftData = eeglab2fieldtrip(EEG, 'preprocessing');
    
    %Time-frequency analysis (frequency-dependent window) - wavelet

    cfg = [];
    cfg.channel = {'all'};
    cfg.method = 'wavelet';
    cfg.width = 3.5; % 3.5;
    cfg.output = 'pow';
    cfg.foi = [2:1:80];
    cfg.toi = -1.00:0.001:1.00;
    
    
    ftWave = ft_freqanalysis(cfg,ftData);
    
    %Subtracted from baseline
    cfg = [];
    cfg.baseline = [-0.65 -0.35];
    cfg.baselinetype = 'relative'; 
    
    ftWaveBc = ft_freqbaseline(cfg,ftWave);
    
     
    %%
    %save
        save([outPath,[ID{x,1},'_TMSEEG_' Sesh{y,1} '_final_' tp{z,1}, '_ftWaveBc']],'ftWaveBc');

    fprintf('%s''s data converted from eeglab to fieldtrip, wavelet analysis performed, baseline correction\n', [ID{x,1} '_' Sesh{y,1} '_' tp{z,1}]); 
    
        end
    end
end

