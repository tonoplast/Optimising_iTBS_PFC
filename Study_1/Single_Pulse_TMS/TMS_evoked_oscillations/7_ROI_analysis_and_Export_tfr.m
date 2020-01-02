    clear;

    % ##### ROI ANALYSIS TIME FREQUENCY ANALYSIS #####

    % This script runs a ROI analysis for a given condition on a given electrode and averages over
    % both a frequency band of interest and a time window of interest. The
    % output for each individual is exported to excel file.


    % ##### SETTINGS #####
    
    ID = {'H001'; 'H002'; 'H003'; 'H004'; 'H005'; 'H006' ; 'H007' ; 'H008' ; 'H009' ; 'H010'};
    
    inPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\';
    outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\Freq_analysis\stats\';
    Sesh = {'cTBS'; 'iTBS'; 'SH'};
    tp = {'T0';'T1'};
    
    
    ROI = 'F';
    elec = {'F3'}; 
    elecs = {'F3' , 'F1' , 'FC3' , 'FC1'};

        
% Frequency band of interest
FOI = {[5,7];[8,12];[13,30];[31,70]};

FOINames = {'theta';'alpha';'beta';'gamma'};

for ee = 1:size(elec,1);

   for f = 1:size(FOI,1);
    
    if FOI{f,1} == [5,7]
        FOIName = FOINames{1};
        TOI = [0.050,0.250]; 
    elseif FOI{f,1} == [8,12]
        FOIName = FOINames{2};
        TOI = [0.050,0.250]; 
    elseif FOI{f,1} == [13,30];
        FOIName = FOINames{3};
        TOI = [0.050,0.250];
    elseif FOI{f,1}  == [31,70];
        FOIName = FOINames{4};
        TOI = [0.025,0.125];
    end
    

 

    ft_defaults;


     for y = 1:size(Sesh,1);
         
          for z = 1:size(tp,1);

load([inPath filesep 'SPTMS_' Sesh{y,1} '_final_' tp{z,1} '_ftWaveBc_ga']);

%find electrode number
elecNo = find(strcmp(elec{ee,1},grandAverage.label));

for e = 1:length(elecs);
    elecNos(e) = find(strcmp(elecs{1,e},grandAverage.label));
end


%find frequencies
[ind f1] = min(abs(FOI{f,1}(1,1) - grandAverage.freq));
[ind f2] = min(abs(FOI{f,1}(1,2) - grandAverage.freq));

%find time
[ind t1] = min(abs(TOI(1,1) - grandAverage.time));
[ind t2] = min(abs(TOI(1,2) - grandAverage.time));

%calculate average
iter1 = mean(grandAverage.powspctrm(:,elecNo,:,t1:t2),4);
iter3 = mean(mean(grandAverage.powspctrm(:,elecNos,:,t1:t2),4),2); % Average of electrodes



freqOutput = mean(iter1(:,:,f1:f2),3);
freqOutput3 = mean(iter3(:,:,f1:f2),3); % Average of electrodes


         
% Creating matrix, z by y, so by time and conditions
    freqOutputM(:,z,y) = freqOutput;

    freqOutput3M(:,z,y) = freqOutput3; % Average of electrodes
    
    col_header = {[Sesh{y,1} '_' tp{z,1}]};
    col(y,z) = col_header;
    
    for x = 1:size(ID,1);
    row_header = {[ID{x,1}]};
    row(x) = row_header;
                
                end
          end
     end
     
      
     RSfreqOutputM = reshape(freqOutputM,[length(ID),z*y,1]);
     RSfreqOutput3M = reshape(freqOutput3M,[length(ID),z*y,1]);
     
     RSrow = row';
     RScol = reshape(col.',1,[]);
     
     
xlswrite([outPath filesep 'TBS_Freq_' ROI '_' FOIName '.xlsx'],RSfreqOutputM,elec{ee,1},'B2');
xlswrite([outPath filesep 'TBS_Freq_' ROI '_' FOIName '.xlsx'],RScol,elec{ee,1},'B1');
xlswrite([outPath filesep 'TBS_Freq_' ROI '_' FOIName '.xlsx'],RSrow,elec{ee,1},'A2');


xlswrite([outPath filesep 'TBS_Freq_' ROI '_' FOIName '.xlsx'],RSfreqOutput3M,strjoin(elecs, '_'),'B2');
xlswrite([outPath filesep 'TBS_Freq_' ROI '_' FOIName '.xlsx'],RScol,strjoin(elecs, '_'),'B1');
xlswrite([outPath filesep 'TBS_Freq_' ROI '_' FOIName '.xlsx'],RSrow,strjoin(elecs, '_'),'A2');


end

end
