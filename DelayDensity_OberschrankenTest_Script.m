%Oberschranken von drei Kurven testen
%FP
clear;
clc;
%hier kann man die Parameter von Task Set einstellen
%3 Prioritat:Task1>Task2>Task3

% p1=100;j1=0;d1=2;e1=15;ph1max=p1-j1;
% p2=100;j2=0;d2=2;e2=20;ph2max=p2-j2;
% p3=50;j3=50;d3=1;e3=30;ph3=0;

% p1=10;j1=20;d1=2;e1=2;ph1max=p1-j1;
% p2=20;j2=40;d2=2;e2=5;ph2max=p2-j2;
% p3=30;j3=50;d3=2;e3=3;ph3=0;


p1=10;j1=10;d1=2;e1=2;ph1max=p1-j1;
p2=16;j2=17;d2=2;e2=5;ph2max=p2-j2;
p3=19;j3=15;d3=2;e3=4;ph3=0;

%hier kann man die Parameter von FP einstellen
CPU_Bandwidth=1;%resource unit/s
simulationtime=1000;%time unit
NumOfTask=10;

%dr+ berechnen
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L,B1U,B1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,simulationtime);

%Analysieren
[StartTimeOfTask1,ResponstimeOfTask1]=DelayDensity_ResponseTimeAnalyse( A1U,B1L,B1_L,e1,simulationtime);
[StartTimeOfTask2,ResponstimeOfTask2]=DelayDensity_ResponseTimeAnalyse( A2U,B1_L,B2_L,e2,simulationtime);
[StartTimeOfTask3,ResponstimeOfTask3,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,simulationtime);
RepeatInstantNum

%validation by rtc toolbox
rtctoolbox_validation=0;
if rtctoolbox_validation==1
    a1 = rtcpjd(p1, j1*2, d1);
    a2 = rtcpjd(p2, j2*2, d2);
    a3 = rtcpjd(p3, j3*2, d3);
    b1 = rtcfs(1);
    [a_1,b_1,de11,buf1]=rtcgpc(a1,b1,e1);
    [a_2,b_2,de12,buf2]=rtcgpc(a2,b_1,e2);
    [a_3,b_3,de13,buf3]=rtcgpc(a3,b_2,e3);
    %validation a1u a1l
    figure(75)
    hold on
    plot(0:simulationtime,A1U/e1,'r');
    plot(0:simulationtime,A1L/e1,'k');
    rtcplot(a1, 'g--',simulationtime);
    %validation b1_u b1_l
    figure(76)
    hold on
    plot(0:simulationtime,B1_U,'r');
    plot(0:simulationtime,B1_L,'k');
    rtcplot(b_1, 'g--',simulationtime);
    %validation a2u a2l
    figure(77)
    hold on
    plot(0:simulationtime,A2U/e2,'r');
    plot(0:simulationtime,A2L/e2,'k');
    rtcplot(a2, 'g--',simulationtime);
    %validation b2_u b2_l
    figure(78);
    hold on
    plot(0:simulationtime,B2_U,'r');
    plot(0:simulationtime,B2_L,'k');
    rtcplot(b_2, 'g--',simulationtime);
    %validation a3u a3l
    figure(79)
    hold on
    plot(0:simulationtime,A3U/e3,'r');
    plot(0:simulationtime,A3L/e3,'k');
    rtcplot(a3, 'g--',simulationtime);
    %validation b3_u b3_l
    figure(80);
    hold on
    plot(0:simulationtime,B3_U,'r');
    plot(0:simulationtime,B3_L,'k');
    rtcplot(b_3, 'g--',simulationtime);
    pause
end

%plotten
DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask1,ResponstimeOfTask1,10,3,1,simulationtime);
DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask2,ResponstimeOfTask2,10,3,2,simulationtime);
DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask3,ResponstimeOfTask3,10,3,3,simulationtime);
DelayDensity_ResponseTimeAnalyseAllPlot( StartTimeOfTask1,ResponstimeOfTask1,StartTimeOfTask2,ResponstimeOfTask2,StartTimeOfTask3,ResponstimeOfTask3,1,simulationtime);

ResultOfTask = DelayDensity_FeasibleTest( ResponstimeOfTask3,p3);
if ResultOfTask==0
    fprintf('System by dr+ is not Feasible\n')
end
DelayDensity_FPModel=DelayDensity_GenerateDelayDensity(ResponstimeOfTask3,NumOfTask);
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
    DelayDensity_FPModel_Neu=DelayDensity_GenerateDelayDensity(Instanz_Neu,NumOfTask);
    figure(20);
    hold on
    plot(1:NumOfTask,DelayDensity_FPModel_Neu,'m');
