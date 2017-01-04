function [flag, Hout, Cout]=Matching(H,C,deltaTmin,N,Nmin,position)
global STREAMNO MCP TINLET TOUTLET ENTHALPY
%%This function is meant to calculate the heat exchanged between two
%%individual streams, therefore, the inputs are single vectors for H and C
Hout=zeros(1,length(H));Cout=zeros(1,length(C)); flag=0;
if H(TINLET)<C(TINLET)
    flag=1;
elseif H(MCP)<C(MCP)
    if C(TINLET)+deltaTmin>=H(TOUTLET)
    Q=H(MCP)*(H(TINLET)-C(TINLET)+deltaTmin);
    else
    Q=H(MCP)*(H(TINLET)-H(TOUTLET));
    end
else
    if C(TINLET)+deltaTmin>=H(TOUTLET)
    Q=C(MCP)*(H(TINLET)-deltaTmin-C(TINLET));
    else
    Q=C(MCP)*(C(TOUTLET)-C(TINLET));
    end
end
if flag~=1 && Q>0
    Thout=H(TINLET)-Q/H(MCP);
    Tcout=C(TINLET)+Q/C(MCP);
    if N==Nmin-1
        if strcmp(position,'above') && abs(Thout-H(4))>=0.1
            flag=1;
        elseif abs(Tcout-C(TOUTLET))>=0.1
            flag=1;
        end
    end
    Hout=[H(1:3),Thout,H(ENTHALPY)-Q];
    Cout=[C(1:3),Tcout,C(ENTHALPY)-Q];
end
