function [ C ] = DelayDensity_MinArray(A,B)
%return C as the min of 2 arrays A and B

if(length(A)>length(B))
LengthOfDelta=length(B);
fprintf('DelayDensity_MinArray warning: the lenght of array of A and B is not equal!\n');
elseif(length(A)<length(B)) 
LengthOfDelta=length(A);
fprintf('DelayDensity_MinArray warning: the lenght of array of A and B is not equal!\n');
else
LengthOfDelta=length(A);
end

for i=1:LengthOfDelta
    if(A(i)<=B(i))
        C(i)=A(i);
    else
        C(i)=B(i);
    end
end

end

