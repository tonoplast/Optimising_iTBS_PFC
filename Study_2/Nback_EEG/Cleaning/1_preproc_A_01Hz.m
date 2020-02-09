%THIS SCRIPT FILTERS AND EPOCHS THE NBACK EEG FILES READY FOR ICA/PROCESSING WITH 'SCRIPT B'%
clc; close all; clear;

eeglab;
ft_defaults;

ID = ID = {'101';'102';'103';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'} ; %just change participants as you go along

Sesh = {'50' ; '75' ; '100'}; %session
Nback = {'2back' ; '3back'};

inPath = 'F:\Data\EEG\1_Intensity\'; %where the data is
outPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\EXP1_epoch_Nback_data\'; %where you want to save the data

tp = {'Pre';'Post'}; %time points

caploc='F:\Data\EEG\standard-10-5-cap385.elp'; %path containing electrode positions
%% 


for a = 1:size(ID,1);
    
    cd([inPath filesep ID{a,1}]); % creating a directory of inPath, filesep is either / or \
    
    for b = 1:size(Sesh,1);
        
        info = dir(['*',Sesh{b,1}]); %finding in directory anything that is Session
        
        for c = 1:size(tp,1); 
            
            for d = 1:size(Nback,1);
                
    
% Loading data
EEG = pop_loadcnt([inPath,ID{a,1},filesep,info.name,filesep,ID{a,1},'_',Sesh{b,1},'_',tp{c,1},'_' Nback{d,1} '.cnt'], 'dataformat', 'auto', 'keystroke', 'on','memmapfile', '');
EEG = eeg_checkset( EEG );

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG,  1);


%% Read-in Chanlocs 

EEG=pop_chanedit(EEG, 'lookup',caploc);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, 1);
EEG = eeg_checkset( EEG );
eeglab redraw;

%ADD/REMOVE EEG CHANNELS

EEG = pop_select( EEG,'channel',{'AF3';'AF4';'F7';'F5';'F3';'F1';'FZ';'F2';'F4';'F6';'F8';'FC5';'FC3';'FC1';'FCZ';'FC2';'FC4';'FC6';'T7';'C5';'C3';'C1';'CZ';'C2';'C4';'C6';'T8';'P7';'P5';'P3';'P1';'PZ';'P2';'P4';'P6';'P8';'PO3';'POZ';'PO4';'O1';'OZ';'O2'});

EEG.allchan=EEG.chanlocs;

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );

%% Re-code
if strcmp(Nback{d,1}, '2back')
    recin= '2';
    howmanyback = 2;
elseif strcmp(Nback{d,1}, '3back')
    recin= '3';
    howmanyback = 3;

end
    
[EEG]= recodeNback4(EEG,'keypad1',recin,'1',[100 1999], howmanyback); %refers to Caley's function (recodeNback.m)
%  [EEG]= recodeNback(EEG,presslabel,targetlabel,nontargetlabel,responsewindow,howmanyback)


[ALLEEG EEG] = eeg_store(ALLEEG, EEG, 1);


mkdir([outPath filesep ID{a,1}]);

EEG = pop_saveset( EEG, 'filename', [ID{a,1},'_',Sesh{b,1},'_',tp{c,1},'_' Nback{d,1} '_recoded.set'] ,'filepath',[outPath filesep ID{a,1}]);

EEG = eeg_checkset( EEG );


%% hampel spike remover

t=[]; 
t=1:EEG.pnts;
x=[];
rawdata=[];
data=[];
cleandata=[];       
[ch,pnts,eps]=size(EEG.data);
SPK=EEG;
for chan=1:ch
    for e=1:eps
 x=[];
rawdata=[];
data=[];
cleandata=[];           
        
        
rawdata = SPK.data(chan,:,e);
data=rawdata;
x=data;
nans = isnan(x);
x(nans) = interp1(t(~nans), x(~nans), t(nans),'pchip');
rawdat=x;  

[cleandat,I]= hampel(rawdat,200,3);

 cleandat(I)=NaN;
 x=cleandat;
nans = isnan(x);
x(nans) = interp1(t(~nans), x(~nans), t(nans),'pchip');
cleandata=x;  
%  plot(EEG.times,cleandata,'g');
%  drawnow;
%  hold off; 
SPK.data(chan,:,e)= cleandata;
    end
end

EEG=[];
EEG=SPK;


%% FILTER 
% Band pass (0.3 -100Hz) 
% Two way IIR zero phase Infinite Impulse Response filters (applying a causal step [oldest
% data to newest], followed by an anti-causal step [newest data to oldest] to retain phase information).

data = eeglab2fieldtrip(EEG, 'preprocessing', 'coord_transform');
cfg=[] ; 
cfg.reref         = 'no' ;
cfg.bpfilter      = 'yes'; % bandpass filter is off here. depending on freq below
cfg.padding         = 10;
cfg.dftfilter     = 'no' ;
cfg.bpfreq        = [0.1 100]; %0.3 100
% cfg.dftfreq       = [50 100 150 200];
cfg.bsfilter      =  'yes'; %'no' or
cfg.bsfreq        =[48 52]; %bandstop frequency range, specified as [low high] in Hz
cfg.bsfiltdir     =  'twopass-reverse';
cfg.bsfilttype    = 'but';
cfg.bpfiltord = 1;
cfg.bsfiltord = 1;

 %% 50Hz NOTCH FILTER 
cfg.bpfilttype    = 'but';
cfg.bpfiltdir     = 'twopass-reverse';%'twopass-reverse'; 

[data] = ft_preprocessing(cfg, data);
EEG.data=[data.trial{:}]; 

% figure; pop_spectopo(EEG, 1, [], 'EEG' , 'percent', 15, 'freq', [6 10 22], 'freqrange',[2 100],'electrodes','off');

[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
eeglab redraw;

EEG = eeg_checkset( EEG );
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, 1);



%% EPOCH 

% if strcmp(Nback{d,1}, '2back')

EEG = pop_epoch( EEG, {'correct_probe' 'correct_hold' 'hold_hold' 'correct_resp' 'incorrect_resp' 'incorrect_probe' 'incorrect_hold' 'miss_probe' 'miss_resp' 'miss_hold'}, [-1.99   1.99], 'newname', [ID{a,1},'_',Sesh{b,1},'_',tp{c,1},'_' Nback{d,1} '.cnt'], 'epochinfo', 'yes'); %this is epoching a window of 1.51 sec before to 1.99 sec after the probe stimulus

[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET); 


% Baseline correct

    EEG = pop_rmbase( EEG, [-500   -50]); % 
    EEG = eeg_checkset( EEG );

    
    % Re-labelling Triggers before merging
    
    for n = 1:size(EEG.event,2) 
        EEG.event(n).type = [EEG.event(n).type, '_' tp{c,1},'_' Nback{d,1}];
    end
    
    mkdir(outPath, ID{a,1});
    
%SAVPOINT
EEG = pop_saveset( EEG, 'filename', [ID{a,1},'_',Sesh{b,1},'_',tp{c,1},'_' Nback{d,1} '_01Hz_epoched.set'] ,'filepath',[outPath filesep ID{a,1}]);
EEG = eeg_checkset( EEG );


    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    close all;

        end
          
      end
        
    end
    
end


