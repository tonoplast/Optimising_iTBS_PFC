%This function sorts the components from FastICA based on the percentage variance
%explained by each component, plots the time course, fft and topoplot of
%each component in this order and then accepts bad components as inputs and
%removes them from the signal

%output             = peak_detection_positive(data,time,srate,peaks,peak_window,varargin);

%data               = 1xn matrix containing a GMFA time series such as the optained from
                      %the GMFA_analysis.m function or the ROI_analysis.m
%time               = 1xn matrix containing the time values for the GMFA in ms
%srate              = the sampling rate of the data
%peaks              = the central peaks of interest i.e. [45 60 100 165]
%peak_window        = window size (+/- in ms) in which the peaks will be
                      %considered. This matrix needs to correspond with
                      %that in peaks i.e. [10 20 25 20] will give a window
                      %of 20 ms around 45 ms peak, 40 ms around 60 ms peak,
                      %50 ms around 100 ms peak and 40 ms around 165 ms
                      %peak

%optional input pairs:
%'peak_name', {x y ...}         = specifies names for each peak. Note that each name needs to begin with a letter 
%                               Default - peaks

%'peak_replace', [x y ....]     = values that will replace peak lateny if no peak is found in the analysis window 
%                               Default - peaks

%v1: Nigel Rogasch 11-9-14

function output = peak_detection_positive(data,time,srate,peaks,peak_window,peak_replace)
    
    %converts peaks to string
    peak_names = strread(num2str(peaks),'%s')';
        
    %Calculate windows to look for peaks (plus/minus in ms)
    for a=1:size(peaks,2);
        peak_name = ['P' peak_names{1,a}];
        bound.(peak_name).s=peaks(1,a)-peak_window(1,a); bound.(peak_name).f=peaks(1,a)+peak_window(1,a);
    end;

    for z=1:size(peaks,2);
        fs = srate;

        num = 1;
        
        peak_name = ['P' peak_names{1,z}];
         
        %Calculate the window of interest
        tWin = bound.(peak_name).s:fs/1000:bound.(peak_name).f;
        tS = find(time==bound.(peak_name).s);
        tF = find(time==bound.(peak_name).f);
   
        timezero = find(time==0);

        %Calculate the window in real terms
        timeWin = tS:fs/1000:tF;
        latHold = [];

        %Find peaks (defined as point where at least three samples either
        %side are declining in amplitude)
        for a = 1:size(tWin,2)
            for b = 1:3
                tPlus(b,1) = data.data(1,timeWin(1,a)) - data.data(1,timeWin(1,a)+b);
                tMinus(b,1) = data.data(1,timeWin(1,a)) - data.data(1,timeWin(1,a)-b);
            end

            tPlusLog = tPlus > 0;
            tMinusLog = tMinus > 0;

            if sum(tPlusLog) + sum(tMinusLog) == 6;
                latHold(num,1) = tWin(1,a);
                num = num+1;
            end
        end
        
        %Determines whether peak was found or not and calculates which peak
        %was closest to the nominated central point if multiple were found.
        %If no peak was found, the latency nominated in peak_replace is
        %used instead.
        if size(latHold,1) == 1;
            data.(peak_name).lat = latHold;
            data.(peak_name).latAlt = peak_replace(1,z);
            data.(peak_name).found = 'yes';
        elseif isempty(latHold);
            data.(peak_name).lat = NaN;
            data.(peak_name).latAlt = peak_replace(1,z);
            data.(peak_name).found = 'no';
%         elseif size(latHold,1) > 1;
%             diff = abs(peaks(1,z)-latHold);
%             sortMat =[diff latHold];
%             sorted = sortrows(sortMat);
%             data.(peak_name).lat = sorted(1,2);
%             data.(peak_name).latAlt = peak_replace(1,z);
%             data.(peak_name).found = 'yes';
%         end

% % % pick maximum value

        elseif size(latHold,1) > 1;
%           data.(peak_name).lat = latHold(1,:); % 1st peak
            [m i] = max(data.data(timezero+latHold)); %     
            data.(peak_name).lat = latHold(i);
            data.(peak_name).latAlt = peak_replace(1,z);
            data.(peak_name).found = 'yes';
        end

%%
        
       %Calculates amplitude at each peak latency
       if strcmp(data.(peak_name).found,'yes');
           ampNew = find(time==data.(peak_name).lat);
           data.(peak_name).amp =data.data(1,ampNew);
           data.(peak_name).ampAv = mean(data.data(1,ampNew-5:ampNew+5));
       else strcmp(data.(peak_name).found,'no');
           ampNew = find(time==data.(peak_name).latAlt);
           data.(peak_name).amp = data.data(1,ampNew);
           data.(peak_name).ampAv = mean(data.data(1,ampNew-5:ampNew+5));
       end
       
       
       %Records window and central setting
       data.(peak_name).minLat = bound.(peak_name).s;
       data.(peak_name).maxLat = bound.(peak_name).f;
       data.(peak_name).centLat = peaks(1,z);
       
    end
    
    output = data;
end
