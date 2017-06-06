function [ DelayDensity ] = DelayDensity_GenerateDelayDensity( Responsetime,NumOfTask )
%DelayDensity_GenerateDelayDensity
%   此处显示详细说明

NumOfEvents=length(Responsetime);
%Sum Of Responsetime
for i=1:NumOfEvents
    SumOfResponsetime(i)=0;
    for j=1:i
        SumOfResponsetime(i)=SumOfResponsetime(i)+Responsetime(j);
    end
end
SumOfResponsetime=[0 SumOfResponsetime];
%LatenzDichte Formula: sup{f(delta+lamda)-f(delta)}
DelayDensity=DelayDensity_MinPlusDeconvolution(SumOfResponsetime,SumOfResponsetime);
DelayDensity=DelayDensity(2:NumOfTask+1);


end

