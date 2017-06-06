# DelayDensity-Toolbox
DelayDensity-Toolbox, a open framework to study delay density
# Usage Example
# case1:three task with RM schedule
p1=30,e1=5,ph1=0;p2=40,e2=10,ph2=0;p3=60,e3=20,phi3=0
validation is correct
clear;
clc;
p1=25;e1=5;ph1=0;
p2=40;e2=10;ph2=0;
p3=60;e3=20;ph3=0;
NumOfTask=5;
simulationtime=300;
CPU_Bandwidth=1;
[A1_C,B1_C,A1C,B1C]=DelayDensity_FPConcreteModelInit( p1,p1,ph1,e1,CPU_Bandwidth,simulationtime);
[A2_C,B2_C,A2C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,p2,p2,ph2,e2,simulationtime);
[A3_C,B3_C,A3C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,p3,p3,ph3,e3,simulationtime)
[StartTimeOfTask1,ResponstimeOfTask1]=DelayDensity_ResponseTimeAnalyse( A1C,B1C,B1_C,e1,NumOfTask,simulationtime)
ResultOfTask1=DelayDensity_FeasibleTest(ResponstimeOfTask1,p1);
[StartTimeOfTask2,ResponstimeOfTask2]=DelayDensity_ResponseTimeAnalyse( A2C,B1_C,B2_C,e2,NumOfTask,simulationtime)
ResultOfTask2=DelayDensity_FeasibleTest(ResponstimeOfTask2,p2);
[StartTimeOfTask3,ResponstimeOfTask3]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,NumOfTask,simulationtime)
ResultOfTask3=DelayDensity_FeasibleTest(ResponstimeOfTask3,p3);



# case1:2 task with RM schedule compute the first responstime of task2
%answer is 114 s
p1=70,e1=26,ph1=0;p2=100,e2=60,ph2=0
validation is correct
clear;
clc;
p1=70;e1=26;ph1=0;
p2=100;e2=62;ph2=0;
NumOfTask=2;
simulationtime=300;
CPU_Bandwidth=1;
[A1_C,B1_C,A1C,B1C]=DelayDensity_FPConcreteModelInit( p1,p1,ph1,e1,CPU_Bandwidth,simulationtime);
[StartTimeOfTask1,ResponstimeOfTask1]=DelayDensity_ResponseTimeAnalyse( A1C,B1C,B1_C,e1,NumOfTask,simulationtime)
ResultOfTask1=DelayDensity_FeasibleTest(ResponstimeOfTask1,p1);

[A2_C,B2_C,A2C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,p2,p2,ph2,e2,simulationtime);
[StartTimeOfTask2,ResponstimeOfTask2]=DelayDensity_ResponseTimeAnalyse( A2C,B1_C,B2_C,e2,NumOfTask,simulationtime)
ResultOfTask2=DelayDensity_FeasibleTest(ResponstimeOfTask2,p2);
ResponstimeOfTask2(1)

# case3;verify the maximal Latenz of a FP System for task 3 and show random Simulation 
%%rtc toolboxbei A_U hat Probleme
%gegen Beispiele
clear;
clc;
p1=10;j1=0;d1=2;e1=2;ph1max=p1;
p2=15;j2=0;d2=2;e2=4;ph2max=p2;
p3=20;j3=0;d3=2;e3=3;ph3=0;
CPU_Bandwidth=1;
sollwert=15;
simulationtime=1000;
NumOfTask=40;
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L,B1U,B1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,simulationtime);

[StartTimeOfTask1,ResponstimeOfTask1]=DelayDensity_ResponseTimeAnalyse( A1U,B1L,B1_L,e1,simulationtime);
[StartTimeOfTask2,ResponstimeOfTask2]=DelayDensity_ResponseTimeAnalyse( A2U,B1_L,B2_L,e2,simulationtime);
[StartTimeOfTask3,ResponstimeOfTask3,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,simulationtime);

DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask1,ResponstimeOfTask1,10,3,1,1000);
DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask2,ResponstimeOfTask2,10,3,2,1000);
DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask3,ResponstimeOfTask3,10,3,3,1000);

DelayDensity_ResponseTimeAnalyseAllPlot( StartTimeOfTask1,ResponstimeOfTask1,StartTimeOfTask2,ResponstimeOfTask2,StartTimeOfTask3,ResponstimeOfTask3,1,1000);