end

%kurve 3
if RepeatInstantNum~=0
    Instanz_Kurve3(1:RepeatInstantNum+1)=DelayDensity_FPModel(1);
    for i=1:length(ResponstimeOfTask3)
        RepeatIndex=mod(i,RepeatInstantNum);
        if RepeatIndex==0
            RepeatIndex=RepeatInstantNum;
        end
        Instanz_Kurve3(i+RepeatInstantNum+1)=ResponstimeOfTask3(RepeatIndex); 
    end
    DelayDensity_FPModel_Kurve3=DelayDensity_GenerateDelayDensity(Instanz_Kurve3,NumOfTask);
    figure(20);
    hold on
    plot(1:NumOfTask,DelayDensity_FPModel_Kurve3,'g');
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
    DelayDensity_NewKurve(i,:)=DelayDensity_GenerateDelayDensity(Array(i,:),NumOfTask);%Falsh geschrieben:Array
end
DelayDensity_NewKurve_Oberschranken=DelayDensity_NewKurve(1,:);
for i=2:RepeatInstantNum
    DelayDensity_NewKurve_Oberschranken=DelayDensity_MaxArray(DelayDensity_NewKurve_Oberschranken,DelayDensity_NewKurve(i,:));
end
plot(1:NumOfTask,DelayDensity_NewKurve_Oberschranken,'b');

%kurve4
MaxIndex=1;
if RepeatInstantNum~=0
    for i=1:RepeatInstantNum
        if ResponstimeOfTask3(i)==DelayDensity_FPModel(1)
            MaxIndex=i;
        end
    end
    for i=1:length(ResponstimeOfTask3)
        RepeatIndex=mod(i,MaxIndex);
        if RepeatIndex==0
            RepeatIndex=MaxIndex;
        end
        Instanz_Shen(i)=ResponstimeOfTask3(RepeatIndex); 
    end
    MaxIndex
    DelayDensity_Shen(i,:)=DelayDensity_GenerateDelayDensity(Instanz_Shen,NumOfTask);%Falsh geschrieben:Array
    plot(1:NumOfTask,DelayDensity_Shen,'y');
end
pause


%simulation

figureIndex=100;
allIndex=1000;
for i=0:0%ph1max
    for j=0:0%ph2max
        for k=1:10000;
            ph1=i;
            ph2=j;
             %Simulation
             A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,simulationtime);
            [A1_C,B1_C,B1C]=DelayDensity_FPConcreteModelInit( A1C,CPU_Bandwidth,simulationtime);
            A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,simulationtime);
             [A2_C,B2_C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,simulationtime);
            A3C=DelayDensity_AConcrete_Generator(p3,j3,d3,ph3,e3,simulationtime);
            [A3_C,B3_C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);
            
            [StartTimeOfCase1,ResponstimeOfCase1]=DelayDensity_ResponseTimeAnalyse( A1C,B1C,B1_C,e1,simulationtime);
            [StartTimeOfCase2,ResponstimeOfCase2]=DelayDensity_ResponseTimeAnalyse( A2C,B1_C,B2_C,e2,simulationtime);
            [StartTimeOfCase,ResponstimeOfCase]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,simulationtime);
            
            ResultOfTask = 1;%DelayDensity_FeasibleTest( ResponstimeOfCase,p3);
            %ResultOfTask3=DelayDensity_FeasibleTest(ResponstimeOfCase,p3);
            
            
            if(ResultOfTask)
                TestCase_DelayDensity_FPModel=DelayDensity_GenerateDelayDensity(ResponstimeOfCase,NumOfTask); 
                figure(20);
                hold on
                %if ~DelayDensity_TestUpperBound(DelayDensity_NewKurve_Oberschranken,TestCase_DelayDensity_FPModel) 
                if ~DelayDensity_TestUpperBound(DelayDensity_FPModel_Kurve3,TestCase_DelayDensity_FPModel) 
                   
                 %if(TestCase_DelayDensity_FPModel(NumOfTask)>DelayDensity_NewKurve_Oberschranken(NumOfTask))%||TestCase_DelayDensity_FPModel(2)>23)
                    plot(1:NumOfTask,TestCase_DelayDensity_FPModel,'b'); 
                     StartTimeOfCase1
                     StartTimeOfCase2
                     StartTimeOfCase
                     ResponstimeOfCase
                     pause
                    allIndex=allIndex+1;
                    figureIndex=figureIndex+1;
                else
                   plot(1:NumOfTask,TestCase_DelayDensity_FPModel,'b--');
                end
                
            end
            clc
            fprintf('procent: %3.2f\n',k/1000);
        end
    end
  end

