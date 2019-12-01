% This script goes through a manual cleaning process. It is done for one participant at a time.


clear all; close all; clc;

%SETTINGS

%participant ID ( just for reference)
% ID= {'H001'; 'H002'; 'H003'; 'H004'; 'H005'; 'H006' ; 'H007' ; 'H008' ; 'H009' ; 'H010'};

ID= 'H001';

Sesh='SH'; % 'cTBS'; 'iTBS'; 'SH';

tp = {'T0' ; 'T1'};

inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\';
outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\';

% Load file
EEG = pop_loadset('filename', [ID '_' Sesh '_ep_bc.set'],'filepath', [inPath filesep ID]);

EEG.allchan=EEG.chanlocs; % copy of all the channels you have (saved as EEG.allchan)

%%
% Clean 1
% Check for bad channel
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


%% Run ICA (independent component analysis)

mkdir([outPath filesep ID filesep Sesh]);
cd([outPath filesep ID filesep Sesh]);

    EEG = pop_runica(EEG,'icatype','fastica', 'approach', 'symm', 'g', 'tanh'); 
    EEG = eeg_checkset( EEG );  
    
    close all;
    
%%


%Save point
EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_ds_ica1.set'], 'filepath', [outPath filesep ID filesep Sesh]);


    
    pop_plotdata(EEG, 0, [1:size(EEG.icawinv,2)],[1:EEG.trials],'Merged datasets ERP', 0, 1, [0 0]);
    EEG = pop_selectcomps(EEG,1:size(EEG.icawinv,2));
    
    RejComp1 = EEG.reject.gcompreject;
    RejCompNo1 = find(RejComp1 == 1);

    R1=input('Press enter when ready to continue');
    EEG = pop_subcomp(EEG, [], 0);

%%


EEG = pop_eegfiltnew(EEG, 1, 100, 3300, 0, [], 0);
EEG = eeg_checkset( EEG );

% plot (optional)
[fftOut1, freq] = fftCalc(EEG, 1, 100);
figure; plot(freq,fftOut1);

    
EEG = pop_eegfiltnew(EEG, 47, 53, 1650, 1, [], 0);
EEG = eeg_checkset( EEG );    

% plot (optional)
[fftOut2, freq] = fftCalc(EEG, 1, 100);
figure; plot(freq,fftOut2);



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

    EEG = pop_runica(EEG,'icatype','fastica', 'approach', 'symm', 'g', 'tanh'); 
    EEG = eeg_checkset( EEG );  
    
    close all;
    
%%

%Save point
EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_ds_ica1_filt_ica2.set'], 'filepath', [outPath filesep ID filesep Sesh]);

    
    pop_plotdata(EEG, 0, [1:size(EEG.icawinv,2)],[1:EEG.trials],'Merged datasets ERP', 0, 1, [0 0]);
    EEG = pop_selectcomps(EEG,1:size(EEG.icawinv,2));
    
    RejComp2 = EEG.reject.gcompreject;
    RejCompNo2 = find(RejComp2 == 1);

    R1=input('Press enter when ready to continue');
    EEG = pop_subcomp(EEG, [], 0);


%%
%Save point
EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_ds_ica1_filt_ica2_clean.set'], 'filepath', [outPath filesep ID filesep Sesh]);

%%
%INTERPOLATE MISSING CHANNELS
EEG = pop_interp(EEG, EEG.allchan, 'spherical');

% %AVERAGE RE-REFERENCE - Run eeglab and use EEG.history to figure it out.
EEG = pop_reref( EEG, []);

EEG = pop_saveset(EEG, 'filename', [ID '_TMSEEG_' Sesh '_ds_ica1_filt_ica2_clean_reref.set'], 'filepath', [outPath filesep ID filesep Sesh]);


%%
%SPLIT INTO SEPERATE FILES
temp = EEG;

