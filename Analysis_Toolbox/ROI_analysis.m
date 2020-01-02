%This function calculates the global mean field amplitude for a given data
%set and then stores the output

%output = GMFA_analysis(data); 
%data = an electrode x time x trial matrix (e.g. EEG.data)

%v1: Nigel Rogasch 1-6-15

function output = ROI_analysis(data,chanlocs,chans)
    
        %Calculate average over trials
        if ndims(data)>2;
            avgTrials=nanmean(data,3); %Calculate average over trials
        else
            avgTrials=data;
        end
        
        %Extract electrodes to be averaged
        e1 = struct2cell(chanlocs);
        elec = squeeze(e1(1,1,:));
        
        for a = 1:size(chans,2)
            eNum (1,a) = find(strcmp(chans(1,a),elec));
        end
        
        timeSeries = avgTrials(eNum,:);
        
        %Averages over timeseries
        output.data = nanmean(timeSeries,1);
        output.chans = chans;
        
end
