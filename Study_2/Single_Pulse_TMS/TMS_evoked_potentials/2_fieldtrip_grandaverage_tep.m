clear;

% ##### GRAND AVERAGE TEPS #####
% This script converts single fieldtrip files in to a grand average which
% is required for input in to the cluster-based permutation statistics
% script.
%
% IMPORTANT!!!
% Before running the script, make sure that the number of id{x,1} is equal 
% the to number of participants.

% ##### SETTINGS #####

ID = {'101';'102';'103';'104';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'};

Sesh= {'50'; '75'; '100'};

tp = {'T0' ; 'T1'; 'T2'};

inPath = 'F:\Data\EEG\1_Intensity\ROI\';

% ##### SCRIPT #####

ft_defaults;

 for z = 1:size(tp,1)
     
    for y = 1:size(Sesh,1)
        
               for x = 1:size(ID,1)

    filename = [ID{x,1} '_TMSEEG_' Sesh{y,1} '_final_' tp{z,1} '_ft'];

    %load file
    load([inPath,filename]);
    %create structure
    id{x,1} = ['H_' ID{x,1}];
    ALL.(id{x,1}) = ftData;

               end
%%

%Perform grand average
cfg=[];
cfg.keepindividual = 'yes';

%IMPOTANT! Check that number of id{x,1} is equal to number of participants
grandAverage = ft_timelockgrandaverage(cfg,...
        ALL.(id{1,1}),...
        ALL.(id{2,1}),...
        ALL.(id{3,1}),...
        ALL.(id{4,1}),...
        ALL.(id{5,1}),...
        ALL.(id{6,1}),...
        ALL.(id{7,1}),...
        ALL.(id{8,1}),...
        ALL.(id{9,1}),...
        ALL.(id{10,1}),...
        ALL.(id{11,1}),...
        ALL.(id{12,1}),...
        ALL.(id{13,1}),...
        ALL.(id{14,1}),...
        ALL.(id{15,1}),...
        ALL.(id{16,1}));
        
%Checks that the number of participants is correct
if size(ID,1) ~= size(grandAverage.individual,1)
    error('Number of participants in grandAverage does not match number of participants in ID. Data not saved');
end

%set filename
filename = ['TMSEEG_' Sesh{y,1} '_final_' tp{z,1} '_ft_ga'];

%Save data
save([inPath,filename],'grandAverage');
    
    end
        
end
