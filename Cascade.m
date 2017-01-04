function [heatbox, HeatUtility, ColdUtility, Pinch]=Cascade(Tintervals,H, C,sizeH,sizeC,deltaTmin)
%%this function returns the cascade diagram containing the heat available
%%at each interval (heatbox), the Heat utility above the pinch, the Cold
%%utility below the pinch and the pinch temperature relative to the hot
%%stream
Sizeintervals=length(Tintervals);
mcpsum=zeros(Sizeintervals-1,1); heatbox=mcpsum; cumH=0; %intialize new counters, heat capacities and cum enthalpies
HeatUtility=mcpsum; Pinch=mcpsum; j=1;
for i=1:Sizeintervals-1
    hu=1;cu=1;
    while hu<=sizeH || cu<=sizeC
        %first check whether streams are within interval
        if hu>sizeH
        elseif Tintervals(i+1)<H(hu,3)...
                && Tintervals(i)>H(hu,4) 
            mcpsum(i)=mcpsum(i)+H(hu,2);
        end
        if cu>sizeC
        elseif Tintervals(i+1)<C(cu,4)+deltaTmin...
                && Tintervals(i)>C(cu,3)+deltaTmin
            mcpsum(i)=mcpsum(i)-C(cu,2);
        end
        hu=hu+1;
        cu=cu+1;
    end
    heatbox(i)=mcpsum(i)*(Tintervals(i)-Tintervals(i+1));
    cumH=cumH+heatbox(i);
    if cumH<=0
        Pinch(j)=Tintervals(i+1);
        HeatUtility(j)=-cumH;
        cumH=0;
        j=j+1;
    end
    if i+1==Sizeintervals
        ColdUtility=cumH;
    end
end
HeatUtility(j:end)=[];Pinch(j:end)=[];