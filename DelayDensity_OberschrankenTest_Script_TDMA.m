%Oberschranken von drei Kurven testen
%FP
clear;
clc;
%hier kann man die Parameter von Task Set einstellen
p1=10;j1=0;d1=2;e1=2;ph1max=p1-j1;
p2=16;j2=0;d2=2;e2=7;ph2max=p2-j2;
p3=19;j3=0;d3=2;e3=4;ph3=0;

%hier kann man die Parameter von FP einstellen
CPU_Bandwidth=1;%resource unit/s
simulationtime=1000;%time unit
NumOfTask=40;

%dr+ berechnen
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L,B1U,B1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,simulationtime);

%Analysieren
[StartTimeOfTask1,ResponstimeOfTask1]=DelayDensity_ResponseTimeAnalyse( A1U,B1L,B1_L,e1,NumOfTask,simulationtime);
[StartTimeOfTask2,ResponstimeOfTask2]=DelayDensity_ResponseTimeAnalyse( A2U,B1_L,B2_L,e2,NumOfTask,simulationtime);
[StartTimeOfTask3,ResponstimeOfTask3,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,NumOfTask,simulationtime)
%ploten
DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask1,ResponstimeOfTask1,10,3,1,simulationtime);
DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask2,ResponstimeOfTask2,10,3,2,simulationtime);
DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask3,ResponstimeOfTask3,10,3,3,simulationtime);
DelayDensity_ResponseTimeAnalyseAllPlot( StartTimeOfTask1,ResponstimeOfTask1,StartTimeOfTask2,ResponstimeOfTask2,StartTimeOfTask3,ResponstimeOfTask3,1,simulationtime);

ResultOfTask = DelayDensity_FeasibleTest( ResponstimeOfTask3,p3);
if ResultOfTask==0
    fprintf('System by dr+ is not Feasible\n')
end
DelayDensity_FPModel=DelayDensity_GenerateDelayDensity(ResponstimeOfTask3);
Latenz_DBDD(1:NumOfTask)=(1:NumOfTask)*DelayDensity_FPModel(1);
figure(20);
hold on
plot(1:NumOfTask,DelayDensity_FPModel,'r');%kurve DFDD
plot(1:NumOfTask,Latenz_DBDD,'k');%kurve DBDD

%kurve 1
if RepeatInstantNum~=0
    for i=1:length(ResponstimeOfTask3)
        RepeatIndex=mod(i,RepeatInstantNum);
        if RepeatIndex==0
            RepeatIndex=RepeatInstantNum;
        end
        Instanz_Neu(i)=ResponstimeOfTask3(RepeatIndex); 
    end
%     for i=1:NumOfTask
%         RepeatIndex=mod(i,RepeatInstantNum);
%         Instanz_Neu(i)=ResponstimeOfTask3(RepeatIndex+1); 
%     end
    DelayDensity_FPModel_Neu=DelayDensity_GenerateDelayDensity(Instanz_Neu);
    figure(20);
    hold on
    plot(1:NumOfTask,DelayDensity_FPModel_Neu,'m');
end

%kurve2
for i=1:RepeatInstantNum %RepeatInstantNum herstellen
    for j=1:length(ResponstimeOfTask3)
        index=mod(j,i);
        if index==0
            index=i;
        end
        Array(i,j)=ResponstimeOfTask3(index);
    end
    DelayDensity_NewKurve(i,:)=DelayDensity_GenerateDelayDensity(Array(i,:));%Falsh geschrieben:Array
end

DelayDensity_NewKurve_Oberschranken=DelayDensity_NewKurve(1,:);
for i=2:RepeatInstantNum
    DelayDensity_NewKurve_Oberschranken=DelayDensity_MaxArray(DelayDensity_NewKurve_Oberschranken,DelayDensity_NewKurve(i,:));
end
plot(1:NumOfTask,DelayDensity_NewKurve_Oberschranken,'b');

%simulation

% figureIndex=100;
% allIndex=1000;
% for i=0:0%ph1max
%     for j=0:0%ph2max
%         for k=1:10000;
%             ph1=i;
%             ph2=j;
%              %Simulation
%              A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,NumOfTask,simulationtime);
%             [A1_C,B1_C,B1C]=DelayDensity_FPConcreteModelInit( A1C,CPU_Bandwidth,simulationtime);
%             A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,NumOfTask,simulationtime);
%              [A2_C,B2_C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,simulationtime);
%             A3C=DelayDensity_AConcrete_Generator(p3,j3,d3,ph3,e3,NumOfTask,simulationtime);
%             [A3_C,B3_C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);
%             
%             [StartTimeOfCase1,ResponstimeOfCase1]=DelayDensity_ResponseTimeAnalyse( A1C,B1C,B1_C,e1,NumOfTask,simulationtime);
%             [StartTimeOfCase2,ResponstimeOfCase2]=DelayDensity_ResponseTimeAnalyse( A2C,B1_C,B2_C,e2,NumOfTask,simulationtime);
%             [StartTimeOfCase,ResponstimeOfCase]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,NumOfTask,simulationtime);
%             
%             ResultOfTask = 1;%DelayDensity_FeasibleTest( ResponstimeOfCase,p3);
%             %ResultOfTask3=DelayDensity_FeasibleTest(ResponstimeOfCase,p3);
%             
%             
%             if(ResultOfTask)
%                 TestCase_DelayDensity_FPModel=DelayDensity_GenerateDelayDensity(ResponstimeOfCase); 
%                 figure(20);
%                 hold on
%                  if(TestCase_DelayDensity_FPModel(NumOfTask)>DelayDensity_NewKurve_Oberschranken(NumOfTask))%||TestCase_DelayDensity_FPModel(2)>23)
%                     plot(1:NumOfTask,TestCase_DelayDensity_FPModel,'r--'); 
%                     allIndex=allIndex+1;
%                     figureIndex=figureIndex+1;
%                else
%                     plot(1:NumOfTask,TestCase_DelayDensity_FPModel,'b--');
%                 end
%                 
%             end
%             fprintf('procent: %3.2f\n',k/10000);
%         end
%     end
%   end

