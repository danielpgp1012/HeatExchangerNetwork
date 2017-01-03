function Tsorted=Tintervals(streams)
%%Function takes in streams containing stream No. Mcp. Tin Tout
Tsorted=[streams(:,3);streams(:,4)];
Tsorted=newquicksortcol(Tsorted);
