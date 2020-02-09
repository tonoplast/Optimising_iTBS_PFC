% this function is for recoding triger markers specifically for the project
% this labels different triggers based on the task (2-back and 3-back)
% correct hold/response/probe and incorrect hold/response/probe and miss hold/response/probe (and hold hold)
% for the combination of reponses for the task to extract epochs of interest


function [EEG]= recodeNback4(EEG,presslabel,targetlabel,nontargetlabel,responsewindow,howmanyback)
% presslabel = 'keypad1';
% nontargetlabel= '1'
% targetlabel= '2'
% responsewindow = [100 1999]
chk=EEG.event(1).type;
if (~ischar(chk))
    ints= [EEG.event.type];
    for i =1:length(ints)
        EEG.event(i).type=[num2str(ints(i))]; %convert to strings
    end
end
% EXAMPLE INPUT
%    presslabel='keypad1';targetlabel='20',nontargetlabel='10',responsewindow=[100,2000];howmanyback=2;

types = {EEG.event(:).type};
latencies=[EEG.event(:).latency];
index=[1:numel(types)];

s_nontargets= find(strcmp({EEG.event(:).type},nontargetlabel));
s_targets=find( strcmp({EEG.event(:).type},targetlabel));
target= find(~strcmp(types,{presslabel}));
starts=find([find(strcmp(types(:),presslabel))]<min([min(s_nontargets),min(s_targets)]));
    for i= 1:length(starts)
    if  strcmp(types(starts(i)),presslabel)
    types{starts(i)}='start';
    EEG.event(starts(i)).type='start'; else end
    end

%check and remove multiple keypresses
press= find(strcmp(types,{presslabel}));
difference=[];
for i=1:numel(press)-1
difference(end+1)= press(i+1)-press(i);
end
rmv= find(difference==1);
press(rmv+1)=[];
s_press=press;

stimuli=target;


[~,EV]= size({EEG.event.type});

correctlatency=[]; incorrectlatency=[];correctresp=[];
for i = s_press
lat1= EEG.event(i-1).latency;
lat2= EEG.event(i).latency;
if strcmp(EEG.event(i-1).type, {targetlabel}) && (lat2 - lat1)>responsewindow(1) && (lat2 - lat1)<responsewindow(2);
correctresp(i)= 1; 
correctlatency(i)=lat2 - lat1;

else
correctresp(i)= -1; 
incorrectlatency(i)=lat2 - lat1;
 
end
end
incorrect_resp=(find(correctresp==-1))-1;
correct_resp=(find(correctresp==1))-1;
correct_lat=correctlatency(correctlatency>0);
incorrect_lat=incorrectlatency(incorrectlatency>0);
missresp=[];miss_resp=[];
for i = index(1:end-1)
if strcmp(EEG.event(i).type, {targetlabel}) && ~strcmp(EEG.event(i+1).type, {presslabel});
missresp(i)= 1; 
end
end
miss_resp=find(missresp==1);

incorrect_probe=[];incorrect_hold =[];
for i =incorrect_resp
    this =find(stimuli==i);
    p= this-howmanyback;
    if p>1  
   if howmanyback>=1 
    steps =p+1:this-1;
    for j=1:numel(steps)
    incorrect_hold(end+1)=stimuli(steps(j));
    end
    end
    incorrect_probe(end+1)=stimuli(p);
    else end
end
correct_probe=[];correct_hold =[];
for i =correct_resp
    this =find(stimuli==i);
    p= this-howmanyback;
    if p>1
    if howmanyback>=1
    steps =p+1:this-1;
    for j=1:numel(steps)
    correct_hold(end+1)=stimuli(steps(j));
    end
    end
    correct_probe(end+1)=stimuli(p);
        else end
end
miss_probe=[];miss_hold =[];
for i =miss_resp
    this =find(stimuli==i);
    p= this-howmanyback;
    if p>1  
    if howmanyback>=1
    steps =p+1:this-1;
    for j=1:numel(steps)
    miss_hold(end+1)=stimuli(steps(j));
    end
    end
    miss_probe(end+1)=stimuli(p);
     else end
end

holds = unique([correct_hold,incorrect_hold, miss_hold]);
hold_hold= setdiff(s_nontargets,holds);


newevent= EEG.event(1);
for i=hold_hold
newevent.type='hold_hold';
newevent.latency=EEG.event(i).latency;
newevent.urevent =[EEG.event(i).urevent];
EEG.event(end+1)=newevent;
end


for i=correct_hold
newevent.type='correct_hold';
newevent.latency=EEG.event(i).latency;
newevent.urevent =[EEG.event(i).urevent];
EEG.event(end+1)=newevent;
end


for i=incorrect_hold
newevent.type='incorrect_hold';
newevent.latency=EEG.event(i).latency;
newevent.urevent =[EEG.event(i).urevent];
EEG.event(end+1)=newevent;
end

for i=miss_hold
newevent.type='miss_hold';
newevent.latency=EEG.event(i).latency;
newevent.urevent =[EEG.event(i).urevent];
EEG.event(end+1)=newevent;
end

for i=correct_resp
newevent.type='correct_resp';
newevent.latency=EEG.event(i).latency;
newevent.urevent =[EEG.event(i).urevent];
EEG.event(end+1)=newevent;
end

for i=incorrect_resp
newevent.type='incorrect_resp';
newevent.latency=EEG.event(i).latency;
newevent.urevent =[EEG.event(i).urevent];
EEG.event(end+1)=newevent;
end
for i=miss_resp
newevent.type='miss_resp';
newevent.latency=EEG.event(i).latency;
newevent.urevent =[EEG.event(i).urevent];
EEG.event(end+1)=newevent;
end


for i=correct_probe
newevent.type='correct_probe';
newevent.latency=EEG.event(i).latency;
newevent.urevent =[EEG.event(i).urevent];
EEG.event(end+1)=newevent;
end

for i=incorrect_probe
newevent.type='incorrect_probe';
newevent.latency=EEG.event(i).latency;
newevent.urevent =[EEG.event(i).urevent];
EEG.event(end+1)=newevent;
end


for i=miss_probe
newevent.type='miss_probe';
newevent.latency=EEG.event(i).latency;
newevent.urevent =[EEG.event(i).urevent];
EEG.event(end+1)=newevent;
end

LAT=mean(correct_lat);
ERROR_LAT=mean(incorrect_lat);
HITS=numel(correct_resp);
FALARM=numel(incorrect_resp);
MISS=numel(miss_resp);
TOTAL=HITS+MISS;
NEG=numel(s_nontargets)-numel(incorrect_resp);
pHit= HITS/numel(s_targets);
pFA= FALARM/numel(s_nontargets);

if pHit==1;pHit=1-1/(2*(TOTAL)); 
elseif pHit==0 ; pHit=1/(2*(TOTAL));else end

if pFA==1; pFA=1-1/(2*(TOTAL)); 
elseif pFA==0; pFA=1/(2*(TOTAL)); else end


[d,beta] = dprime(pHit,pFA);

EEG.nback.latency=LAT;
EEG.nback.H_Rate=pHit;
EEG.nback.FA_Rate=pFA;
EEG.nback.Dprime=d;
EEG.nback.beta=beta;
EEG.nback.total=TOTAL;
EEG.nback.HITS=HITS;
EEG.nback.MISSES=MISS;
EEG.nback.FALARM=FALARM;
EEG.nback.ERROR_LAT=ERROR_LAT;

