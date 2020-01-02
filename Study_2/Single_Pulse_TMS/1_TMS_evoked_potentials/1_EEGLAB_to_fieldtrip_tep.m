clear;

% This script converts eeglab files in to field trip files.

% ##### SETTINGS #####

ID = {'101';'102';'103';'104';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'};

inPath = 'F:\Data\EEG\1_Intensity\SP_analysis\';

cd(inPath)

Sesh= {'50'; '75'; '100'}; % 3 intensity conditions
tp = {'T0' ; 'T1' ; 'T2'}; % 3 time-points (T0 = before, T1 = 5-min post, T2 = 30-min post iTBS)

outPath = 'F:\Data\EEG\1_Intensity\ROI\';
mkdir(outPath);

% ##### fieldtrip #####

ft_defaults;

for x = 1:size(ID,1)
     
    for y = 1:size(Sesh,1)
        
        for z = 1:size(tp,1)
    
    
    %load EEGLAB data
    EEG = pop_loadset('filename',[ID{x,1} '_TMSEEG_' Sesh{y,1} '_final_' tp{z,1} '.set'], 'filepath',[inPath filesep ID{x,1} filesep]);

    
    %convert to fieldtrip
    ftData = eeglab2fieldtrip(EEG, 'timelockanalysis');
    ftData.dimord = 'chan_time';
    
    %save   
    filename = [ID{x,1} '_TMSEEG_' Sesh{y,1} '_final_' tp{z,1} '_ft'];
    
    save([outPath,filename],'ftData');
    
    fprintf('%s''s data converted from eeglab to fieldtrip\n', [ID{x,1} '_' Sesh{y,1} '_' tp{z,1}]); 
    
        end
    end
end

