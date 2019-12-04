clear; close all;

% This script converts eeglab files in to field trip files and then performs
% a Morlet wavelet time frequency analysis on the data.

% ##### SETTINGS #####
ID = {'H001'; 'H002'; 'H003'; 'H004'; 'H005'; 'H006' ; 'H007' ; 'H008' ; 'H009' ; 'H010'};

Sesh = {'cTBS'; 'iTBS'; 'SH'};

tp = {'T0';'T1'};

inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\';
outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';

mkdir(outPath);
%%

ft_defaults;

for x=1:size(ID,1);
    
    for y = 1:size(Sesh,1);
        
        for z = 1:size(tp,1);
    
 
    %load EEGLAB data
    EEG = pop_loadset('filename', [ID{x,1},'_SPTMS_' Sesh{y,1} '_final_' tp{z,1},'.set'], 'filepath', [inPath,ID{x,1},filesep, Sesh{y,1}]);

    %convert to fieldtrip
    ftData = eeglab2fieldtrip(EEG, 'preprocessing');
    
    %Time-frequency analysis (frequency-dependent window) - wavelet

    cfg = [];
    cfg.channel = {'all'};
    cfg.method = 'wavelet';
    cfg.width = 3.5; % 3.5;
    cfg.output = 'pow';
    cfg.foi = [5:1:70];
    cfg.toi = -0.65:0.001:0.65;
    
    

    ftWave = ft_freqanalysis(cfg,ftData);
    
    %Subtracted from baseline
    cfg = [];
    cfg.baseline = [-0.65 -0.35];
    cfg.baselinetype = 'relative'; 
    
    ftWaveBc = ft_freqbaseline(cfg,ftWave);
    
    
    
    %%
    %Plot to check
  
% %     cfg=[];
% %     cfg.maskstlye= 'saturation';
% %     cfg.xlim=[-0.1 0.3];
% % %     cfg.zlim=[-0.3 0.3];
% % 
% %     cfg.channel= {'AF3' , 'F3' , 'F1' , 'FC3' , 'F5'};
% %     cfg.colorbar='yes';
% %     
% %     figure;
% %     subplot(2,1,1); ft_singleplotTFR(cfg, ftWaveBc);
% %     
% %     
% % %     cfg.ylim = [5 45];
% % %      cfg.ylim = [8 12]; % Frequency band of interest
% % %      cfg.ylim = [13 20];
% % %      cfg.ylim = [12 30];
% % %      cfg.ylim = [31 45];
% %     
% %     subplot(2,1,2); ft_topoplotTFR(cfg, ftWaveBc);
% %     
    

    
    %%
    %save
    save([outPath,[ID{x,1},'_SPTMS_' Sesh{y,1} '_final_' tp{z,1}, '_ftWaveBc']],'ftWave','ftWaveBc');


    fprintf('%s''s data converted from eeglab to fieldtrip, wavelet analysis performed, baseline correction\n', [ID{x,1} '_' Sesh{y,1} '_' tp{z,1}]); 
    
        end;
    end
end

