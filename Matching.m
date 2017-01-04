function [flag, Hout, Cout]=Matching(H,C,deltaTmin,N,Nmin,position)
%%This function is meant to calculate the heat exchanged between two
%%individual streams, therefore, the inputs are single vectors for H and C
Hout=zeros(1,length(H));Cout=zeros(1,length(C)); flag=0;
if H(3)<C(3)
    flag=1;
elseif H(2)<C(2)
    if C(3)+deltaTmin>=H(4)
    Q=H(2)*(H(3)-C(3)+deltaTmin);
    else
    Q=H(2)*(H(3)-H(4));
    end
else
    if C(3)+deltaTmin>=H(4)
    Q=C(2)*(H(3)-deltaTmin-C(3));
    else
    Q=C(2)*(C(4)-C(3));
    end
end
if flag~=1 && Q>0
    Thout=H(3)-Q/H(2);
    Tcout=C(3)+Q/C(2);
    if N==Nmin-1
        if strcmp(position,'above') && abs(Thout-H(4))>=0.1
            flag=1;
        elseif abs(Tcout-C(4))>=0.1
            flag=1;
        end
    end
    Hout=[H(1:3),Thout,H(5)-Q];
    Cout=[C(1:3),Tcout,C(5)-Q];
end