% [StartTimeOfTask3_,ResponstimeOfTask3_]=DelayDensity_ResponseTimeAnalyse( A3U,B2_U,B3_U,e3,NumOfTask,simulationtime);
ResultOfTask = DelayDensity_FeasibleTest( ResponstimeOfTask3,p3);
if ResultOfTask==0
    fprintf('Error!!System is not Feasible')
end
DelayDensity_FPModel=DelayDensity_GenerateDelayDensity(ResponstimeOfTask3,NumOfTask);
% DelayDensity_FPModel_=DelayDensity_GenerateDelayDensity(ResponstimeOfTask3_);
Latenz_DBDD(1:NumOfTask)=(1:NumOfTask)*DelayDensity_FPModel(1);
figure(20);
hold on
plot(1:NumOfTask,DelayDensity_FPModel,'r');
% plot(1:NumOfTask,DelayDensity_FPModel_,'y');
plot(1:NumOfTask,Latenz_DBDD,'k');
% figure(2);
% hold on
% plot(0:simulationtime,A2_L/5,'r');
% plot(0:simulationtime,A2_U/5,'r');
% figure(6);
% hold on
% plot(0:simulationtime,A1L,'r');
% plot(0:simulationtime,A1U,'r');
% figure(3);
% hold on
% plot(0:simulationtime,B3_L,'r');
% plot(0:simulationtime,B3_U,'r');

%changed Latenzdicht
%RepeatInstantNum=3;
if RepeatInstantNum~=0
    for i=1:NumOfTask
        RepeatIndex=mod(i,RepeatInstantNum);
        Instanz_Neu(i)=ResponstimeOfTask3(RepeatIndex+1); 
    end
    DelayDensity_FPModel_Neu=DelayDensity_GenerateDelayDensity(Instanz_Neu,NumOfTask);
    figure(20);
    hold on
    plot(1:NumOfTask,DelayDensity_FPModel_Neu,'m');
end
% plot(0:simulationtime,B2_L-B3_L,'k');

figureIndex=100;
allIndex=1000;
for i=0:ph1max
    for j=0:ph2max
        for k=1:1;
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
                 if(~DelayDensity_TestUpperBound(DelayDensity_FPModel,TestCase_DelayDensity_FPModel))
                 %if(TestCase_DelayDensity_FPModel(NumOfTask)>DelayDensity_FPModel(NumOfTask))%||TestCase_DelayDensity_FPModel(2)>23)
                    plot(1:NumOfTask,TestCase_DelayDensity_FPModel,'r--'); 
%                     StartTimeOfCase
%                     ResponstimeOfCase
%                     DelayDensity_ResponseTimeAnalysePlot( StartTimeOfCase1,ResponstimeOfCase1,figureIndex,3,1,500);
%                     DelayDensity_ResponseTimeAnalysePlot( StartTimeOfCase2,ResponstimeOfCase2,figureIndex,3,2,500);
%                     DelayDensity_ResponseTimeAnalysePlot( StartTimeOfCase,ResponstimeOfCase,figureIndex,3,3,500);
%                     DelayDensity_ResponseTimeAnalyseAllPlot( StartTimeOfCase1,ResponstimeOfCase1,StartTimeOfCase2,ResponstimeOfCase2,StartTimeOfCase,ResponstimeOfCase,allIndex,300);
                    allIndex=allIndex+1;
                    figureIndex=figureIndex+1;
%                     pause
                    
                else
                    plot(1:NumOfTask,TestCase_DelayDensity_FPModel,'b--');
                end
                
            end
        end
    end
    fprintf('procent: %3.2f\n',i/ph1max);
 end

# case4 rtc toolbox
clear
clc
p1=10;e1=1;
p2=15;e2=5;
p3=10;e3=3;
a1 = rtcpjd(p1, 0, 0);
a2 = rtcpjd(p2, 0, 0);
a3 = rtcpjd(p3, 0, 0);
b1 = rtcfs(1);
[a_1,b_1,de1,buf1]=rtcgpc(a1,b1,e1);
[a_2,b_2,de2,buf2]=rtcgpc(a2,b_1,e2);
[a_3,b_3,de3,buf3]=rtcgpc(a3,b_2,e3);
figure(2);
hold on
rtcplot(a_2, 'g--',100);
figure(6);
hold on
rtcplot(a1, 'g--',100);

figure(3);
hold on
rtcplot(b_3, 'g--',100);
sigma=rtcminus(b_2,b_3);
figure(1);
rtcplot(sigma, 'g--',100);

