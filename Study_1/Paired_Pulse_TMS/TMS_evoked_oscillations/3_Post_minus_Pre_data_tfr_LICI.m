clear; close all;

%% Subtraction to get difference between post and pre

inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';

cd(inPath);
Sesh= {'cTBS'; 'iTBS'; 'SH'};


fnamevar1 = 'PPTMS_';
fnamevar2 = 'PPTMS_'; 

for y = 1:size(Sesh,1)
        
    %Time 0
    time0 = [fnamevar1 Sesh{y,1} '_LICI_T0']; % Pre

    %Time 1
    time1 = [fnamevar2 Sesh{y,1} '_LICI_T1']; % Post
    


%set filename
filename1 = [time0,'_ftWaveBC_ga'];
load([inPath,filename1]);
D1 = grandAverage;

filename2 = [time1,'_ftWaveBC_ga'];
load([inPath,filename2]);
D2 = grandAverage;


            Norm = D1;
            Norm.powspctrm =[];
            Norm.powspctrm = D2.powspctrm-D1.powspctrm ;
            grandAverage = Norm;

            
            filename = ['PPTMS_' Sesh{y,1} '_LICIdiff_' t1 '_ftWaveBc_ga'];
            save([inPath,filename],'grandAverage');
            
     
end
