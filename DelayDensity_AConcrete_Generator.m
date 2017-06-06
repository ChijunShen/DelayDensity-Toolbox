function [AConcrete]=DelayDensity_AConcrete_Generator(period,jitter,delta,phase,wcet,simulationtime);
%delta not used
%   此处显示详细说明
% if (period<jitter)
%    fprintf('DelayDensity_TDMAModel_AConcrete_Generator error: the period shoulde be larger as jitter!\n'); 
% end
StartTime(1)=0;
%StartTime(1)=floor(rand(1)*2*jitter+0.5);
i=2;
while(StartTime(i-1)<simulationtime)
    StartTime(i)=period*(i-1)-jitter+floor(rand(1)*2*jitter+0.5);    
    %wenn jitter > period
    if StartTime(i)<=StartTime(i-1)+delta
        StartTime(i)=StartTime(i-1)+delta;
    end
    i=i+1;
    
end
% for i=2:NumOfTask
%     StartTime(i)=period*(i-1)-jitter+floor(rand(1)*2*jitter+0.5);    
%     %wenn jitter > period
%     if StartTime(i)<=StartTime(i-1)
%         StartTime(i)=StartTime(i-1)+delta;
%     end
% end
NumOfTask=i-1;
AConcrete_(StartTime(1)+1:StartTime(2)+1)=wcet;
for i=2:NumOfTask-1
    AConcrete_(StartTime(i)+2:StartTime(i+1)+1)=i*wcet;
end
AConcrete_(StartTime(NumOfTask)+2:simulationtime+1)=NumOfTask*wcet;

for i=0:phase
    AConcrete(i+1)=0;
end
for i=phase+2:simulationtime+1
    AConcrete(i)=AConcrete_(i-phase);
end

%validation length
if length(AConcrete)~=simulationtime+1
     fprintf('DelayDensity_TDMAModel_AConcrete_Generator warning: the length of Aconcreter may be wrong!\n');
end

% figure(31);
% hold on
% plot(0:simulationtime,AConcrete,'r');