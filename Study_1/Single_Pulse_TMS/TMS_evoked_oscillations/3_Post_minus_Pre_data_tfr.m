clear; close all;

inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';

cd(inPath);
Sesh= {'cTBS'; 'iTBS'; 'SH'};

t0 = 'T0';
t1 = 'T1';

fnamevar = 'SPTMS_';

for y = 1:size(Sesh,1)
        
    %Time 0
     time0 = [fnamevar Sesh{y,1} '_final_T0']; % single - important, do not put a _ before the extension

    %Time 1
     time1 = [fnamevar Sesh{y,1} '_final_T1']; % paired - important, do not put a _ before the extension



%set filename
filename1 = [time0,'_ftWaveBC_ga'];
load([inPath,filename1]);
D1 = grandAverage;

filename2 = [time1,'_ftWaveBC_ga'];
load([inPath,filename2]);
D2 = grandAverage;


            Norm = D1;
            Norm.powspctrm =[];
            Norm.powspctrm = D2.powspctrm-D1.powspctrm ; %just subtraction

            grandAverage = Norm;
    
            % Saving
            filename = ['SPTMS_' Sesh{y,1} '_norm_' t1 '_ftWaveBc_ga'];
            save([inPath,filename],'grandAverage');
     
end
