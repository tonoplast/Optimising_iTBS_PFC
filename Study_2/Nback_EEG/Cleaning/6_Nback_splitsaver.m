# THIS FILE IS FOR SPLITTING N-BACK DATA (EPOCHED) BASED ON THE NEEDS
# (E.g. Correct response, Correct Probe, Miss response etc.. --> Refer to recodeNback4.m)

close all; clear;

eeglab;

ID = {'101';'102';'103';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'};

Sesh = {'50';'75';'100'};


inPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\EXP1_ica_Nback_data\'; 
outPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\EXP1_ica_Nback_data\'; 


for x = 1:size(ID,1)
     
    for y = 1:size(Sesh,1)

 EEG = pop_loadset('filename', [ID{x,1} '_' Sesh{y,1} '_nback_merged_ica_clean_reref.set'], 'filepath', [inPath filesep ID{x,1} filesep]);

%%
% 

%     EEG = pop_rmbase( EEG, [-350   -50]); % 
%     EEG = eeg_checkset( EEG );
    
temp = EEG;


% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'correct_probe_Pre_2back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_CP_2back_T0.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'correct_probe_Post_2back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_CP_2back_T1.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'correct_probe_Pre_3back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_CP_3back_T0.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'correct_probe_Post_3back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_CP_3back_T1.set'], 'filepath', [inPath filesep ID{x,1} filesep]);




%%% correct
EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'correct_resp_Pre_2back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_CR_2back_T0.set'], 'filepath', [inPath filesep ID{x,1} filesep]);

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'correct_resp_Post_2back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_CR_2back_T1.set'], 'filepath', [inPath filesep ID{x,1} filesep]);

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'correct_resp_Pre_3back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_CR_3back_T0.set'], 'filepath', [inPath filesep ID{x,1} filesep]);

EEG = temp;
EEG = pop_selectevent( EEG, 'type',{'correct_resp_Post_3back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_CR_3back_T1.set'], 'filepath', [inPath filesep ID{x,1} filesep]);



% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'correct_probe_Pre_2back' 'correct_hold_Pre_2back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Correct_2back_T0.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'correct_probe_Post_2back' 'correct_hold_Post_2back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Correct_2back_T1.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'correct_probe_Pre_3back' 'correct_hold_Pre_3back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Correct_3back_T0.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'correct_probe_Post_3back' 'correct_hold_Post_3back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Correct_3back_T1.set'], 'filepath', [inPath filesep ID{x,1} filesep]);




%%% misses
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'miss_probe_Pre_2back' 'miss_resp_Pre_2back' 'miss_hold_Pre_2back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Miss_2back_T0.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'miss_probe_Post_2back' 'miss_resp_Post_2back' 'miss_hold_Post_2back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Miss_2back_T1.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'miss_probe_Pre_3back' 'miss_resp_Pre_3back' 'miss_hold_Pre_3back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Miss_3back_T0.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'miss_probe_Post_3back' 'miss_resp_Post_3back' 'miss_hold_Post_3back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Miss_3back_T1.set'], 'filepath', [inPath filesep ID{x,1} filesep]);

% 

% incorrects
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'incorrect_resp_Pre_2back' 'incorrect_probe_Pre_2back' 'incorrect_hold_Pre_2back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Incorrect_2back_T0.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'incorrect_resp_Post_2back' 'incorrect_probe_Post_2back' 'incorrect_hold_Post_2back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Incorrect_2back_T1.set'], 'filepath', [inPath filesep ID{x,1} filesep]);

% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'incorrect_resp_Pre_3back' 'incorrect_probe_Pre_3back' 'incorrect_hold_Pre_3back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Incorrect_3back_T0.set'], 'filepath', [inPath filesep ID{x,1} filesep]);
% 
% EEG = temp;
% EEG = pop_selectevent( EEG, 'type',{'incorrect_resp_Post_3back' 'incorrect_probe_Post_3back' 'incorrect_hold_Post_3back'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [ID{x,1} '_' Sesh{y,1} '_Incorrect_3back_T1.set'], 'filepath', [inPath filesep ID{x,1} filesep]);




    end
end
