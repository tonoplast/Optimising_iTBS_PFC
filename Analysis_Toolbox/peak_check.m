function output = peak_check(data,time,varargin)
    

             
%define defaults
%     options = struct('minmax',[-100 300]);
    options = struct('minmax',[-100 600]);

    % read the acceptable names
    optionNames = fieldnames(options);

    % count arguments
    nArgs = length(varargin);
    if round(nArgs/2)~=nArgs/2
       error('EXAMPLE needs key/value pairs')
    end

    for pair = reshape(varargin,2,[]) % pair is {propName;propValue}
       inpName = lower(pair{1}); % make case insensitive

       if any(strmatch(inpName,optionNames))%looks for known options and replaces these in options
          options.(inpName) = pair{2};
       else
          error('%s is not a recognized parameter name',inpName)
       end
    end

    close all; clc;       
    num=1;

                 
    %define time
    sx=find(time==options.minmax(1,1));
    fx=find(time==options.minmax(1,2));

    %plot the figure

             
    t=figure('position',[0 0 1000 1000]);
    plot(time(:,sx:fx), data.data(num,sx:fx),'k');hold on; datacursormode on;
   
   
      
    %title([ID{x,1} ' ' Sesh{y,1} ' ' timePoint{z,1}]));
           

    peaksTemp = fieldnames(data);
    peakLog = strncmp('P',peaksTemp,1) | strncmp('N',peaksTemp,1);
    peak = peaksTemp(peakLog)';

    colour={'r','b'};
    n=size(peak,2);
    colour = colour(1 + mod((1:n)-1, length(colour)));
    
    

    for z=1:size(peak,2);
        if strcmp(data.(peak{1,z}).found,'yes')
            tempColour = colour{1,z};
            tempLat = data.(peak{1,z}).lat;
        elseif strcmp(data.(peak{1,z}).found,'no')
            tempColour = 'g';
            tempLat = data.(peak{1,z}).latAlt;
        end

        plot(tempLat,data.(peak{1,z}).amp,'+','MarkerEdgeColor',tempColour,'MarkerSize',20);%hold on;
        rectangle('position',[data.(peak{1,z}).minLat, data.(peak{1,z}).amp-1,data.(peak{1,z}).maxLat-data.(peak{1,z}).minLat,2], 'LineStyle','--','EdgeColor',colour{1,z});
        pos=[data.(peak{1,z}).centLat,data.(peak{1,z}).amp+0.5];
        text(data.(peak{1,z}).centLat,0,peak{1,z},'Position',pos, 'HorizontalAlignment', 'center');
        centreLine = data.(peak{1,z}).amp-1:0.01:data.(peak{1,z}).amp+1;
        centreLat = ones(1,size(centreLine,2))*data.(peak{1,z}).centLat;
        plot(centreLat,centreLine,'LineStyle','--','Color',colour{1,z});
        
      end; 
      
      
        
      
      

    R1=input('Press enter when ready to continue.');
 
    
    
    prompt=peak;
    def = [];
    for z=1:size(peak,2);
       def(1,z)=data.(peak{1,z}).lat;
    end;        
    def=strtrim(cellstr(num2str(def'))');
    answer=inputdlg(prompt, 'Latencies', [1 30],def);
    out=str2double(answer)';

    for z=1:size(peak,2);
       data.(peak{1,z}).lat = out(1,z);
       if ~isnan(data.(peak{1,z}).lat)
           ampNew = find(time==data.(peak{1,z}).lat);
           data.(peak{1,z}).amp = data.data(1,ampNew);
           data.(peak{1,z}).found = 'yes';
       elseif isnan(data.(peak{1,z}).lat)
           ampNew = find(time==data.(peak{1,z}).latAlt);
           data.(peak{1,z}).amp = data.data(1,ampNew);
           data.(peak{1,z}).found = 'no';
       end
          
    
    

    output = data;
    
    
    
     
      
        
end


