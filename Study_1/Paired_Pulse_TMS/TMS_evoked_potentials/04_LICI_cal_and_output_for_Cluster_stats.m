clear; close all; clc

% This script will calculate LICI (long-interval intracortical inhibition)

%Path
inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\ROI\ft\';

cd(inPath);
Sesh= {'cTBS'; 'iTBS'; 'SH'};

tp = {'T0';'T1'};]

% time window to norm for min max % 
toi1 = 0.025;
toi2 = 0.250;

fnamevar1 = 'SPTMS_';
fnamevar2 = 'PPTMS_'; 


    for y = 1:size(Sesh,1)
        
        for z = 1:size(tp,1)
        
        
    %Single-pulse
    SP = [fnamevar1 Sesh{y,1} '_final_' tp{z,1}]; 
    %Paired-pulse
    PP = [fnamevar2 Sesh{y,1} '_final_' tp{z,1}]; 
    

%set filename
filename1 = [SP,'_ft_ga'];
load([inPath,filename1]);
D1 = grandAverage;

filename2 = [PP,'_ft_ga'];
load([inPath,filename2]);
D2 = grandAverage;


% Diff normalization (norm with max and min amp)for D1
d1t = round(D1.time,4); % rounding up decimals to 4
tdx1 = find(d1t == toi1); % finding where it is
tdx2 = find(d1t == toi2); % finding where it is



ToiD1 = D1.individual(:,:,tdx1:tdx2);

for a = 1:size(ToiD1,1)
    for b = 1:size(ToiD1,2)
        
        minvalD1(a,b) = min(ToiD1(a,b,:));
        maxvalD1(a,b) = max(ToiD1(a,b,:));
    end
end




D1normf = maxvalD1-minvalD1;
tempD1 = D1.individual;
tempD2 = D2.individual;

% LICI calculation here
for ii = 1:size(tempD1,3)
    LICI_cal(:,:,ii) = ((tempD1(:,:,ii) - tempD2(:,:,ii))) ./ D1normf * 100;
end


% for negative peaks
LICIneg = D1;
LICIneg.individual =[];
LICIneg.individual = LICI_cal*-1;
grandAverage = LICIneg;

filename = ['PPTMS_' Sesh{y,1} '_LICIneg_' tp{z,1} '_ft_ga'];

save([inPath,filename],'grandAverage');


% for positive peaks
LICIpos = D1;
LICIpos.individual =[];
LICIpos.individual = LICI_cal;
grandAverage = LICIpos;

filename = ['PPTMS_' Sesh{y,1} '_LICIpos_' tp{z,1} '_ft_ga'];
save([inPath,filename],'grandAverage');


    end

 end
