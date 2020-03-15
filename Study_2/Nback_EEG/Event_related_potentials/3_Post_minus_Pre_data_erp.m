clear; close all; 

inPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\ERP\';

cd(inPath);

Sesh= {'50'; '75'; '100'}; % 50, 75 or 100% iTBS intensity
nback = {'2back';'3back'};  % 2 time points here -- before and after iTBS
type = {'CR'; 'CP'}; % which epoch (CR = correct response, CP = correct probe)

t0 = 'T0';
t1 = 'T1';

fnamevar = 'ERP_'; 

    for y = 1:size(Sesh,1)
        
        for t = 1:size(type,1)
            
        for n = 1:size(nback,1)
            
    %Time 0
    time0 = [fnamevar Sesh{y,1} '_' type{t,1} '_' nback{n,1} '_final_T0']; 

    %Time 1
    time1 = [fnamevar Sesh{y,1} '_' type{t,1} '_' nback{n,1} '_final_T1']; 


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
grandAverage = Norm;

filename = ['ERP_' Sesh{y,1} '_' type{t,1} '_'  nback{n,1} '_norm_' t1 '_ft_ga'];
save([inPath,filename],'grandAverage');

           end
        end
    end
