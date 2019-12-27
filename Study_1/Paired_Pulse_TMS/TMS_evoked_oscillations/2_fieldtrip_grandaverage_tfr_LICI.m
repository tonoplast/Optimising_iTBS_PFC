clear; close all;
% ##### GRAND AVERAGE TIME FREQUENCY ANALYSIS #####

% This script converts single fieldtrip files in to a grand average which
% is required for input in to the cluster-based permutation statistics
% script.
% this is for LICI


% ##### SETTINGS #####

ID = {'H001'; 'H002'; 'H003'; 'H004'; 'H005'; 'H006' ; 'H007' ; 'H008' ; 'H009' ; 'H010'};
Sesh = {'cTBS'; 'iTBS'; 'SH'};
tp = {'T0';'T1'};

inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';
outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';

shift = 100;

toi1 = 0.025;
toi2 = 0.250;

% ##### SCRIPT #####

ft_defaults;


 for z = 1:size(tp,1)
 
     for y = 1:size(Sesh,1)
                 
            for x=1:size(ID,1)
                
    PP = load([inPath,[ID{x,1},'_PPTMS_' Sesh{y,1} '_final_' tp{z,1}, '_ftWaveBc']]);
    SP = load([inPath,[ID{x,1},'_SPTMS_' Sesh{y,1} '_final_' tp{z,1}, '_ftWaveBc']]);


    pair = PP.ftWaveBc;
    single = SP.ftWaveBc;

    
    prep = single.powspctrm;
    prep(:,:,1:shift) = [];
    extra = zeros(size(single.powspctrm,1),size(single.powspctrm,2),shift);
    sub = cat(3,prep,extra);
    
    %subtract shifted data from paired data
    pairNew = pair.powspctrm - sub;
    
    %create corrected structure
    PP.ftWaveBc = pair;
    PP.ftWaveBc.powspctrm = [];
    PP.ftWaveBc.powspctrm = pairNew;
    
    d1t = round(single.time,4); % rounding up decimals to 4
    tdx1 = find(d1t == toi1); % finding where it is
    tdx2 = find(d1t == toi2); % finding where it is



    % So, here, I'm getting average across freq within the time
    % (toiSPavgFreq) and replacing it inside SPavgFreq, since in the end,
    % I'm just looking from 25ms to 550ms... but it's actually the same
     
    iSPavgFreq = [];
    
    for i = 1:size(SP.ftWaveBc.powspctrm,1)
    
    
    % meaning by freq
        iSPavgFreq(i,:) = squeeze(mean(SP.ftWaveBc.powspctrm(i,:,:),2));

    end
    
    SPavgFreq = iSPavgFreq;
    
    RS_SPavgFreq = reshape(SPavgFreq,[size(SP.ftWaveBc.powspctrm,1),1,size(SPavgFreq,2)]);
   
    SP_PP_diff = (SP.ftWaveBc.powspctrm - PP.ftWaveBc.powspctrm);
    
    for ii = size(SP.ftWaveBc.powspctrm,2)
        
    LICI_divide = bsxfun(@rdivide, SP_PP_diff(:,:,:), RS_SPavgFreq);

    end
    
    LICI_cal = LICI_divide * 100;
    
    ftWaveBc = [];
    ftWaveBc = PP.ftWaveBc;
    
    ftWaveBc.powspctrm = [];
       
    % normal value
    ftWaveBc.powspctrm = LICI_cal;

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
save([outPath,['PPTMS_' Sesh{y,1} '_LICI_' tp{z,1} '_ftWaveBc_ga']],'grandAverage');
    end
end

