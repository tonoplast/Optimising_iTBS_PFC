% THIS SCRIPT IS FOR CLEANING -- USING ICA
% Also it will apply ICA weights of 1 Hz filtered data to 0.1 Hz filtered data

close all; clear;

eeglab;



ID = '101'; %just change participants as you go along
% ID = {'101';'102';'103';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'} ; 

Sesh = '50'; %session
% Sesh = {'50';'75';'100'}; %session

Nback = {'2back' ; '3back'};

tp = {'Pre';'Post'};

inPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\EXP1_ica_Nback_data\'; %where the data is
outPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\EXP1_ica_Nback_data\'; 

%%

EEG = pop_loadset('filename', [ID,'_',Sesh,'_1Hz_nback_merged.set'] ,'filepath',[inPath filesep ID filesep]);
EEG = eeg_checkset( EEG );

%%

EEG.allchan=EEG.chanlocs;

pop_eegplot( EEG, 1, 1, 0);


R1=input('Highlight any bad trials, take note of any bad channels and press "update marks". Press enter when ready to continue.');
%Remove bad trials
EEG.badtrial1=find(EEG.reject.rejmanual==1); % saved as EEG.badtrial1

TMP.EEG.reject.rejmanual = EEG.reject.rejmanual;
TMP.EEG.reject.rejmanualE = EEG.reject.rejmanualE;

EEG=pop_rejepoch(EEG,find(EEG.reject.rejmanual==1),0);

%Remove bad channels
bad=inputdlg('Enter bad channels separated by a space (i.e. FZ CZ P3 etc)', 'Bad channel removal', [1 50]); % enter bad channels to remove
str=bad{1};
EEG.badchan1=strsplit(str);
if isempty(EEG.badchan1)==0
    EEG = pop_select( EEG,'nochannel',EEG.badchan1);
end
 
%%  Bad chan Bad Trial into TMP

TMP.EEG.badchan1 = EEG.badchan1;
TMP.EEG.badtrial1 = EEG.badtrial1;

%%

EEG = pop_tesa_fastica(EEG,'approach', 'symm', 'g', 'tanh', 'stabilization', 'on' ); 
EEG = eeg_checkset( EEG );
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);


EEG = pop_saveset(EEG, 'filename', [ID,'_',Sesh,'_nback_merged_ica.set'] ,'filepath',[inPath filesep ID filesep]);

%%

belecs = {'AF3', 'AF4'};
melecs = {'F7', 'F8'};

% figure; topoplot([],EEG.chanlocs, 'style', 'blank',  'electrodes', 'labelpoint', 'chaninfo', EEG.chaninfo);
% belecs=inputdlg('Enter blink channels (two) separated by a space (i.e. AF3 AF4)', 'Blinks!!', [1 50]); % enter blink elecs to use
% str=belecs{1};
% belecs=strsplit(str);
% 
% melecs=inputdlg('Enter horizontal eye channels (two) separated by a space (i.e. F7, F8)', 'Lateral eye!!', [1 50]); % enter blink elecs to use
% str2=melecs{1};
% melecs=strsplit(str2);
% 
% close all;


EEG = tesa_compselect(EEG, 'blinkElecs', belecs , 'moveElecs', melecs, 'figSize', 'large','plotTimeX',[-1990,1989] ,'plotFreqX', [2,80]);


%% Saving ICA info into TMP. structure

TMP.icawinv = EEG.icawinv; 
TMP.icasphere = EEG.icasphere;
TMP.icaweights = EEG.icaweights;
TMP.icachansind = EEG.icachansind;
TMP.icaBadComp1 = EEG.icaBadComp1;

EEG = pop_saveset(EEG, 'filename', [ID,'_',Sesh,'_nback_merged_ica_clean.set'] ,'filepath',[inPath filesep ID filesep]);

%% Put TMPs into 0.1Hz

EEG01 = pop_loadset('filename', [ID,'_',Sesh,'_01Hz_nback_merged.set'] ,'filepath',[inPath filesep ID filesep]);

EEG01.icawinv = TMP.icawinv;
EEG01.icasphere = TMP.icasphere;
EEG01.icaweights = TMP.icaweights;
EEG01.icachansind = TMP.icachansind;       
EEG01.icaBadComp1 = TMP.icaBadComp1;

EEG01.badchan1 = TMP.EEG.badchan1;
EEG01.badtrial1 = TMP.EEG.badtrial1;



%% getting rid of EEG and replacing with EEG01
clear EEG; 
EEG = EEG01;

% Applying bad chan / bad trial
EEG.reject.rejmanual = TMP.EEG.reject.rejmanual;
EEG.reject.rejmanualE = TMP.EEG.reject.rejmanualE;
EEG=pop_rejepoch(EEG,EEG.reject.rejmanual,0);

EEG = pop_select( EEG,'nochannel',EEG.badchan1);

clear EEG.reject.rejmanual
clear EEG.reject.rejmanualE


EEG = pop_saveset(EEG, 'filename', [ID,'_',Sesh,'_reapplied_nback_merged_ica_clean.set'] ,'filepath',[inPath filesep ID filesep]);

eeglab redraw;

pop_eegplot( EEG, 1, 1, 0);
R1=input('Highlight any bad trials, take note of any bad channels and press "update marks". Press enter when ready to continue.');

%Remove bad trials
EEG.badtrial2=find(EEG.reject.rejmanual==1); % saved as EEG.badtrial1
EEG=pop_rejepoch(EEG,find(EEG.reject.rejmanual==1),0);

%Remove bad channels
bad=inputdlg('Enter bad channels separated by a space (i.e. FZ CZ P3 etc)', 'Bad channel removal', [1 50]); % enter bad channels to remove
str=bad{1};
EEG.badchan2=strsplit(str);
if isempty(EEG.badchan2)==0
    EEG = pop_select( EEG,'nochannel',EEG.badchan2);
end

EEG = pop_saveset(EEG, 'filename', [ID,'_',Sesh,'_reapplied_nback_merged_ica_clean2.set'] ,'filepath',[inPath filesep ID filesep]);


%%        
        
EEG = pop_interp(EEG, EEG.allchan, 'spherical');

% %AVERAGE RE-REFERENCE - Run eeglab and use EEG.history to figure it out.
EEG = pop_reref( EEG, []);

EEG = pop_saveset(EEG, 'filename', [ID,'_',Sesh,'_nback_merged_ica_clean_reref.set'], 'filepath', [inPath filesep ID filesep]);


