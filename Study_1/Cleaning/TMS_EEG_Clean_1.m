% This is the first step for cleaning TMS-EEG data.
% It removes large magnetic artefact from TMS and epochs the data, undergoes baseline correction,
% re-labels the data and merges two different time points, and downsamples the data.


clear all; close all; clc;

%SETTINGS

%participant ID
ID= {'H001'; 'H002'; 'H003'; 'H004'; 'H005'; 'H006' ; 'H007' ; 'H008' ; 'H009' ; 'H010'};


Sesh={'iTBS';'cTBS','SH'};

tp = {'T0' ; 'T1'};


%path
caploc = 'F:\Data\EEG\standard-10-5-cap385.elp';
elec = 'FCZ';
eeglab;

%%
%==========================================================================
for a = 1:size(ID,1);
    
    for b = 1:size(Sesh,1);
        
        inPath = ['F:\Data\EEG\0_TBS\' ID{a,1} filesep Sesh{b,1} filesep 'TMSEEG' filesep];

        outPath = ['F:\Data\EEG\0_TBS\TMS_analysis\'];

        mkdir(outPath, [ID{a,1} filesep]);
    
        for c = 1:size(tp,1);

%loads data
EEG=pop_loadcnt([inPath filesep ID{a,1} '_' Sesh{b,1} '_' tp{c,1} '_SPPP.cnt'] , 'dataformat', 'auto', 'memmapfile', '');
EEG = eeg_checkset( EEG );

% uses TESA toolbox;
EEG = tesa_findpulsepeak( EEG, 'CZ', 'dtrnd', 'poly', 'thrshtype','dynamic', 'wpeaks', 'pos', 'plots', 'on', 'paired', 'yes','ISI' , [100]);

    
% Epoch -1 to 1s ('1' is the identifier)
EEG = pop_epoch( EEG, { 'TMS' 'TMSpair' } , [-1  1], 'newname', 'CNT file epochs', 'epochinfo', 'yes');
    
% Baseline correction -500 to -110 (making sure everything fluctuates
% around 0) What we record is DC, so it brings baseline to 0
EEG = pop_rmbase( EEG, [-500   -110]); % Before the TMS pulse
EEG = eeg_checkset( EEG );


 for d = 1:size(EEG.event,2) % "." means Look into xxx before ".", we are looking at 2nd dimension
        EEG.event(1,d).type = [ EEG.event(1,d).type '_' tp{c,1}]; %replace triggers with time markers, tp = time point, T0 T1 T2
 end
    
    [ALLEEG, EEG, CURRENTSET]=eeg_store(ALLEEG, EEG, c); %store data in ALLEEG for merge (double-click ALLEEG in workspace) ALLEEG is a stroage, use sparingly cuz it will slow down with more 
    
end


%% Merge Files
sizeTp = 1:size(tp,1); %create number of time points
EEG = pop_mergeset(ALLEEG, sizeTp, 0); %merge time points

EEG.urevent =[]; %reconstruct urevent -> making sure that information within EEG structure is consistent (event and urevent)

for i = 1:size(EEG.event,2);
    EEG.urevent(1,i).epoch = EEG.event(1,i).epoch;
    EEG.urevent(1,i).type = EEG.event(1,i).type;
    EEG.urevent(1,i).latency = EEG.event(1,i).latency;
end


%Channel locations
EEG = pop_chanedit(EEG, 'lookup', caploc);

%Remove unused channels
EEG.NoCh={'FP1';'FPZ';'FP2';'FT7';'FT8';'M1';'TP7';'CP5';'CP3';'CP1';'CPZ';'CP2';'CP4';'CP6';'TP8';'M2';'PO7';'PO5';'PO3';'POZ';'PO4';'PO6';'PO8';'CB1';'CB2';'E1';'E3';'HEOG'};
EEG=pop_select(EEG,'nochannel',EEG.NoCh);

%REMOVE AND INTERPOLATE ARTIFACT  -- From Nigel's Toolbox
EEG = tesa_removedata( EEG, [-5 20] );
EEG = tesa_removedata( EEG, [-105, -80] );
EEG = tesa_interpdata( EEG, 'linear' );

%Downsample to 1000 Hz
EEG = pop_resample(EEG, 1000); 


% saving;
EEG = pop_saveset( EEG, 'filename', [ID{a,1} '_' Sesh{b,1} '_ep_bc.set'],'filepath', [outPath filesep ID{a,1} ]);
    end
end
