clear; close all;
tic
%SETTINGS

elec = {'FC1','FCZ','FC2'};

ID = {'101';'102';'103';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'};
Sesh = {'50';'75';'100'};

tp = {'T0';'T1'};
nback = {'2back'; '3back'};
type = {'CR';'CP'};


inPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\EXP1_ica_Nback_data\';
outPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\ERP\stats\';

mkdir(outPath);

time = -1990:1:1990;

fs = 1000;

peaks_neg = [80 220];
peak_window_neg = [25 40];
peaks_pos = [140 350];
peak_window_pos = [30 100];

peak_replace_neg = [90 220];
peak_replace_pos = [140 350];

%%


%Calculate ROI / extract time series
clear ROI;
tic


for x = 1:size(ID,1)
     
    for y = 1:size(Sesh,1)
        
       for t = 1:size(type,1)
        
        for n = 1:size(nback,1)
            
          for z = 1:size(tp,1)
        
              %LOAD DATA 
        
        EEG = pop_loadset('filename',[ID{x,1} '_' Sesh{y,1} '_' type{t,1} '_' nback{n,1} '_' tp{z,1} '.set'], 'filepath',[inPath filesep ID{x,1} filesep]);

        %CALCULATE ROI       
           
        ROI.(['H_' ID{x,1}]).(['S_' Sesh{y,1}]).(type{t,1}).(['N_' nback{n,1}]).(tp{z,1}) = ROI_analysis(EEG.data,EEG.chanlocs,elec); %electrodes of interest
        
            end
        end
    end
end
end

toc

%%

%CALCULATE PEAKS

for x = 1:size(ID,1)
     for y = 1:size(Sesh,1)
       for t = 1:size(type,1)
         for n = 1:size(nback,1)
           for z = 1:size(tp,1)

       ROI.(['H_' ID{x,1}]).(['S_' Sesh{y,1}]).(type{t,1}).(['N_' nback{n,1}]).(tp{z,1}) = peak_detection_negative(ROI.(['H_' ID{x,1}]).(['S_' Sesh{y,1}]).(type{t,1}).(['N_' nback{n,1}]).(tp{z,1}),time,fs,peaks_neg,peak_window_neg,peak_replace_neg);
       ROI.(['H_' ID{x,1}]).(['S_' Sesh{y,1}]).(type{t,1}).(['N_' nback{n,1}]).(tp{z,1}) = peak_detection_positive(ROI.(['H_' ID{x,1}]).(['S_' Sesh{y,1}]).(type{t,1}).(['N_' nback{n,1}]).(tp{z,1}),time,fs,peaks_pos,peak_window_pos,peak_replace_pos);
    
                 end
              end
            end
        end
    end

%%

%CHECK PEAKS
% % 
for x = 1:size(ID,1)
         for y = 1:size(Sesh,1)
            for t = 1:size(type,1)
              for n = 1:size(nback,1)
                 for z = 1:size(tp,1)
         
        ROI.(['H_' ID{x,1}]).(['S_' Sesh{y,1}]).(type{t,1}).(['N_' nback{n,1}]).(tp{z,1}) = peak_check(ROI.(['H_' ID{x,1}]).(['S_' Sesh{y,1}]).(type{t,1}).(['N_' nback{n,1}]).(tp{z,1}),time);
       
              end
           end
        end
    end
end

%%
save([outPath 'ROI_analysis_Nback_' strjoin(elec, '_')], 'ROI');
