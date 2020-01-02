clear; close all;

% This is the first step for cleaning TMS-EEG data.
% It removes large magnetic artefact from TMS and epochs the data, undergoes baseline correction,
% re-labels the data and merges three different time points, and downsamples the data.

%SETTINGS
eeglab;

ID = {'101';'102';'103';'104';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'};

Sesh = {'50';'75';'100'};

inPath = 'F:\Data\EEG\1_Intensity\'; %where the data is
outPath = 'F:\Data\EEG\1_Intensity\SP_analysis\'; %where you want to save the data

cond = {'Pre'; 'Post' ; '30min'}; %time-point
tp = {'T0';'T1';'T2'}; %time-point

caploc='F:\Data\EEG\standard-10-5-cap385.elp'; %path containing electrode positions
elec = 'FZ'; % to be used for detecting magnetic artefact
%% 


for aaa = 1:size(ID,1)
    
    cd([inPath filesep ID{aaa,1}]); % creating a directory of inPath, filesep is either / or \

    for aa = 1:size(Sesh,1)
    
        info = dir(['*',Sesh{aa,1}]); %finding in directory anything that is Session


        for a = 1:size(cond,1) % creating a loop, so that a = 1 to what's designated, which is the condition. 1 in "cond,1" is dimension
    
    % Loading data
    EEG = pop_loadcnt([inPath,ID{aaa,1},filesep,info.name,filesep,ID{aaa,1},'_',Sesh{aa,1},'_',cond{a,1},'_SP.cnt'], 'dataformat', 'auto', 'memmapfile', '');

    EEG.event =[];
    EEG = eeg_checkset( EEG );
    
    %Channel locations

    EEG = pop_chanedit(EEG, 'lookup', caploc); %caploc - channel information

    %Remove unused channels
    EEG.NoCh = {'M1'; 'M2'; 'CPZ'; 'E1'; 'E3'; 'HEOG'; 'FP1'; 'FPZ'; 'FP2'; 'FT7'; 'FT8'; 'TP7'; 'CP5'; 'CP3'; 'CP1'; 'CP2'; 'CP4'; 'CP6'; 'TP8'; 'PO5'; 'PO6'; 'PO7'; 'PO8'; 'CB1'; 'CB2'}; 

    EEG = pop_select(EEG,'nochannel',EEG.NoCh); 
    EEG.allchan=EEG.chanlocs; % copy of all the channels you have (saved as EEG.allchan)

   % using TESA toolbox for finding peaks
    EEG = tesa_findpulsepeak( EEG, elec, 'dtrnd', 'poly', 'thrshtype','dynamic', 'wpeaks', 'pos', 'plots', 'on', 'tmsLabel', '1');

    % removes magnetic artefact and interpoates
    [EEG,nanspan] = tesa_artwidth(EEG,-2,10);
    [EEG,nanspan] = tesa_artcheck(EEG,nanspan,50);
    [~,section]= tesa_artwindow(EEG,nanspan);

    [EEG]= tesa_removeandinterpolate(EEG,nanspan,section,1,2,0, elec ,1);
    [~,nanspan] = tesa_artwidth(EEG,-2,10);
    [~,mask]= tesa_artwindow(EEG,nanspan);

%% interp then  spike filt (experimental)
    blanks = []; blanks = NaN(size(mask));
    t=[]; t=1:EEG.pnts;
    x=[]; rawdata=[]; data=[]; cleandata=[];
    
    [ch,pnts,eps]=size(EEG.data);
    SPK=EEG;

    for c=1:ch
        for e=1:eps
    x=[]; rawdata=[]; data=[]; cleandata=[];           

    rawdata = SPK.data(c,:,e);
    data=rawdata;
    data(mask) = blanks;
    x=data;
    nans = isnan(x);
    x(nans) = interp1(t(~nans), x(~nans), t(nans),'linear');
    rawdat=x;  

            [cleandat,I]= hampel(rawdat,200,3);
            figure; plot(EEG.times,rawdata,'k:');

    cleandat(I)=NaN;
    x=cleandat;
    nans = isnan(x);
    x(nans) = interp1(t(~nans), x(~nans), t(nans),'linear');

    cleandata=x;  
    cleandata(mask)=rawdata(mask);     

    SPK.data(c,:,e)= cleandata;
        end
    end

    EEG=[];
    EEG=SPK;

    %%
    % Epoch -1 to 1s ('1' is the identifier)
    EEG = pop_epoch( EEG, { '1' } , [-1  1], 'newname', 'CNT file epochs', 'epochinfo', 'yes');   


    % Baseline correction -500 to -50 (making sure everything fluctuates
    % around 0) What we record is DC, so it brings baseline to 0
    EEG = pop_rmbase( EEG, [-500   -50]); % Before the TMS pulse
    
    % Loop within the loop, looking at events
    for b = 1:size(EEG.event,2) % "." means Look into xxx before ".", we are looking at 2nd dimension
        EEG.event(1,b).type = tp{a,1}; %replace triggers with time markers, tp = time point, T0 T1 T2
    end
    
    [ALLEEG, EEG, CURRENTSET]=eeg_store(ALLEEG, EEG, a); %store data in ALLEEG for merge (double-click ALLEEG in workspace) ALLEEG is a stroage, use sparingly cuz it will slow down with more 
    
end


%% Merge Files
sizeTp = 1:1:size(tp,1); %create number of time points -> 3 time points
EEG = pop_mergeset(ALLEEG, sizeTp, 0); %merge time points

EEG.urevent =[]; %reconstruct urevent -> making sure that information within EEG structure is consistent (event and urevent)

for a = 1:size(EEG.event,2)
    EEG.urevent(1,a).epoch = EEG.event(1,a).epoch;
    EEG.urevent(1,a).type = EEG.event(1,a).type;
    EEG.urevent(1,a).latency = EEG.event(1,a).latency;
end

%%
% down-sampling
EEG = pop_resample(EEG, 1000); 

% saving
mkdir([outPath filesep ID{aaa,1} filesep]);
EEG = pop_saveset(EEG, 'filename', [ID{aaa,1} '_TMSEEG_' Sesh{aa,1} '_ds.set'], 'filepath', [outPath filesep ID{aaa,1} filesep]); %ds = downsample


    end
    
end

