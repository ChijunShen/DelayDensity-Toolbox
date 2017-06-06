function [ ReturnValue ] = DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask,ResponstimeOfTask,FigureNum,NumOfTasks,IndexOfTask,simulationtime)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
figure(FigureNum);
hold on;
subplot(NumOfTasks,1,IndexOfTask);
xlim([0 simulationtime])
hold on;
ResponseTimeAnalysePlot=zeros(simulationtime+1,1);
for i=1:length(ResponstimeOfTask);
    startTime=StartTimeOfTask(i);
    responseTime=ResponstimeOfTask(i);
    x=[startTime startTime+responseTime startTime+responseTime startTime];
    y=[0 0 1 1];
    fill(x,y,'r')
end
% plot(0:simulationtime,ResponseTimeAnalysePlot,'r');
ReturnValue=1;
end

