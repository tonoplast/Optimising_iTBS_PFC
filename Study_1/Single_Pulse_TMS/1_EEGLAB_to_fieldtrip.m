clear;

% This script converts eeglab files in to field trip files.

% ##### SETTINGS #####

ID = {'H001'; 'H002'; 'H003'; 'H004';'H005';'H006'; 'H007';'H008';'H009';'H010'};

inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\';
outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\ROI\ft\';

mkdir(outPath);

Sesh= {'cTBS'; 'iTBS'; 'SH'};

tp = {'T0' ; 'T1'};


% ##### SCRIPT #####

% load fieldtrip

ft_defaults;

for x = 1:size(ID,1)
     
    for y = 1:size(Sesh,1)
        
        for z = 1:size(tp,1)
    
    
    %load EEGLAB data
    EEG = pop_loadset('filename',[ID{x,1} '_SPTMS_' Sesh{y,1} '_final_' tp{z,1} '.set'], 'filepath',[inPath filesep ID{x,1} filesep Sesh{y,1} filesep])
   
    
    EEG = pop_saveset(EEG, 'filename',[ID{x,1} '_SPTMS_' Sesh{y,1} '_final_DBC_' tp{z,1} '.set'], 'filepath',[inPath filesep ID{x,1} filesep Sesh{y,1} filesep]);
    EEG = eeg_checkset( EEG );
    
    %convert to fieldtrip
    ftData = eeglab2fieldtrip(EEG, 'timelockanalysis');
    ftData.dimord = 'chan_time';
    
    %save
  
    filename = [ID{x,1} '_SPTMS_' Sesh{y,1} '_final_' tp{z,1} '_ft'];
    

    save([outPath,filename],'ftData');
    
    fprintf('%s''s data converted from eeglab to fieldtrip\n', [ID{x,1} '_' Sesh{y,1} '_' tp{z,1}]); 
    
        end
    end
end

