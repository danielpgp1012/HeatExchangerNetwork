function [H, C,sizeH,sizeC,Tsorted]=hotcoldstreams(streams,deltaTmin)
%Returns Hot, Cold and temperature intervals using an input of with the
%inlet and outlet temperatures on the 3rd and 4th columns of the input
%matrix
sizestreams=size(streams);
C=zeros(sizestreams);
H=C;
j=1;
k=1;
for i=1:sizestreams(1)
    if streams (i,4)>streams(i,3)
        C(j,:)=streams(i,:);
        j=j+1;
    else
        H(k,:)=streams(i,:);
        k=k+1;
    end 
end 
C(j:end,:)=[];
H(k:end,:)=[];
sizeH=k-1;
sizeC=j-1;
%sorting streams for intervals
%H=newquicksortcol(H,1,k-1,4); %sort hot outlet temp
%C=newquicksortcol(C,1,j-1,3); %sort cold inlet T. 
%Intervals
%Assign temperatures to a single vector containing hot temperatures and 
% cold temperatueres +deltaTmin.. get rid of repeated values
Tunsorted=[H(:,3);C(:,4)+ deltaTmin; H(:,4) ; C(:,3) + deltaTmin];
NoStreams=2*sizestreams(1); %number of streams
Tunsorted=newquicksortcoldescending(Tunsorted); %sort Interval T. 
%Get rid of repeated temperatures
u=1; %initialize new counter
Tsorted=zeros(NoStreams,1);
for i=1:NoStreams
    if u==1 
        Tsorted(u)=Tunsorted(i);
        u=u+1;
    elseif Tunsorted(i)== Tsorted(u-1)
    else 
        Tsorted(u)=Tunsorted(i);
        u=u+1;
    end
end
Tsorted(u:end,:)=[];
end

    
