clear; close all; clc


%Path
inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\ROI\ft\';

cd(inPath);
Sesh= {'cTBS'; 'iTBS'; 'SH'};

posneg = {'pos'; 'neg'}; % 'pos' or 'neg' for positive or negative peak

t0 = 'T0';
t1 = 'T1';

fnamevar = 'PPTMS_'; 

for x = 1:size(posneg,1)
    
    for y = 1:size(Sesh,1)
        
        
    %Time 0
    time0 = [fnamevar Sesh{y,1} '_LICI' posneg{x,1} '_T0']; % single
    
    %Time 1
    time1 = [fnamevar Sesh{y,1} '_LICI' posneg{x,1} '_T1']; % paired 
   


%set filename
filename1 = [time0,'_ft_ga'];
load([inPath,filename1]);
D1 = grandAverage;

filename2 = [time1,'_ft_ga'];
load([inPath,filename2]);
D2 = grandAverage;



%%% normalization step (subtraction here)

Norm = D1;
Norm.individual =[];
Norm.individual = D2.individual-D1.individual; % subtracting , so nomalized
grandAverage = Norm;

filename = ['PPTMS_' Sesh{y,1} '_LICIdiff_' posneg{x,1} '_' t1 '_ft_ga'];

save([inPath,filename],'grandAverage');


    end
end
