clear
clc
warning off

%Gleichstrommotor System Parameter
L_A=0.5;           %Ankerinduktivitat Unit:H  
R_A=1.0;           %Ankerwiderstand Unit:Ohm
K_M=0.01;          %Motorkonstant Unit:Nm/A
K_B=0.01;          %back emf constant
K_F=0.1;           %Reibungskonstante Unit:Nms
J_M=0.01;          %Ankertragheitsmoment Unit:kgm2
M_L=0;             %Lastdrehenmoment Unit:Nm


%Ereignisgenerator mit Interrupt Einstellung
EncoderDegree=180;
Ereignisgenerator_Sampletime=0.001;%s

%Gleichstrommotor Modell Vereinfachung
A=L_A*J_M/K_M;
B=(K_F*L_A+R_A*J_M)/K_M;
C=R_A*K_F/K_M+K_B;
S1=L_A/K_M;
S2=R_A/K_M;

%Gleichstrommotor System Matrix
System_A=[0 1 0;0 0 1;0 -C/A -B/A];
System_B=[0;0;1/A];
System_C=[1 0 0];
System_S1=[0;0;S1/A];
System_S2=[0;0;S2/A];

%LQ-Regelungen
Q=[1 0 0;0 4000 0;0 0 0];
R=100;
[K,s,e] = lqr(System_A,System_B,Q,R,0);
V=-1/(System_C*inv(System_A-System_B*K)*System_B);%Vorfilter
Idea=[100000;100];
Ereignis_Abtastzeit=200;%not used ,just to let the Simulink Module work
Umax=150;
Totzone_Wert=0.01;
rho_Wert=0.00001;
%
Kp=7;
Ki=8;
Kd=0.5;
%Kp=6;
%Ki=3;
%Kd=0.5;
NumOfInstanz=20;
sollwert=10;%rad/s
simulationtime=15000;%ms
CPU_Bandwidth=1;

%p1=50;j1=80;d1=20;e1=5;ph1=0;
%p2=100;j2=150;d2=20;e2=20;ph2=0;
%e3=25;
TestNum=1;
for NumOfSimulation=1:500
p1=ceil(50*rand(1)+0.5);
j1=0;
d1=20;
e1=ceil(5*rand(1)+0.5);
ph1=0;
p2=ceil(100*rand(1)+0.5);
j2=0;
d2=20;
e2=ceil(25*rand(1)+0.5);
ph2=0;
if((e1/p1+e2/p2)>0.6) 
    continue;
end
e3=25;%ceil(15*rand(1)+0.5);
ph3max=0;




A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,simulationtime);
A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,simulationtime);
[A1_C,B1_C,B1C]=DelayDensity_FPConcreteModelInit( A1C,CPU_Bandwidth,simulationtime);
%beste schatzung
TriggerTime=(1:1:NumOfInstanz)*3.14/sollwert*1000;
NumOfTask=NumOfInstanz;

j=1;
value=e3;
for i=1:simulationtime+1
    if(j<NumOfInstanz)
        if(i>TriggerTime(j)+2)
            value=value+e3;
            j=j+1;
        end
    end
    A3C(i)=value;
end

[ A2_C,B2_C] = DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,simulationtime);
[ A3_C,B3_C] = DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);

[StartTimeOfTask,ResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,simulationtime);

%kurve nach victor
for i=1:RepeatInstantNum %RepeatInstantNum herstellen
    for j=1:length(ResponstimeOfTask)
        index=mod(j,i);
        if index==0
            index=i;
        end
        Array(i,j)=ResponstimeOfTask(index);
    end
    DelayDensity_NewKurve(i,:)=DelayDensity_GenerateDelayDensity(Array(i,:),NumOfTask);%Falsh geschrieben:Array
