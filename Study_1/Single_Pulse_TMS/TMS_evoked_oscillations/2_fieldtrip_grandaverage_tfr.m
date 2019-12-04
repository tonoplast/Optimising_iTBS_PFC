clear ; close all; clc;

% ##### GRAND AVERAGE TIME FREQUENCY ANALYSIS #####

% This script converts single fieldtrip files in to a grand average which
% is required for input in to the cluster-based permutation statistics
% script.


% ##### SETTINGS #####

ID = {'H001'; 'H002'; 'H003'; 'H004'; 'H005'; 'H006' ; 'H007' ; 'H008' ; 'H009' ; 'H010'};
Sesh = {'cTBS'; 'iTBS'; 'SH'};
tp = {'T0';'T1'};

inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';
outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';


% ##### SCRIPT #####

ft_defaults;


 for z = 1:size(tp,1);
 
     for y = 1:size(Sesh,1);
                 
            for x=1:size(ID,1);
                
    load([inPath,[ID{x,1},'_SPTMS_' Sesh{y,1} '_final_' tp{z,1}, '_ftWaveBc']])
    

    
    %create structure
    ALL.(ID{x,1}) = ftWaveBc;
        end


%Perform grand average
cfg=[];
cfg.keepindividual = 'yes';


%IMPOTANT! Check that number of id{x,1} is equal to number of participants
grandAverage = ft_freqgrandaverage(cfg,...
        ALL.(ID{1,1}),...
        ALL.(ID{2,1}),...
        ALL.(ID{3,1}),...
        ALL.(ID{4,1}),...
        ALL.(ID{5,1}),...
        ALL.(ID{6,1}),...
        ALL.(ID{7,1}),...
        ALL.(ID{8,1}),...
        ALL.(ID{9,1}),...
        ALL.(ID{10,1}));

%Checks that the number of participants is correct
if size(ID,1) ~= size(grandAverage.powspctrm,1)
    error('Number of participants in grandAverage does not match number of participants in ID. Data not saved');
end



%Save data
save([outPath,['SPTMS_' Sesh{y,1} '_final_' tp{z,1} '_ftWaveBc_ga']],'grandAverage');

    end
end

