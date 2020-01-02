%This function calculates the global mean field amplitude for a given data
%set and then stores the output

%output = GMFA_analysis(data); 
%data = an electrode x time x trial matrix (e.g. EEG.data)

%v1: Nigel Rogasch 1-6-15

function output = GMFA_analysis(data)
    
        %CALCULATE GMFA
        if ndims(data)>2;
            output.data=std(mean(data,3)); %Calculate average over trials
        else
            output.data=std(data);
        end       
        
end