# case5 tdma model event based
clc;
clear;
p1=3;j1=5;e1=3;d1=1;
TDMA_Cycle=7;
TDMA_Slot=2;
p1=150;j1=450;e1=20;d1=15;
TDMA_Cycle=10;
TDMA_Slot=6;
NumOfTask=10;
CPU_Bandwidth=4;
simulationtime=2000;
[ A_U,A_L,B_U,B_L,AU,AL,BU,BL ] = DelayDensity_TDMAModelInit( p1,j1,d1,e1,CPU_Bandwidth,TDMA_Cycle,TDMA_Slot,simulationtime);
[StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( AU,BL,B_L,e1,NumOfTask+1,simulationtime)
[ DelayDensity ] = DelayDensity_GenerateDelayDensity( ResponstimeOfTask )

%validation by rtc toolbox
a11 = rtcpjd(p1, j1*2, d1);
figure(1)
hold on
plot(0:simulationtime,AU/e1,'r');
plot(0:simulationtime,AL/e1,'r');
rtcplot(a11, 'g--',simulationtime);
figure(2)
hold on
b21=rtctdma(TDMA_Slot,TDMA_Cycle,CPU_Bandwidth);
plot(0:simulationtime,BU,'r');
plot(0:simulationtime,BL,'r');
rtcplot(b21, 'g--',simulationtime);
[a_1,b_1,de1,buf1]=rtcgpc(a11,b21,e1);
figure(3);
hold on
plot(0:simulationtime,B_U,'r');
plot(0:simulationtime,B_L,'r');
rtcplot(b_1, 'g--',simulationtime);
figure(4);
hold on
plot(0:simulationtime,A_U/e1,'r');
plot(0:simulationtime,A_L/e1,'r');
rtcplot(b_1, 'g--',simulationtime);

# case6 tdma conrete simulation
clc
clear
p1=150;j1=450;e1=20;d1=15;
CPU_Bandwidth=1;
TDMA_Cycle=10;
TDMA_Slot=6;
TDMA_Phase=4;
NumOfTask=6;
simulationtime=1000;
AConcrete=zeros(1,simulationtime+1);
AConcrete(1:16)=1*e1;
AConcrete(17:31)=2*e1;
AConcrete(32:46)=3*e1;
AConcrete(47:601)=4*e1;
AConcrete(602:616)=5*e1;
AConcrete(617:631)=6*e1;
AConcrete(631:646)=7*e1;
AConcrete(647:1001)=7*e1;
[ A_Concrete,B_Concrte,Bconcrete ]=DelayDensity_TDMAConcreteModel( AConcrete,e1,CPU_Bandwidth,TDMA_Cycle,TDMA_Slot,TDMA_Phase,simulationtime);
[StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( AConcrete,Bconcrete,B_Concrte,e1,NumOfTask+1,simulationtime)

# case7 tdma random concrete simulation
clc
clear
p1=8;j1=0;e1=3;d1=5;
CPU_Bandwidth=1;
TDMA_Cycle=10;
TDMA_Slot=6;
% TDMA_Phase=floor(TDMA_Cycle*rand(1));
NumOfTask=30;
simulationtime=400;
AConcrete=DelayDensity_TDMAModel_AConcrete_Generator(p1,j1,d1,e1,NumOfTask,simulationtime);
[ A_U,A_L,B_U,B_L,AU,AL,BU,BL ] = DelayDensity_TDMAModelInit( p1,j1,d1,e1,CPU_Bandwidth,TDMA_Cycle,TDMA_Slot,simulationtime);
[WorstStartTimeOfTask,WorstResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( AU,BL,B_L,e1,NumOfTask+1,simulationtime)
[ MaxDelayDensity ] = DelayDensity_GenerateDelayDensity( WorstResponstimeOfTask )

for i=1:1
    AConcrete=DelayDensity_TDMAModel_AConcrete_Generator(p1,j1,d1,e1,NumOfTask,simulationtime);
    for TDMA_Phase=1:(TDMA_Cycle-TDMA_Slot)
        [ A_Concrete,B_Concrte,Bconcrete ]=DelayDensity_TDMAConcreteModel( AConcrete,CPU_Bandwidth,TDMA_Cycle,TDMA_Slot,TDMA_Phase,simulationtime);
        [StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( AConcrete,Bconcrete,B_Concrte,e1,NumOfTask,simulationtime);
        [ TestCaseDelayDensity ] = DelayDensity_GenerateDelayDensity( ResponstimeOfTask );
        for(i=2:NumOfTask-1)
            if TestCaseDelayDensity(i)>=MaxDelayDensity(i)
                TDMA_Phase
                ResponstimeOfTask
                TestCaseDelayDensity
            break;
            end
        end
    end
end
