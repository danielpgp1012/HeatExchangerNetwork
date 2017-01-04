function sorted=newquicksortcoldescending(sorted,left,right,rcnum)
if nargin==1
    left=1;
    right=length(sorted);
    rcnum=1;
end

if left<right
        ii=left;
        jj=right;
        pivotval=sorted(left+floor(rand(1)*(right-left+1)),rcnum);
        
        while ii<=jj
            
            while sorted(ii,rcnum)>pivotval
                ii=ii+1;
            end
            while sorted(jj,rcnum)<pivotval 
                jj=jj-1;
            end
            if ii<=jj
             sorted=swap(sorted,ii,jj,'r');
             ii=ii+1;
             jj=jj-1;
            end 
        end
        sorted=newquicksortcoldescending(sorted,left,jj,rcnum);
        sorted=newquicksortcoldescending(sorted,ii,right,rcnum);

end

        