clear; close all;


%Path
inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\ROI\ft\';

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
filename1 = [time0,'_ft_ga'];
load([inPath,filename1]);
D1 = grandAverage;

filename2 = [time1,'_ft_ga'];
load([inPath,filename2]);
D2 = grandAverage;




%%% normalization step (IF YOU HAVE BASELINE!!!!)

Norm = D1;
Norm.individual =[];
Norm.individual = D2.individual-D1.individual; % subtracting , so nomalized
grandAverageNorm = Norm;
 filename = ['SPTMS_' Sesh{y,1} '_norm_' t1 '_ft_ga'];


save([inPath,filename],'grandAverageNorm');



end



