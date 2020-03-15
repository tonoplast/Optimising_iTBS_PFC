% This script converts eeglab files in to field trip files and then performs
% a Morlet wavelet time frequency analysis on the data. It will work
% for single pulse data and for uncorrected paired pulse data

% ##### SETTINGS #####
ID = {'101';'102';'103';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'} ;
Sesh = {'50'; '75'; '100'};
nback = {'2back';'3back'};
tp = {'T0';'T1'};
type = {'CR';'CP'};

inPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\EXP1_ica_Nback_data\';
outPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\Freq\';
mkdir(outPath);

%%
eeglab;
ft_defaults;

for x=1:size(ID,1)    
    
    for y = 1:size(Sesh,1)
        
        for t = 1:size(type,1)
            
                for n = 1:size(nback,1)
        
                    for z = 1:size(tp,1)
  
    %load EEGLAB data
    EEG = pop_loadset('filename', [ID{x,1},'_' Sesh{y,1} '_' type{t,1} '_' nback{n,1},'_' tp{z,1}  '.set'], 'filepath', [inPath,ID{x,1} filesep]);
    
    %convert to fieldtrip
    ftData = eeglab2fieldtrip(EEG, 'preprocessing');
    
    %Time-frequency analysis (frequency-dependent window) - wavelet
  
cfg = [];
cfg.output     = 'pow';
cfg.channel    =  {'all'};
cfg.method     = 'wavelet';
cfg.polyremoval = 1;
cfg.foi        = 2:0.5:80;
cfg.width      = 3.5; 
cfg.toi        = -1.95:0.005:1.95;

ftWave = ft_freqanalysis(cfg,ftData);


%Subtracted from baseline 
    cfg = [];
    cfg.baseline = [-0.65 -0.35];
    cfg.baselinetype = 'relative';% 'relchange'% 'db';%'absolute';
    
    ftWaveBc = ft_freqbaseline(cfg,ftWave);
    %%
    %save
ftWave.info = {ID{x,1},Sesh{y,1},type{t,1},nback{n,1},tp{z,1}};
ftWaveBc.info = {ID{x,1},Sesh{y,1},type{t,1},nback{n,1},tp{z,1}};
ftWave.nback =EEG.nback ;
ftWaveBc.nback =EEG.nback ;
    save([outPath,[ID{x,1},'_' Sesh{y,1} '_' type{t,1} '_' nback{n,1} '_' tp{z,1}, '_ftWaveBc']],'ftWave','ftWaveBc');
    
    fprintf('%s''s data converted from eeglab to fieldtrip, wavelet analysis performed, baseline correction\n', [ID{x,1} '_' Sesh{y,1} '_' type{t,1} '_' nback{n,1} '_' tp{z,1}]); 
    
     end
    end
    end
    end
end
