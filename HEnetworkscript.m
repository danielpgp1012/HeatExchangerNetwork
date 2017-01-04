%%This script is meant to run the MUMNE algorithm
%Initialization of Variables: Take input from user
%prompt = 'Please enter the desired streams in the following way: [Stream Numbers;mCp; Inlet T;Outlet T]\newline\n';
%asign input to Info
%Info = input(prompt);
ye=[1 0.5 330 160;2 3 220 50;3 1.5 220 105;4 2.5 205 320;5 1 95 150;6 2 40 205];
Info=ye; %While debugging ye is used as an input
%prompt2='please enter the desired minimum temperature difference\n';
%deltaTmin=input(prompt2);
deltaTmin=10;
%%Identify and Separate hot and cold streams and Temperature Intervals
[H,C,sizeH,sizeC,Tintervals]=hotcoldstreams(Info,deltaTmin);
%%Cascade Diagram.. Need to find graphical representation
[heatbox, HeatUtility, ColdUtility, Pinch]=Cascade(Tintervals, H, C, sizeH, sizeC,deltaTmin);
%% Min No. Exchangers above and below pinch
%Find Cumulative Heat boxes above and below the pinch for specific streams
%Nomenclature: HotCumHa=Cumulative Enthalpy of specific hot streams above
%pinch. ColdCumHa=Cumulative Enthalpy of specific cold streams above pinch.
%HotCumHb=Cumulative Enthalpy of specific hot streams below pinch.
%ColdCumHb=Cumulative Enthalpy of specific cold streams below the pinch. 
%These are necessary to find the minimum number of heat exchangers. 
%Habove=Hot Streams in table format similar to input variable but only for
%temperatures above the pinch. Cabove=Same as Habove but for cold streams.
%So far only single pinch is assumed. 
%PREALLOCATE VARIABLES
HotCumHa=[zeros(sizeH,1);HeatUtility]; ColdCumHa=zeros(sizeC,1);
HotCumHb=zeros(sizeH,1); ColdCumHb=[zeros(sizeC,1);ColdUtility];
Habove=zeros(sizeH,5); Hbelow=Habove;
Cabove=zeros(sizeC,5); Cbelow=Cabove;
a=1;b=1; %counters: a=above b=below
%Hot streams' enthalpy above and below is found by checking if the 
%temperatures cross or not the pinch temperature. If the temperature 
%crosses the pinch, then the heat of the stream must be split accordingly. 
for i=1:sizeH
    if H(i,3)>Pinch
        if H(i,4)>Pinch
            HotCumHa(i)=(H(i,3)-H(i,4))*H(i,2);
            Habove(a,:)=[H(i,:),HotCumHa(i)]; %if completely above the pinch
        else
            HotCumHa(i)=(H(i,3)-Pinch)*H(i,2);
            HotCumHb(i)=(Pinch-H(i,4))*H(i,2);
            Habove(a,:)=[H(i,1:2),H(i,3),Pinch,HotCumHa(i)];
            Hbelow(b,:)=[H(i,1:2),Pinch,H(i,4),HotCumHb(i)];
        end
    else
        HotCumHb(i)=(H(i,3)-H(i,4))*H(i,2);
        Hbelow(b,:)=[H(i,:),HotCumHb(i)];
    end
    if Habove(a,5)<0.1 %make row=0
       Habove(a,:)=zeros(1,5);
    end
    if Hbelow(b,5)<0.1 %make row =0 if no heat can be transferred
       Hbelow(b,:)=zeros(1,5);
    end
    a=a+1;
    b=b+1;
end
%Similar for loop for the cold streams. 
a=1;b=1;
for i=1:sizeC
    if C(i,4)>Pinch-deltaTmin
        if C(i,3)>Pinch-deltaTmin
            ColdCumHa(i)=(C(i,4)-C(i,3))*C(i,2);
            Cabove(a,:)=[C(i,:),ColdCumHa(i)]; %if completely above the pinch
        else %if crosses pinch
            ColdCumHa(i)=(C(i,4)-Pinch+deltaTmin)*C(i,2);
            ColdCumHb(i)=(Pinch-deltaTmin-C(i,3))*C(i,2);
            Cabove(a,:)=[C(i,1:2),Pinch-deltaTmin,C(i,4),ColdCumHa(i)];
            Cbelow(b,:)=[C(i,1:2),C(i,3),Pinch-deltaTmin,ColdCumHb(i)];
        end
        
    else %if completely below pinch
        ColdCumHb(i)=(C(i,4)-C(i,3))*C(i,2);
        Cbelow(b,:)=[C(i,:),ColdCumHb(i)];
    end
    if Cabove(a,5)<0.1 %make row=0
       Cabove(a,:)=zeros(1,5);
    end
    if Cbelow(b,5)<0.1 %make row =0 if no heat can be transferred
       Cbelow(b,:)=zeros(1,5);
    end
    a=a+1;
    b=b+1;
end
%%Find NMin above and below Pinch
%Heat exchangers are minimized by first finding good matches: that is,
%where the difference between the heat available vs the heat needed is 0
%we make a first nested for loop to compare if heat rates match. 
%If not, then a generalized equation can be used to find the min. number of
%exchangers. This is necessary because it will be the objective function
%for the stream matching step later on. HotCumHarefined is essentially the
%same thing as HotCumHa, yet the streams that match perfectly are taken out
%for the generalized equation to work. 
HotCumHarefined=HotCumHa; ColdCumHarefined=ColdCumHa; NEA=0;
HotCumHbrefined=HotCumHb; ColdCumHbrefined=ColdCumHb; NEB=0;
for i=1:sizeC
    for j=1:sizeH
        if ColdCumHa(i)==0
        elseif HotCumHa(j)==0
        elseif abs(HotCumHa(j)-ColdCumHa(i))<1e-3
            HotCumHarefined(j-NEA)=[]; ColdCumHarefined(i-NEA)=[]; %taken out of consideration
            NEA=NEA+1;
        end
        if ColdCumHb(i)==0
        elseif HotCumHa(j)==0
        elseif abs(HotCumHb(j)-ColdCumHb(i))<1e-3
            HotCumHbrefined(j-NEB)=[]; ColdCumHbrefined(i-NEB)=[]; %taken out of consideration
            NEB=NEB+1;
        end
    end
end
NEA=NEA+length(HotCumHarefined(HotCumHarefined>0))+length(ColdCumHarefined(ColdCumHarefined>0))-1; %this formula seems to work. Need to take away 0 values though lol
NEB=NEB+length(HotCumHbrefined(HotCumHbrefined>0))+length(ColdCumHbrefined(ColdCumHbrefined>0))-1;
%%Stream Matching
%Above the pinch, hot stream cooling takes priority over cold stream
%heating. 
%% Sort according to heat capacities
Habove=newquicksortdescending(Habove,1,sizeH,2);
Cabove=newquicksortdescending(Cabove,1,sizeC,2);
Hbelow=newquicksortdescending(Hbelow,1,sizeH,2);
Cbelow=newquicksortdescending(Cbelow,1,sizeC,2);
%First try without splitting. Big loop cycles through hot streams



            



