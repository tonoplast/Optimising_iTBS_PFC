clear; close all; 

inPath = 'F:\Data\EEG\1_Intensity\ROI\';

cd(inPath);

Sesh= {'50'; '75'; '100'}; % 3 different conditions

t0 = 'T0';
t1 = 'T1';
t2 = 'T2';

fnamevar = 'TMSEEG_';

    for y = 1:size(Sesh,1)
        
    %Time 0
    time0 = [fnamevar Sesh{y,1} '_final_T0']; 

    %Time 1
    time1 = [fnamevar Sesh{y,1} '_final_T1']; 

    try
    %Time 2
    time2 = [fnamevar Sesh{y,1} '_final_T2'];
    catch
    end

%set filename
filename1 = [time0,'_ft_ga'];
load([inPath,filename1]);
D1 = grandAverage;

filename2 = [time1,'_ft_ga'];
load([inPath,filename2]);
D2 = grandAverage;

try
filename3 = [time2,'_ft_ga'];
load([inPath,filename3]);
D3 = grandAverage;
catch
end



%%% normalization step (IF YOU HAVE BASELINE!!!!)

Norm = D1;
Norm.individual =[];
Norm.individual = D2.individual-D1.individual; % subtracting , so nomalized
grandAverage = Norm;

filename = ['TMSEEG_' Sesh{y,1} '_norm_' t1 '_ft_ga'];
save([inPath,filename],'grandAverage');


try

grandAverage = [];
Norm2 = D1;
Norm2.individual =[];
Norm2.individual = D3.individual-D1.individual; % subtracting , so nomalized

grandAverage = Norm2;
filename = [fnamevar Sesh{y,1} '_norm_' t2 '_ft_ga'];
save([inPath,filename],'grandAverage');

catch
end

end



