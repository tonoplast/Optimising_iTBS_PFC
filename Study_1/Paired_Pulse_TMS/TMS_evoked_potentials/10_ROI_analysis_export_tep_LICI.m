
% This script exports the calculcated LICI into excel
% setting up

clear; close all; clc;

outPath = 'F:\Data\EEG\0_TBS\TMS_analysis\ROI\';

elec = {'F3', 'F1','FC3', 'FC1'};

load ([outPath 'ROI_analysis_PP_LICI_' strjoin(elec, '_') '.mat'])

ID = {'H001'; 'H002'; 'H003'; 'H004'; 'H005'; 'H006' ; 'H007' ; 'H008' ; 'H009' ; 'H010'};
Sesh = {'cTBS';'iTBS';'SH'};
tp = {'T0';'T1'};

Peak = {'N40';'P65';'N115';'P200'};

%%

for a = 1:size(ID,1)
    for b = 1:size(Sesh,1)
        for c = 1:size(tp,1)
            for d = 1:size(Peak,1)
                
    info = ROI.(ID{a,1}).(Sesh{b,1}).(tp{c,1}).(Peak{d,1});
     
    
       
      if strcmp(info.found, 'yes')
      lat(d,c,b,a) = getfield(info, 'lat'); % getting latencies
      else strcmp(info.found,'no');
      lat(d,c,b,a) = getfield(info, 'latAlt');
      end

            latSPSS(a,c,b,d) = lat(d,c,b,a);
            amp(d,c,b,a) = getfield(info, 'amp'); % getting amplitudes
            ampAv(d,c,b,a) = getfield(info, 'ampAv'); % getting Averaged amplitudes
            ampSPSS(a,c,b,d) = getfield(info, 'amp'); % getting amplitudes for SPSS
            ampAvSPSS(a,c,b,d) = getfield(info, 'ampAv'); %getting Averaged Amplitudes for SPSS

     % adding header for column and row
     
    col_header = {[ID{a,1} filesep Sesh{b,1} filesep tp{c,1}]};
    col(c,b,a) = col_header;
    row_header = {[Peak{d,1}]};
    row(d) = row_header;
    
    
    SPSS_col_header = {[Peak{d,1} '_' Sesh{b,1} '_' tp{c,1}]};
    colSPSS(c,b,d) = SPSS_col_header;
    SPSS_row_header = {[ID{a,1}]};
    rowSPSS(a) = SPSS_row_header;
    
            end

        end

    end
    
end

%%

% changing columns and rows to suit the study

RSlat = reshape(lat,[d c*b*a]);
RSamp = reshape(amp,[d c*b*a]);
RSampAv = reshape(ampAv,[d c*b*a]);
RScol = reshape(col, [1 c*b*a]);
RSrow = reshape(row, [d 1]);


        
RSlatSPSS = reshape(latSPSS, [a c*b*d]);
RSampSPSS = reshape(ampSPSS, [a c*b*d]);
RSampAvSPSS = reshape(ampAvSPSS, [a c*b*d]);
RScolSPSS = reshape(colSPSS, [1 c*b*d]);
RSrowSPSS = reshape(rowSPSS, [a 1]);


%%
% Export latency into Excel File of Sheet 1

xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSlatSPSS,'Lat','B2');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RScolSPSS,'Lat','B1');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSrowSPSS,'Lat','A2');

xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSlat,'Sheet1','B2');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RScol,'Sheet1','B1');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSrow,'Sheet1','A2');


% Export amplitude into Excel File of Sheet 2

xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSamp,'Sheet2','B2');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RScol,'Sheet2','B1');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSrow,'Sheet2','A2');


% Export Averaged amplitude into Excel File of Sheet 3

xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSampAv,'Sheet3','B2');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RScol,'Sheet3','B1');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSrow,'Sheet3','A2');




% Export amplitude into Excel File of Sheet 4 for SPSS

xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSampSPSS,'Sheet4','B2');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RScolSPSS,'Sheet4','B1');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSrowSPSS,'Sheet4','A2');


% Export Averaged amplitude into Excel File of Sheet 5 for SPSS

xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSampAvSPSS,'Sheet5','B2');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RScolSPSS,'Sheet5','B1');
xlswrite([outPath filesep 'TBS_ROI_PP_LICI_' strjoin(elec, '_') '.xlsx'],RSrowSPSS,'Sheet5','A2');



