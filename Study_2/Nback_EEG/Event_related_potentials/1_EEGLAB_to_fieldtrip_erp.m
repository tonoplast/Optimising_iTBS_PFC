clear; close all;

% this file converts eeglab files into fieldtrip
% 'type' chooses which trigger epoch to convert and analyse -- from '6_Nback_splitsaver.m'

% ##### SETTINGS #####

ID = {'101';'102';'103';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'} ; 
Sesh = {'50'; '75'; '100'}; % 50, 75 or 100% iTBS intensity
nback = {'2back';'3back'}; % 2 back or 3 back task
tp = {'T0';'T1'}; % 2 time points here -- before and after iTBS
type = {'CR';'CP'}; % which epoch (CR = correct response, CP = correct probe)

inPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\EXP1_ica_Nback_data\';
outPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\ERP\';
mkdir(outPath);


ft_defaults;

for x=1:size(ID,1)
    
    for y = 1:size(Sesh,1)
     
      for t = 1:size(type,1)

        for n = 1:size(nback,1)
                
             for z = 1:size(tp,1)
         
    %load EEGLAB data
    EEG = pop_loadset('filename', [ID{x,1},'_' Sesh{y,1} '_' type{t,1} '_' nback{n,1}, '_' tp{z,1} '.set'], 'filepath', [inPath,ID{x,1} filesep]);

    %convert to fieldtrip
    ftData = eeglab2fieldtrip(EEG, 'timelockanalysis');
    ftData.dimord = 'chan_time';
    
    %save
    filename = [ID{x,1} '_' Sesh{y,1} '_' type{t,1} '_' nback{n,1} '_' tp{z,1} '_ft'];

    save([outPath,filename],'ftData');
    
    fprintf('%s''s data converted from eeglab to fieldtrip\n', [ID{x,1} '_' Sesh{y,1} '_' type{t,1} '_' nback{n,1} '_' tp{z,1}]); 
    
                end
            end
        end
    end
end
