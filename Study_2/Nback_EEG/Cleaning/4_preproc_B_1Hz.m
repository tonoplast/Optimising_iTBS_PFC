% THIS SCRIPT IS FOR MERGING PURPOSES
% NOTE THAT THIS IS DONE WITH 1 Hz FILTER

close all; clear;

eeglab;
ID = ID = {'101';'102';'103';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'} ; 

Sesh = {'50';'75';'100'}; %session

Nback = {'2back' ; '3back'};

tp = {'Pre';'Post'};
inPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\EXP1_epoch_Nback_data\';
outPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\EXP1_ica_Nback_data\'; 


%%

for a = 1:size(ID,1);
        
    mkdir(outPath, ID{a,1});
    
    for b = 1:size(Sesh,1);
              
        for c = 1:size(tp,1); 
            
            for d = 1:size(Nback,1);
                
% Loading data
    EEG = pop_loadset('filename', [ID{a,1},'_',Sesh{b,1},'_',tp{c,1},'_' Nback{d,1} '_1Hz_epoched.set'] ,'filepath',[inPath filesep ID{a,1}]);
    EEG = eeg_checkset( EEG );
    
    if c==1 && d==1;
        file=1;
    end
    if c==1 && d==2;
        file=2;
    end
    if c==2 && d==1;
        file=3;
    end
    if c==2 && d==2;
        file=4;
    end
  
    
    
     [ALLEEG, EEG, CURRENTSET]=eeg_store(ALLEEG, EEG, file);
    
         end 
      end
        
        
        EEG = pop_mergeset(ALLEEG, [1 2 3 4], 0);
        EEG = pop_saveset(EEG, 'filename', [ID{a,1},'_',Sesh{b,1},'_01Hz_nback_merged.set'] ,'filepath',[outPath filesep ID{a,1}]);
        EEG = eeg_checkset( EEG ); 
        
    end
  end





