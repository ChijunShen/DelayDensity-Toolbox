function [ C ] = DelayDensity_MaxPlusConvolution(A,B)
%MaxPlusConvolution of Stream A and Stream B
%A and B are 2 Arrays, Output C is also an Array
%formal:sup 0<=Lamda<=Delta(A(Delta-Lamda)+B(Lamda))
if(length(A)>length(B))
LengthOfDelta=length(B);
fprintf('DelayDensity_MaxPlusConvolution warning: the lenght of array of A and B is not equal!\n');
elseif(length(A)<length(B)) 
LengthOfDelta=length(A);
fprintf('DelayDensity_MaxPlusConvolution warning: the lenght of array of A and B is not equal!\n');
else
LengthOfDelta=length(A);
end
for Delta=0:LengthOfDelta-1
    %max value set to Lamda=0
    maxvalue=A(Delta+1)+B(1);
    for Lamda=1:Delta
        temp=A(Delta-Lamda+1)+B(Lamda+1);
        if(temp>maxvalue) 
            maxvalue=temp;
        end
    end    
    C(Delta+1)=maxvalue;
end
end