EEG = pop_selectevent( EEG, 'type',{'TMS_T0'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_SPTMS_' Sesh '_T0.set'], 'filepath', [outPath filesep ID filesep Sesh]);

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'TMS_T1'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_SPTMS_' Sesh '_T1.set'], 'filepath', [outPath filesep ID filesep Sesh]);

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'TMSpair_T0'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_PPTMS_' Sesh '_T0.set'], 'filepath', [outPath filesep ID filesep Sesh]);

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'TMSpair_T1'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_PPTMS_' Sesh '_T1.set'], 'filepath', [outPath filesep ID filesep Sesh]);


%% peak checking etc from here


    SPEEG0 = pop_loadset('filename',[ID '_SPTMS_' Sesh '_T0.set'], 'filepath', [outPath filesep ID filesep Sesh]);
    SPEEG1 = pop_loadset('filename',[ID '_SPTMS_' Sesh '_T1.set'], 'filepath', [outPath filesep ID filesep Sesh]);
    PPEEG0 = pop_loadset('filename',[ID '_PPTMS_' Sesh '_T0.set'], 'filepath', [outPath filesep ID filesep Sesh]);
    PPEEG1 = pop_loadset('filename',[ID '_PPTMS_' Sesh '_T1.set'], 'filepath', [outPath filesep ID filesep Sesh]);

     
    %%
 
    EEG = pop_loadset('filename', [ID '_TMSEEG_' Sesh '_ds_ica1_filt_ica2_clean_reref.set'], 'filepath', [outPath filesep ID filesep Sesh]);
 
    t1 = -300;
    t2 = 600;
    tp1 = find(EEG.times == t1);
    tp2 = find(EEG.times == t2);
    
    figure;
    plot(EEG.times(:,tp1:tp2), mean(EEG.data(:,tp1:tp2,:),3));
    saveas(gcf, [outPath filesep ID filesep Sesh filesep [ID '_' Sesh '_butterfly_final']]);
    
       %%
    
   COI = {EEG.chanlocs.labels};  % channel of interest
    
    for c = 1:length(COI);
        
    
    IND = find(cellfun(@(x) strcmp(x, COI{1,c}), COI));    
       
    
    figure;
    plot(SPEEG0.times(:,tp1:tp2), mean(SPEEG0.data(IND,tp1:tp2,:),3),'k'); hold on; %% 6 is F1
    plot(SPEEG1.times(:,tp1:tp2), mean(SPEEG1.data(IND,tp1:tp2,:),3),'b') ; hold on;
    plot(PPEEG0.times(:,tp1:tp2), mean(PPEEG0.data(IND,tp1:tp2,:),3),'r');  hold on;
    plot(PPEEG1.times(:,tp1:tp2), mean(PPEEG1.data(IND,tp1:tp2,:),3),'m');

    title([ID, '__' Sesh '__' COI{1,c}]);
    legend('SP_T0', 'SP_T1', 'PP_T0', 'PP_T1');
    
    saveas(gcf, [outPath filesep ID filesep Sesh filesep [ID '_' Sesh '_TEP_' COI{1,c}]]);

    end
       %%
    
    SPmAF30 = mean(SPEEG0.data(1,tp1:tp2,:),3);
    SPmF50 = mean(SPEEG0.data(4,tp1:tp2,:),3);
    SPmFZ0 = mean(SPEEG0.data(7,tp1:tp2,:),3);
    SPmFC30 = mean(SPEEG0.data(13,tp1:tp2,:),3);
    
    SPmROI0 = (SPmAF30 + SPmF50 + SPmFZ0 + SPmFC30)/4;
     
    SPmAF31 =  mean(SPEEG1.data(1,tp1:tp2,:),3);
    SPmF51 = mean(SPEEG1.data(4,tp1:tp2,:),3);
    SPmFZ1 = mean(SPEEG1.data(7,tp1:tp2,:),3);
    SPmFC31 = mean(SPEEG1.data(13,tp1:tp2,:),3);
    
    SPmROI1 = (SPmAF31 + SPmF51 + SPmFZ1 + SPmFC31)/4;    
    
    PPmAF30 =  mean(PPEEG0.data(1,tp1:tp2,:),3);
    PPmF50 = mean(PPEEG0.data(4,tp1:tp2,:),3);
    PPmFZ0 = mean(PPEEG0.data(7,tp1:tp2,:),3);
    PPmFC30 = mean(PPEEG0.data(13,tp1:tp2,:),3);
    
    PPmROI0 = (PPmAF30 + PPmF50 + PPmFZ0 + PPmFC30)/4;       
    
    PPmAF31 =  mean(PPEEG1.data(1,tp1:tp2,:),3);
    PPmF51 = mean(PPEEG1.data(4,tp1:tp2,:),3);
    PPmFZ1 = mean(PPEEG1.data(7,tp1:tp2,:),3);
    PPmFC31 = mean(PPEEG1.data(13,tp1:tp2,:),3);
    
    PPmROI1 = (PPmAF31 + PPmF51 + PPmFZ1 + PPmFC31)/4;     
    
    figure;
    plot(SPEEG0.times(:,tp1:tp2), SPmROI0,'k'); hold on;
    plot(SPEEG1.times(:,tp1:tp2), SPmROI1,'b'); hold on;
    plot(PPEEG0.times(:,tp1:tp2), PPmROI0,'r'); hold on;
    plot(PPEEG1.times(:,tp1:tp2), PPmROI1,'m'); 

    title([ID, '__' Sesh '__Surrounding']);
    legend('SP_T0', 'SP_T1', 'PP_T0', 'PP_T1');
    
    saveas(gcf, [outPath filesep ID filesep Sesh filesep [ID '_' Sesh '_TEP_final_surrounding']]);
    
    %% Butterfly separated by Time Points
   
    SPAllT0 = mean(SPEEG0.data(:,tp1:tp2,:),3);
    SPAllT1 = mean(SPEEG1.data(:,tp1:tp2,:),3);
    PPAllT0 = mean(PPEEG0.data(:,tp1:tp2,:),3); 
    PPAllT1 = mean(PPEEG1.data(:,tp1:tp2,:),3); 
    
    
    figure;
    plot(SPEEG0.times(:,tp1:tp2),  SPAllT0);
    title([ID, '__' Sesh '_SP_T0_ All']);
    saveas(gcf, [outPath filesep ID filesep Sesh filesep [ID '_' Sesh '_SP_T0_ All']]);
    
    figure;
    plot(SPEEG1.times(:,tp1:tp2),  SPAllT1);
    title([ID, '__' Sesh '_SP_T1_ All']);
    saveas(gcf, [outPath filesep ID filesep Sesh filesep [ID '_' Sesh '_SP_T1_ All']]);
    
    figure;
    plot(PPEEG0.times(:,tp1:tp2),  PPAllT0);
    title([ID, '__' Sesh '_PP_T0_All']);
    saveas(gcf, [outPath filesep ID filesep Sesh filesep [ID '_' Sesh '_PP_T0_ All']]);
    

    figure;
    plot(PPEEG1.times(:,tp1:tp2),  PPAllT1);
    title([ID, '__' Sesh '_PP_T1_All']);
    saveas(gcf, [outPath filesep ID filesep Sesh filesep [ID '_' Sesh '_PP_T1_ All']]);
     %% Averaged graph by Time Points
   
    SPavT0 = std(mean(SPEEG0.data(:,tp1:tp2,:),3));
    SPavT1 = std(mean(SPEEG1.data(:,tp1:tp2,:),3));
    PPavT0 = std(mean(PPEEG0.data(:,tp1:tp2,:),3));
    PPavT1 = std(mean(PPEEG1.data(:,tp1:tp2,:),3));    
    
    figure;
    plot(SPEEG0.times(:,tp1:tp2), SPavT0,'k'); hold on;
    plot(SPEEG1.times(:,tp1:tp2), SPavT1,'b'); hold on;
    plot(PPEEG0.times(:,tp1:tp2), PPavT0,'r');
    plot(PPEEG1.times(:,tp1:tp2), PPavT1,'m');
    title([ID, '__' Sesh '__GMFA']);
    legend('SP_T0', 'SP_T1', 'PP_T0', 'PP_T1');
    saveas(gcf, [outPath filesep ID filesep Sesh filesep [ID '_' Sesh '_GMFA']]);
    
    
   
    pause;
    
    %% remove bad channels

bad=inputdlg('Enter bad channels separated by a space (i.e. FZ CZ P3 etc)', 'Bad channel removal', [1 50]); % enter bad channels to remove
str=bad{1};
EEG.badchan=strsplit(str);
if isempty(EEG.badchan)==0;
    EEG = pop_select( EEG,'nochannel',EEG.badchan);
end

%INTERPOLATE MISSING CHANNELS
EEG = pop_interp(EEG, EEG.allchan, 'spherical');



%% Separating Single-pulse (TMS_T0 / TMS_T1) and paired-pulse (TMSpair_T0 / TMSpair_T1) data and saving
temp = EEG;

EEG = pop_selectevent( EEG, 'type',{'TMS_T0'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_SPTMS_' Sesh '_final_T0.set'], 'filepath', [outPath filesep ID filesep Sesh]);

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'TMS_T1'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_SPTMS_' Sesh '_final_T1.set'], 'filepath', [outPath filesep ID filesep Sesh]);

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'TMSpair_T0'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_PPTMS_' Sesh '_final_T0.set'], 'filepath', [outPath filesep ID filesep Sesh]);

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'TMSpair_T1'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID '_PPTMS_' Sesh '_final_T1.set'], 'filepath', [outPath filesep ID filesep Sesh]);


