function [AConcrete]=DelayDensity_TDMAModel_AConcrete_Generator(period,jitter,delta,wcet,NumOfTask,simulationtime);
%delta not used
%   此处显示详细说明
if (period<jitter)
   fprintf('DelayDensity_TDMAModel_AConcrete_Generator error: the period shoulde be larger as jitter!\n'); 
end
if (period*NumOfTask+jitter)>simulationtime
   fprintf('DelayDensity_TDMAModel_AConcrete_Generator warning: the simulationtime may be too short!\n');
end
StartTime(1)=0;
for i=2:NumOfTask
    StartTime(i)=period*(i-1)-jitter+floor(rand(1)*2*jitter+0.5);    
end

AConcrete(StartTime(1)+1:StartTime(2)+1)=wcet;
for i=2:NumOfTask-1
    AConcrete(StartTime(i)+2:StartTime(i+1)+1)=i*wcet;
end
AConcrete(StartTime(NumOfTask)+2:simulationtime+1)=NumOfTask*wcet;

figure(1);
hold on
plot(0:simulationtime,AConcrete,'r');

