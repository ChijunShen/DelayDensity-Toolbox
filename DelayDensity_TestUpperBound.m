function [ C ] = DelayDensity_TestUpperBound(A,B)
%test if array A ist UpperBound of array B
%return 1 if is UpperBound return B if is not UpperBound

if(length(A)>length(B))
LengthOfDelta=length(B);
fprintf('DelayDensity_MinArray warning: the lenght of array of A and B is not equal!\n');
elseif(length(A)<length(B)) 
LengthOfDelta=length(A);
fprintf('DelayDensity_MinArray warning: the lenght of array of A and B is not equal!\n');
else
LengthOfDelta=length(A);
end

C=1;
for i=1:LengthOfDelta
    if(A(i)<B(i))
        C=0;
    end

end


