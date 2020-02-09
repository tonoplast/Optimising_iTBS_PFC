clear; close all;

inPath = 'F:\Data\EEG\1_Intensity\ROI\Freq_analysis\'
outPath = 'F:\Data\EEG\1_Intensity\ROI\Freq_analysis\'

cd(inPath);
Sesh= {'50'; '75'; '100'};

t0 = 'T0';
t1 = 'T1';
t2 = 'T2';

fnamevar = 'TMSEEG_';

for y = 1:size(Sesh,1)
        
    %Time 0
    time0 = [fnamevar Sesh{y,1} '_final_T0']; % pre iTBS

    %Time 1
    time1 = [fnamevar Sesh{y,1} '_final_T1']; % post iTBS (5 min)
   
    %Time 2
    time2 = [fnamevar Sesh{y,1} '_final_T2']; % post iTBS (30 min)

%set filename
filename1 = [time0,'_ftWaveBC_ga'];
load([inPath,filename1]);
D1 = grandAverage;

filename2 = [time1,'_ftWaveBC_ga'];
load([inPath,filename2]);
D2 = grandAverage;

filename3 = [time2,'_ftWaveBC_ga'];
load([inPath,filename3]);
D3 = grandAverage;

            % for T1 (5-min) - T0 (pre)
            Norm = D1;
            Norm.powspctrm =[];
            Norm.powspctrm = D2.powspctrm-D1.powspctrm ; %just subtraction

            grandAverage = Norm;
    
            % Saving
            filename = ['TMSEEG_' Sesh{y,1} '_norm_' t1 '_ftWaveBc_ga'];
            save([outPath,filename],'grandAverage');
         
            grandAverage =[];
            
            % for T2 (30-min) - T0 (pre)
            Norm2 = D1;
            Norm2.powspctrm =[];
            Norm2.powspctrm = D3.powspctrm-D1.powspctrm; 
     
            grandAverage = Norm2;
            
            filename = [fnamevar Sesh{y,1} '_norm_' t2 '_ftWaveBc_ga'];
            save([outPath,filename],'grandAverage');
            
end
