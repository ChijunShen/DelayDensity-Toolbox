function [ C ] = DelayDensity_MinPlusConvolution(A,B)
%MinPlusConvolution of Stream A and Stream B
%A and B are 2 Arrays, Output C is also an Array
%formal:inf 0<=Lamda<=Delta(A(Delta-Lamda)+B(Lamda))
if(length(A)>length(B))
LengthOfDelta=length(B);
fprintf('DelayDensity_MinPlusConvolution warning: the lenght of array of A and B is not equal!\n');
elseif(length(A)<length(B)) 
LengthOfDelta=length(A);
fprintf('DelayDensity_MinPlusConvolution warning: the lenght of array of A and B is not equal!\n');
else
LengthOfDelta=length(A);
end
for Delta=0:LengthOfDelta-1
    %min value set to Lamda=0
    minvalue=A(Delta+1)+B(1);
    for Lamda=1:Delta
        temp=A(Delta-Lamda+1)+B(Lamda+1);
        if(temp<minvalue) 
            minvalue=temp;
        end
    end    
    C(Delta+1)=minvalue;
end
end