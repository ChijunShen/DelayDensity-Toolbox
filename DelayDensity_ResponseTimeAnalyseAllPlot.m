function [ ReturnValue ] = DelayDensity_ResponseTimeAnalyseAllPlot( StartTimeOfTask1,ResponstimeOfTask1,StartTimeOfTask2,ResponstimeOfTask2,StartTimeOfTask3,ResponstimeOfTask3,figureIndex,simulationtime)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
figure(figureIndex)
hold on;
xlim([0 simulationtime])
ResponseTimeAnalyse1=zeros(simulationtime+1,1);
ResponseTimeAnalyse2=zeros(simulationtime+1,1);
ResponseTimeAnalyse3=zeros(simulationtime+1,1);
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
for i=1:length(ResponstimeOfTask3);
    startTime=StartTimeOfTask3(i);
    for j=0:ResponstimeOfTask3(i)-1;
        ResponseTimeAnalyse3(startTime+j+1)=1;
    end
end
for i=1:simulationtime+1
    if ResponseTimeAnalyse1(i)==1
        AllAnalyse(i)=1;
    elseif ResponseTimeAnalyse2(i)==1
        AllAnalyse(i)=2;
    elseif ResponseTimeAnalyse3(i)==1
        AllAnalyse(i)=3;
    else
        AllAnalyse(i)=4;
    end
end

%plot
for i=1:simulationtime+1
    if AllAnalyse(i)==1;
         x=[i-1 i i i-1];
         y=[0 0 1 1];
         fill(x,y,'r')
    elseif AllAnalyse(i)==2;
         x=[i-1 i i i-1];
         y=[0 0 1 1];
         fill(x,y,'g')
    elseif AllAnalyse(i)==3;
         x=[i-1 i i i-1];
         y=[0 0 1 1];
         fill(x,y,'b')
         
%     if AllAnalyse(i)==1&&AllAnalyse(i+1)==1;%1
%          x=[i-1 i i i-1];
%          y=[0 0 1 1];
%          fill(x,y,'r')
%     elseif AllAnalyse(i)==1&&AllAnalyse(i+1)==2;%1->2
%          x=[i-1 i i i-1];
%          y=[0 0 1 1];
%          fill(x,y,'g')
%     elseif AllAnalyse(i)==2&&AllAnalyse(i+1)==1;%2->1
%          x=[i-1 i i i-1];
%          y=[0 0 1 1];
%          fill(x,y,'r')
%     elseif AllAnalyse(i)==1&&AllAnalyse(i+1)==3;%1->3
%          x=[i-1 i i i-1];
%          y=[0 0 1 1];
%          fill(x,y,'b')
%     elseif AllAnalyse(i)==1&&AllAnalyse(i+1)==3;%3->1
%          x=[i-1 i i i-1];
%          y=[0 0 1 1];
%          fill(x,y,'r')
%     elseif AllAnalyse(i)==2&&AllAnalyse(i+1)==2;%2
%          x=[i-1 i i i-1];
%          y=[0 0 1 1];
%          fill(x,y,'g')
%     elseif AllAnalyse(i)==2&&AllAnalyse(i+1)==3;%2->3
%          x=[i-1 i i i-1];
%          y=[0 0 1 1];
%          fill(x,y,'b')
%     elseif AllAnalyse(i)==3&&AllAnalyse(i+1)==2;%3->2
%          x=[i-1 i i i-1];
%          y=[0 0 1 1];
%          fill(x,y,'g')
%     elseif AllAnalyse(i)==3&&AllAnalyse(i+1)==3;%3
%          x=[i-1 i i i-1];
%          y=[0 0 1 1];
%          fill(x,y,'b')
    end
end


%plot(0:simulationtime,ResponseTimeAnalysePlot,'r');
ReturnValue=1;
% AllAnalyse
end