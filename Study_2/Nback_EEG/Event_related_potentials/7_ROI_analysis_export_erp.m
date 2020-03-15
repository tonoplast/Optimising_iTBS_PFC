% setting up

clear; close all;
outPath = 'F:\Data\EEG\1_Intensity\Nback_analysis\Nback_data\ERP\stats\';
elec = {'FC1','FCZ','FC2'};

load ([outPath 'ROI_analysis_Nback_' strjoin(elec, '_') '.mat'])

ID = {'101';'102';'103';'105';'106';'109';'110';'111';'112';'113';'114';'115';'116';'117';'118'};

Sesh = {'50';'75';'100'};
tp = {'T0';'T1'};
nback = '3back'; %'2back'; '3back';
type = 'CR';

Peak = {'N80';'P140';'N220';'P350'};

%%

for a = 1:size(ID,1)
    for b = 1:size(Sesh,1)
        for c = 1:size(tp,1)
                for d = 1:size(Peak,1)

    info =  ROI.(['H_' ID{a,1}]).(['S_' Sesh{b,1}]).(type).(['N_' nback]).(tp{c,1}).(Peak{d,1});
     
       
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


% Export latency into Excel File of Sheet 1.

xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSlatSPSS,'Lat','B2');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RScolSPSS,'Lat','B1');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSrowSPSS,'Lat','A2');

xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSlat,'Sheet1','B2');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RScol,'Sheet1','B1');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSrow,'Sheet1','A2');


% Export amplitude into Excel File of Sheet 2
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSamp,'Sheet2','B2');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RScol,'Sheet2','B1');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSrow,'Sheet2','A2');


% Export Averaged amplitude into Excel File of Sheet 3
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSampAv,'Sheet3','B2');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RScol,'Sheet3','B1');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSrow,'Sheet3','A2');


% Export amplitude into Excel File of Sheet 4 for SPSS
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSampSPSS,'Sheet4','B2');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RScolSPSS,'Sheet4','B1');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSrowSPSS,'Sheet4','A2');


% Export Averaged amplitude into Excel File of Sheet 5 for SPSS
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSampAvSPSS,'Sheet5','B2');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RScolSPSS,'Sheet5','B1');
xlswrite([outPath filesep 'Intensity_' nback '_' type '_ROI_' strjoin(elec, '_') '.xlsx'],RSrowSPSS,'Sheet5','A2');

