function [ ReturnValue ] = DelayDensity_ResponseTimeAnalysePlot2Tasks( StartTimeOfTask1,ResponstimeOfTask1,StartTimeOfTask2,ResponstimeOfTask2,figureIndex,simulationtime)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
figure(figureIndex)
hold on;
xlim([0 simulationtime])
ResponseTimeAnalyse1=zeros(simulationtime+1,1);
ResponseTimeAnalyse2=zeros(simulationtime+1,1);
AllAnalyse=zeros(simulationtime+1,1);
for i=1:length(ResponstimeOfTask1);
    startTime=StartTimeOfTask1(i);
    for j=0:ResponstimeOfTask1(i)-1;
        ResponseTimeAnalyse1(startTime+j+1)=1;
    end
end
for i=1:length(ResponstimeOfTask2);
    startTime=StartTimeOfTask2(i);
    for j=0:ResponstimeOfTask2(i)-1;
        ResponseTimeAnalyse2(startTime+j+1)=1;
    end
end
for i=1:simulationtime+1
    if ResponseTimeAnalyse1(i)==1
        AllAnalyse(i)=1;
    elseif ResponseTimeAnalyse2(i)==1
        AllAnalyse(i)=2;
    else
        AllAnalyse(i)=3;
    end
end
for i=1:simulationtime+1
    if AllAnalyse(i)==1;
         x=[i-1 i i i-1];
         y=[0 0 1 1];
         fill(x,y,'r')
    elseif AllAnalyse(i)==2;
         x=[i-1 i i i-1];
         y=[0 0 1 1];
         fill(x,y,'g')
    end
end
ReturnValue=1;
end

