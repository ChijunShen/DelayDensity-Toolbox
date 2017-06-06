%Oberschranken testen
%FP
%clear;
clc;
%hier kann man die Parameter von Task Set einstellen
%3 Prioritat:Task1>Task2>Task3

% p1=100;j1=0;d1=2;e1=15;ph1max=p1-j1;
% p2=100;j2=0;d2=2;e2=20;ph2max=p2-j2;
% p3=50;j3=50;d3=1;e3=30;ph3=0;

%5 is regler task FP
p1=100;j1=30;d1=2;e1=10;ph1=0;
p2=200;j2=40;d2=2;e2=20;ph2=0;
p3=300;j3=20;d3=2;e3=25;ph3=0;
p4=400;j4=30;d4=2;e4=30;ph4=0;
%p5=30;j5=100;d5=2;e5=4;ph5=0;
e5=20;
%bus tdma 1 Ereignis von Encoder
p6=100;j6=20;d6=2;e6=1;ph6=0;
TDMA_Cycle=7;
TDMA_Slot=2;
TDMA_Phase=0;
CPU_Bandwidth=1;
simulationtime=6000;
NumOfTask=10;
%hier kann man die Parameter von FP einstellen


%dr+ berechnen
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L,B1U,B1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,simulationtime);
[ A4_U,A4_L,B4_U,B4_L,A4U,A4L ] = DelayDensity_ConnectWithFPModel( B3_U,B3_L,p4,j4,d4,e4,simulationtime);
[ A6_U,A6_L,B6_U,B6_L,A6U,A6L,B6U,B6L ] = DelayDensity_TDMAModelInit( p6,j6,d6,e6,CPU_Bandwidth,TDMA_Cycle,TDMA_Slot,simulationtime);
[ A5_U,A5_L,B5_U,B5_L] = DelayDensity_GPCModel(A6_U*e5,A6_L*e5,B4_U,B4_L);

%Analysieren
%[StartTimeOfTask1,ResponstimeOfTask1]=DelayDensity_ResponseTimeAnalyse( A1U,B1L,B1_L,e1,simulationtime);
%[StartTimeOfTask2,ResponstimeOfTask2]=DelayDensity_ResponseTimeAnalyse( A2U,B1_L,B2_L,e2,simulationtime);
[StartTimeOfTask5,ResponstimeOfTask5,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A6_U*e5,B4_L,B5_L,e5,simulationtime)
% plot(0:simulationtime,B4_L,'b',0:simulationtime,A6_U/e6*e5,'r');
% pause
Max_Responstime=max(ResponstimeOfTask5);
for i=1:RepeatInstantNum
    if ResponstimeOfTask5(i)==Max_Responstime
        MaxIndex=i;
    end
end
Sort_ResponstimeOfTask5=sort(ResponstimeOfTask5,'descend')
% MaxIndex
%RepeatInstantNum




%kurve nach victor
for i=1:RepeatInstantNum %RepeatInstantNum herstellen
    for j=1:length(ResponstimeOfTask5)
        index=mod(j,i);
        if index==0
            index=i;
        end
        Array(i,j)=ResponstimeOfTask5(index);
    end
    DelayDensity_NewKurve(i,:)=DelayDensity_GenerateDelayDensity(Array(i,:),NumOfTask);%Falsh geschrieben:Array
end
DelayDensity_NewKurve_Oberschranken=DelayDensity_NewKurve(1,:);
for i=2:RepeatInstantNum
    DelayDensity_NewKurve_Oberschranken=DelayDensity_MaxArray(DelayDensity_NewKurve_Oberschranken,DelayDensity_NewKurve(i,:));
end


%kurve nach shen
if RepeatInstantNum~=0
    for i=1:length(ResponstimeOfTask5)
        RepeatIndex=mod(i,RepeatInstantNum);
        if RepeatIndex==0
            RepeatIndex=RepeatInstantNum;
        end
        Instanz_Neu(i)=Sort_ResponstimeOfTask5(RepeatIndex); 
    end
    DelayDensity_FPModel_Neu=DelayDensity_GenerateDelayDensity(Instanz_Neu,NumOfTask);
end

figure(20);
hold on
plot(1:NumOfTask,DelayDensity_NewKurve_Oberschranken,'y');
plot(1:NumOfTask,DelayDensity_FPModel_Neu,'m');
fprintf('enter any key to start simulation')
pause

%test
Schranke=zeros(2,10);
for i=1:5000
    A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,simulationtime);
    [A1_C,B1_C,B1C]=DelayDensity_FPConcreteModelInit( A1C,CPU_Bandwidth,simulationtime);
    A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,simulationtime);
    [A2_C,B2_C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,simulationtime);
    A3C=DelayDensity_AConcrete_Generator(p3,j3,d3,ph3,e3,simulationtime);
    [A3_C,B3_C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);
    A4C=DelayDensity_AConcrete_Generator(p4,j4,d4,ph4,e4,simulationtime);
    [A4_C,B4_C]=DelayDensity_ConnectWithConcreteFPModel( B3_C,A4C,simulationtime);
    %A5C=DelayDensity_AConcrete_Generator(p5,j5,d5,ph5,e5,simulationtime);
    A6C=DelayDensity_AConcrete_Generator(p6,j6,d6,ph6,e6,simulationtime);
%     A6C=A6C_/e6*e5;
    [ A6_C_,B6_C,B6C ] = DelayDensity_TDMAConcreteModel( A6C,CPU_Bandwidth,TDMA_Cycle,TDMA_Slot,TDMA_Phase,simulationtime);
    A6_C=A6_C_/e6*e5;
    [ A5_C,B5_C] = DelayDensity_ConnectWithConcreteFPModel( B4_C,A6_C,simulationtime);
    %[A5_C,B5_C]=DelayDensity_ConnectWithConcreteFPModel( B4_C,A5C,simulationtime);
    [StartTimeOfCase5,ResponstimeOfCase5]=DelayDensity_ResponseTimeAnalyse( A6_C,B4_C,B5_C,e5,simulationtime);
    SortArray=sort(ResponstimeOfCase5,'descend');
    Schranke=sort([Schranke(1,:);SortArray(1:10)],'descend');
    Schranke(1,:)
    
    figure(20);
    hold on
    DelayDensity_FPModel_Case=DelayDensity_GenerateDelayDensity(ResponstimeOfCase5,NumOfTask);
    plot(1:NumOfTask,DelayDensity_FPModel_Case,'b-');
%     if(SortArray(2)>110)
%         StartTimeOfCase5
%         ResponstimeOfCase5
%         fprintf('enter any key to continue')
%         pause
%     end
    %SortArray(1:10)
    
end

