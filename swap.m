function m=swap(m,left,right,rc)
%Swaps two values along with their corresponding rows or columns depending
%on the 4th argument
%The first argument is the matrix, the second and third arguments are the
%rows or columns
%wished to be swapped, and the 4th argument specifies whether they are rows
%or columns
%to specify rows rc='r'. Columns are anything else for rc
if left==right
    return;
elseif strcmp(rc,'r')
    tmp=m(left,:);
    m(left,:)=m(right,:);
    m(right,:)=tmp;
else
    tmp=m(:,left);
    m(:,left)=m(:,right);
    m(:,right)=tmp;
end


    
    