end
DelayDensity_NewKurve_Oberschranken=DelayDensity_NewKurve(1,:);
for i=2:RepeatInstantNum
    DelayDensity_NewKurve_Oberschranken=DelayDensity_MaxArray(DelayDensity_NewKurve_Oberschranken,DelayDensity_NewKurve(i,:));
end

Instanz_Neu(1)=DelayDensity_NewKurve_Oberschranken(1);
for i=2:NumOfTask
    Instanz_Neu(i)=DelayDensity_NewKurve_Oberschranken(i)-DelayDensity_NewKurve_Oberschranken(i-1);
end
Latenz=DelayDensity_NewKurve_Oberschranken;
Instanz=Instanz_Neu(1:NumOfTask)/1000;
time1=StartTimeOfTask/1000;


%time1=StartTimeOfTask/1000;
 %Instanz=ResponstimeOfTask/1000;
% plot(0:simulationtime,A3C(1:simulationtime+1));
% plot(0:500,A3C(1:500+1));
%figure(NumOfSimulation)
%hold on
MasterArbeit_Ereignisgenerators
set_param('MasterArbeit_Ereignisgenerators','StartTime','0','StopTime','30');
%set_param('MasterArbeit_Ereignisgenerators','stopfcn','DelayDensity_NoOperation')
set_param('MasterArbeit_Ereignisgenerators','Solver','ode45')
set_param('MasterArbeit_Ereignisgenerators','stopfcn','Evaluation')
sim('MasterArbeit_Ereignisgenerators')
plot(Drehzahl.time,Drehzahl.signals.values,'r')
%pause

Test_LangstAdjustTime=adjust_time;
Test_LangstOvershoot=overshoot;

Overshoot_Schatz(TestNum)=overshoot;

fprintf('Overshoot Schatzung:%f',overshoot);

%schatzung 



%iteration

InstanzNumber=1;
for i=1:simulationtime+1
    A3C(i)=e3;
end

[ A2_C,B2_C] = DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,simulationtime);
[ A3_C,B3_C] = DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);

[StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,simulationtime);
InstanzNumber=2;
NumOfTask=1;
Instanz=zeros(1,NumOfInstanz);
%MasterArbeit_Ereignisgenerators
set_param('MasterArbeit_Ereignisgenerators','StartTime','0','StopTime','30');
set_param('MasterArbeit_Ereignisgenerators','stopfcn','DelayDensity_NoOperation')
set_param('MasterArbeit_Ereignisgenerators','Solver','ode45')
while InstanzNumber<=NumOfInstanz
    time1(NumOfTask)=StartTimeOfTask(NumOfTask)/1000;
    Instanz(NumOfTask)=ResponstimeOfTask(NumOfTask)/1000;
    sim('MasterArbeit_Ereignisgenerators')

    %upgrade Winkel
    for i=1:length(Degree)
        if Degree(i,2)>175*NumOfTask&&Degree(i,2)<181*NumOfTask
            TriggerTime(NumOfTask)=Degree(i)*1000;%ms
            break;
        end
    end
%     TriggerTime
    j=1;
    value=e3;
    for i=1:simulationtime+1
        if(j<InstanzNumber)
            if(i>TriggerTime(j)+2)
                value=value+e3;
                j=j+1;
            end
        end
        A3C(i)=value;
    end
%     figure(17)
%      plot(0:simulationtime,A3C(1:simulationtime+1));
     [ A3_C,B3_C] = DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);

    %upgrade Spannung
    [StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,simulationtime);
    InstanzNumber=InstanzNumber+1;
    NumOfTask=NumOfTask+1;
end

figure(17)
plot(0:simulationtime,A3C(1:simulationtime+1));
%pause

time1=StartTimeOfTask(1:NumOfInstanz)/1000;
Instanz=ResponstimeOfTask(1:NumOfInstanz)/1000;
figure(NumOfSimulation)
hold on
set_param('MasterArbeit_Ereignisgenerators','StartTime','0','StopTime','30');
set_param('MasterArbeit_Ereignisgenerators','Solver','ode45')
set_param('MasterArbeit_Ereignisgenerators','stopfcn','Evaluation')
sim('MasterArbeit_Ereignisgenerators')
plot(Drehzahl.time,Drehzahl.signals.values,'g')
%pause

