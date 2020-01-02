clear; close all;

%SETTINGS
eeglab;

ID = '101'; % Need to do this individually
% ID = {'101';'102';'103';'104';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'};

Sesh = '50'; % Need to do this individually
% Sesh = {'50';'75';'100'};

inPath = 'F:\Data\EEG\1_Intensity\'; %where the data is
outPath = 'F:\Data\EEG\1_Intensity\SP_analysis\'; %where you want to save the data


cond = {'Pre'; 'Post' ; '30min'};
tp = {'T0';'T1';'T2'}; %trigger points

%path to MATLAB filter folder so it won't use fieldtrip one
filterfolder ='C:\Program Files\MATLAB\R2015b\toolbox\signal\signal\';

region = 'FCZ'; % for plot check

%% loading file from Clean_1 script

EEG = pop_loadset('filename', [ID '_TMSEEG_' Sesh '_ds.set'], 'filepath', [outPath filesep ID filesep]);

%% OPTIONAL IF LOOKS BAD

EEG.allchan=EEG.chanlocs; % copy of all the channels you have (saved as EEG.allchan)

%Check for bad channel
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 0);
R1=input('Highlight any bad trials, take note of any bad channels and press "update marks". Press enter when ready to continue.');

%Remove bad trials
EEG.badtrial1=find(EEG.reject.rejmanual==1); % saved as EEG.badtrial1
EEG=pop_rejepoch(EEG,find(EEG.reject.rejmanual==1),0);

%Remove bad channels
bad=inputdlg('Enter bad channels separated by a space (i.e. FZ CZ P3 etc)', 'Bad channel removal', [1 50]); % enter bad channels to remove
str=bad{1};
EEG.badchan=strsplit(str);
if isempty(EEG.badchan)==0;
    EEG = pop_select( EEG,'nochannel',EEG.badchan);
end

    EEG = pop_tesa_fastica(EEG,'approach', 'symm', 'g', 'tanh', 'stabilization', 'on' ); 
    EEG = eeg_checkset( EEG );  
    
   
    %% save

EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_ds_ica1.set'], 'filepath', [outPath ID filesep]);

    pop_plotdata(EEG, 0, [1:size(EEG.icawinv,2)],[1:EEG.trials],'Merged datasets ERP', 0, 1, [0 0]);
    EEG = pop_selectcomps(EEG,1:size(EEG.icawinv,2));
	EEG = pop_subcomp(EEG);  
    
%%    
loc=pwd;
cd(filterfolder)

EEG = tesa_filtbutter( EEG, 1, 100, 4, 'bandpass' );
EEG = tesa_filtbutter( EEG, 48, 52, 4, 'bandstop' );

cd(loc);

%%
%CLEAN 2

%Check for bad trials
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 0);
R1=input('Highlight any bad trials and press "update marks". Press enter when ready to continue.');

%Remove bad trials
EEG.badtrial2=find(EEG.reject.rejmanual==1);
EEG=pop_rejepoch(EEG,find(EEG.reject.rejmanual==1),0);

bad=inputdlg('Enter bad channels separated by a space (i.e. FZ CZ P3 etc)', 'Bad channel removal', [1 50]); % enter bad channels to remove
str=bad{1};
EEG.badchan=strsplit(str);
if isempty(EEG.badchan)==0;
    EEG = pop_select( EEG,'nochannel',EEG.badchan);
end

%%
%ICA 2
    EEG = pop_tesa_fastica(EEG,'approach', 'symm', 'g', 'tanh', 'stabilization', 'on' ); 
    EEG = eeg_checkset( EEG );  
        

%%

%Save point
EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_ds_ica1_filt_ica2.set'], 'filepath', [outPath ID filesep]);
    
% % TESA
figure; topoplot([],EEG.chanlocs, 'style', 'blank',  'electrodes', 'labelpoint', 'chaninfo', EEG.chaninfo);
belecs=inputdlg('Enter blink channels (two) separated by a space (i.e. AF3 AF4)', 'Blinks!!', [1 50]); % enter blink elecs to use
str=belecs{1};
belecs=strsplit(str);

melecs=inputdlg('Enter horizontal eye channels (two) separated by a space (i.e. F7, F8)', 'Lateral eye!!', [1 50]); % enter blink elecs to use
str2=melecs{1};
melecs=strsplit(str2);

close all;


EEG = tesa_compselect(EEG, 'blinkElecs', belecs , 'moveElecs', melecs, 'figSize', 'large','plotTimeX',[-200,700] ,'plotFreqX', [2,80]);

%%

%Save point
EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_ds_ica1_filt_ica2_clean.set'], 'filepath', [outPath ID filesep]);


%%
%INTERPOLATE MISSING CHANNELS
EEG = pop_interp(EEG, EEG.allchan, 'spherical');

% %AVERAGE RE-REFERENCE  
EEG = pop_reref( EEG, []);
EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_ds_ica1_filt_ica2_clean_reref.set'], 'filepath', [outPath ID filesep]);

%%
%SPLIT INTO SEPERATE FILES (different time points)
temp = EEG;

EEG = pop_selectevent( EEG, 'type',{'T0'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_final_T0.set'], 'filepath', [outPath ID filesep]);
T0 = EEG;

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'T1'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_final_T1.set'], 'filepath', [outPath ID filesep]);
T1 = EEG;

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'T2'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_final_T2.set'], 'filepath', [outPath ID filesep]);
T2 = EEG;

%%  Graph of grand averages at each time point (specified channel)
    t1 = -300;
    t2 = 600;
    tp1 = find(EEG.times == t1);
    tp2 = find(EEG.times == t2);
    
    
    % Indexing channel
    COI = {EEG.chanlocs.labels};  % channel of interest
    IND = find(cellfun(@(x) strcmp(x, region), COI)); % giving it the number so you can just change setting to get whichever value
    
    if strcmp(IND,[])
    
    noregion = menu('Oops, the channel must''ve been removed! Please choose among these',COI);    
    IND = noregion;
    
    end
    
    figure;
    plot(T0.times(:,tp1:tp2,:),mean(T0.data(IND,tp1:tp2,:),3),'k');hold on;
    plot(T1.times(:,tp1:tp2,:),mean(T1.data(IND,tp1:tp2,:),3),'b');hold on;
    plot(T2.times(:,tp1:tp2,:),mean(T2.data(IND,tp1:tp2,:),3),'r');
    legend(tp);
    saveas(gcf, [outPath ID filesep [ID '_' Sesh '_TEP_final_' region]]);
    
    
%% Checking ICAlist (removed)

    ICAlist = [EEG.icaBadComp1.tmsMuscle EEG.icaBadComp1.eye EEG.icaBadComp1.muscle EEG.icaBadComp1.electrodeNoise EEG.icaBadComp1.sensory];
    ICAlistsort = sort(ICAlist);
    msgbox(num2str(ICAlistsort), 'Removed comps');
    
