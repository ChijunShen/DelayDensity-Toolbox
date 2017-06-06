clc
clear
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



Kp=3;
Ki=3;
Kd=1;
% p1=73;j1=13;d1=10;e1=17;ph1max=0;
% p2=51;j2=93;d2=10;e2=2;ph2max=0;
% p3=400;j3=200;d3=10;e3=50;ph3max=0;
p1=50;j1=30;d1=10;e1=20;ph1max=0;
p2=100;j2=50;d2=10;e2=25;ph2max=0;
p3=200;j3=200;d3=10;e3=30;ph3max=0;
TDMA_Bandwidth=1;%Ressource Einhei/ms
CPU_Bandwidth=1;
simulationtime=25000;%Einheit:ms
NumOfTask=120;
sollwert=10;
NumOfSimulation=100;
MasterArbeit_EreignisgeneratorsNachTotzone

%theorie dbdd
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,simulationtime);

[WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,simulationtime)
for i=1:RepeatInstantNum %RepeatInstantNum herstellen
    for j=1:length(WorstResponstimeOfTask)
        index=mod(j,i);
        if index==0
            index=i;
         end
    Array(i,j)=WorstResponstimeOfTask(index);
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

Instanz=ones(1,NumOfTask)*max(WorstResponstimeOfTask)/1000; %Responsetime unit:s
time1=WorstStartTimeOfTask(1:NumOfTask)/1000; %Task Start Time  unit:s

MasterArbeit_EreignisgeneratorsNachTotzone
set_param('MasterArbeit_EreignisgeneratorsNachTotzone','StartTime','0','StopTime','25');
set_param('MasterArbeit_EreignisgeneratorsNachTotzone','Solver','ode45')
set_param('MasterArbeit_EreignisgeneratorsNachTotzone','stopfcn','Evaluation')
sim('MasterArbeit_EreignisgeneratorsNachTotzone')

figure(1)
hold on
Drehzahl_DBDD=Drehzahl;
plot(Drehzahl.time,Drehzahl.signals.values,'k');   

JabsSchatz_DBDD=max(Jabs.signals.values) 
JitaeSchatz_DBDD=max(Jitae.signals.values) 
JsqrSchatz_DBDD=max(Jsqr.signals.values)
OvershootSchatz_DBDD=overshoot
adjustTimeSchatz_DBDD=adjust_time


%theorie neue kurve
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,simulationtime);

[WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,simulationtime)
for i=1:RepeatInstantNum %RepeatInstantNum herstellen
    for j=1:length(WorstResponstimeOfTask)
        index=mod(j,i);
        if index==0
            index=i;
         end
    Array(i,j)=WorstResponstimeOfTask(index);
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

Instanz=Instanz_Neu(1:NumOfTask)/1000; %Responsetime unit:s
time1=WorstStartTimeOfTask(1:NumOfTask)/1000; %Task Start Time  unit:s

MasterArbeit_EreignisgeneratorsNachTotzone
set_param('MasterArbeit_EreignisgeneratorsNachTotzone','StartTime','0','StopTime','25');
set_param('MasterArbeit_EreignisgeneratorsNachTotzone','Solver','ode45')
set_param('MasterArbeit_EreignisgeneratorsNachTotzone','stopfcn','Evaluation')
sim('MasterArbeit_EreignisgeneratorsNachTotzone')

figure(1)
hold on
Drehzahl_NeuKurve=Drehzahl;
plot(Drehzahl.time,Drehzahl.signals.values,'r');   

JabsSchatz=max(Jabs.signals.values) 
JitaeSchatz=max(Jitae.signals.values) 
JsqrSchatz=max(Jsqr.signals.values)
OvershootSchatz=overshoot
adjustTimeSchatz=adjust_time


%simulation
ph1=0;
ph2=0;
ph3=0;
for i=1:NumOfSimulation
    A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,simulationtime);
    [A1_C,B1_C,B1C]=DelayDensity_FPConcreteModelInit( A1C,CPU_Bandwidth,simulationtime);
    A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,simulationtime);
     [A2_C,B2_C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,simulationtime);
    A3C=DelayDensity_AConcrete_Generator(p3,j3,d3,ph3,e3,simulationtime);
    [A3_C,B3_C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);

    [StartTimeOfCase3,ResponstimeOfCase3]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,simulationtime);
    Instanz=ResponstimeOfCase3(1:NumOfTask)/1000;
    time1=StartTimeOfCase3(1:NumOfTask)/1000;
    set_param('MasterArbeit_EreignisgeneratorsNachTotzone','StartTime','0','StopTime','25');
    set_param('MasterArbeit_EreignisgeneratorsNachTotzone','Solver','ode45')
    set_param('MasterArbeit_EreignisgeneratorsNachTotzone','stopfcn','Evaluation')
    sim('MasterArbeit_EreignisgeneratorsNachTotzone')
    JabsSim(i)=max(Jabs.signals.values)
    JitaeSim(i)=max(Jitae.signals.values) 
    JsqrSim(i)=max(Jsqr.signals.values)
    OvershootSim(i)=overshoot
    adjustTimeSim(i)=adjust_time
    figure(1)
    hold on
    Drehzahl_Sim(i)=Drehzahl;
    plot(Drehzahl.time,Drehzahl.signals.values,'g');    
end

%theorie
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,simulationtime);

[WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,simulationtime)
for i=1:RepeatInstantNum %RepeatInstantNum herstellen
    for j=1:length(WorstResponstimeOfTask)
        index=mod(j,i);
        if index==0
            index=i;
         end
    Array(i,j)=WorstResponstimeOfTask(index);
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

Instanz=Instanz_Neu(1:NumOfTask)/1000; %Responsetime unit:s
time1=WorstStartTimeOfTask(1:NumOfTask)/1000; %Task Start Time  unit:s

MasterArbeit_EreignisgeneratorsNachTotzone
set_param('MasterArbeit_EreignisgeneratorsNachTotzone','StartTime','0','StopTime','25');
set_param('MasterArbeit_EreignisgeneratorsNachTotzone','Solver','ode45')
set_param('MasterArbeit_EreignisgeneratorsNachTotzone','stopfcn','Evaluation')
sim('MasterArbeit_EreignisgeneratorsNachTotzone')

figure(1)
hold on
plot(Drehzahl.time,Drehzahl.signals.values,'r');   

JabsSchatz=max(Jabs.signals.values) 
JitaeSchatz=max(Jitae.signals.values) 
JsqrSchatz=max(Jsqr.signals.values)
OvershootSchatz=overshoot
adjustTimeSchatz=adjust_time