Test_LangstAdjustTime=adjust_time;
Test_LangstOvershoot=overshoot;

Overshoot_Konkrete(TestNum)=overshoot;
AdjustTime_Konkrete(TestNum)=adjust_time;
Antwortzeit_Konkrete(TestNum)=ResponstimeOfTask(1);

fprintf(' Overshoot Konkrete:%f AdjustTime Konkrete:%d Antwortzeit:%d ',Test_LangstOvershoot,Test_LangstAdjustTime,ResponstimeOfTask(1));

%worst schatzung
TriggerTime=(1:1:NumOfInstanz)*TriggerTime(1);
NumOfTask=NumOfInstanz;

simulationtime=35000;
A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,simulationtime);
A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,simulationtime);
[A1_C,B1_C,B1C]=DelayDensity_FPConcreteModelInit( A1C,CPU_Bandwidth,simulationtime);



j=1;
value=e3;
for i=1:simulationtime+1
    if(j<NumOfInstanz)
        if(i>TriggerTime(j)+2)
            value=value+e3;
            j=j+1;
        end
    end
    A3C(i)=value;
end

[ A2_C,B2_C] = DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,simulationtime);
[ A3_C,B3_C] = DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);

[StartTimeOfTask,ResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,simulationtime);

%kurve nach victor
for i=1:RepeatInstantNum %RepeatInstantNum herstellen
    for j=1:length(ResponstimeOfTask)
        index=mod(j,i);
        if index==0
            index=i;
        end
        Array(i,j)=ResponstimeOfTask(index);
    end
    DelayDensity_NewKurve(i,:)=DelayDensity_GenerateDelayDensity(Array(i,:),NumOfTask);%Falsh geschrieben:Array
end
DelayDensity_NewKurve_Oberschranken=DelayDensity_NewKurve(1,:);
for i=2:RepeatInstantNum
    DelayDensity_NewKurve_Oberschranken=DelayDensity_MaxArray(DelayDensity_NewKurve_Oberschranken,DelayDensity_NewKurve(i,:));
end

Instanz_Neu(1)=DelayDensity_NewKurve_Oberschranken(1);
for i=2:NumOfTask
    Instanz_Neu(i)=DelayDensity_NewKurve_Oberschranken(i)-DelayDensity_NewKurve_Oberschranken(i-1);
end
Latenz=DelayDensity_NewKurve_Oberschranken;
Instanz=Instanz_Neu(1:NumOfTask)/1000;
time1=StartTimeOfTask/1000;
 
 %time1=StartTimeOfTask/1000
 %Instanz=ResponstimeOfTask/1000
% plot(0:simulationtime,A3C(1:simulationtime+1));
% plot(0:500,A3C(1:500+1));
%MasterArbeit_Ereignisgenerators
set_param('MasterArbeit_Ereignisgenerators','StartTime','0','StopTime','30');
set_param('MasterArbeit_Ereignisgenerators','stopfcn','DelayDensity_NoOperation')
set_param('MasterArbeit_Ereignisgenerators','Solver','ode45')
set_param('MasterArbeit_Ereignisgenerators','stopfcn','Evaluation')
figure(NumOfSimulation)
hold on
sim('MasterArbeit_Ereignisgenerators')
plot(Drehzahl.time,Drehzahl.signals.values,'k')
%pause

Test_LangstAdjustTime=adjust_time;
Test_LangstOvershoot=overshoot;

AdjustTime_Schatz(TestNum)=adjust_time;
fprintf('AdjustTime Schatzung:%d \n',Test_LangstAdjustTime);

TestNum=TestNum+1;
end

%schatzung










