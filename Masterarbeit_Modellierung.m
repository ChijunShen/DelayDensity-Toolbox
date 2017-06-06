%Matlab Modellierung eines permannentmagneterregten Gleichstrommotors
%Frank Shen, Uni Ulm
%2017

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

%Kapital 3 Gesamt Modellierung
Kp=2;
Ki=1.8;
Kd=0.1;
Umax=150;
Totzone_Wert=0.01;
rho_Wert=0.00001;
CPU_Bandwidth=1;%resource unit/ms
SimulationTime=50;%s
NumOfTask=500;
time1=(0:0.5:(NumOfTask-1)*0.5); %period s
Instanz=ones(1,NumOfTask)*0.1;   %ausfuhrungszeit s
sollwert=10;%rad/s



% %nach intterupt upper bound
% %taskset
% Kp=3;
% Ki=3;
% Kd=1;
% p1=50;j1=30;d1=10;e1=20;ph1max=0;
% p2=100;j2=50;d2=10;e2=25;ph2max=0;
% d3=10;e3=30;ph3max=0;
% simulationtime=15000;%15s
% 
% MasterArbeit_Gleichstrommotor;
% set_param('MasterArbeit_Gleichstrommotor','StartTime','0','StopTime','15');
% set_param('MasterArbeit_Gleichstrommotor','stopfcn','DelayDensity_NoOperation')
% sim('MasterArbeit_Gleichstrommotor')
% NumOfTask=65;
% NumOfInstanz=NumOfTask;
% for j=1:NumOfTask
%     for i=1:length(Degree)
%         if Degree(i,2)>175*j&&Degree(i,2)<181*j
%             TriggerTime(j)=Degree(i,1)*1000;%ms
%         end
%     end
% end
% TriggerTime;
% 
% %Ankunfskurve
% j=1;
% value=e3;
% for i=1:simulationtime+1
%     if(i>TriggerTime(j)+2&&j<NumOfInstanz)
%         value=value+e3;
%         j=j+1;
%     end
%     A3C(i)=value;
% end
% figure(17)
%  plot(0:simulationtime,A3C(1:simulationtime+1));
%  
% [ A1_U,A1_L,B1_U,B1_L,A1U,A1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
% [ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);
% [ A3_U,A3_L,B3_U,B3_L ] = DelayDensity_GPCModel( A3C,A3C,B2_U,B2_L );
% 
% %NumOfTask=65;
% %NumOfInstanz=NumOfTask;
% [WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3C,B2_L,B3_L,e3,simulationtime)
% MasterArbeit_Ereignisgenerators
% set_param('MasterArbeit_Ereignisgenerators','StartTime','0','StopTime','15');
% set_param('MasterArbeit_Ereignisgenerators','stopfcn','DelayDensity_NoOperation')
% set_param('MasterArbeit_Ereignisgenerators','Solver','ode45')
% time1=WorstStartTimeOfTask/1000;
% Instanz=WorstResponstimeOfTask/1000;
% NumOfInstanz=length(Instanz);
% sim('MasterArbeit_Ereignisgenerators')
% 
% figure(18)
% hold on
% plot(Drehzahl.time,Drehzahl.signals.values,'b'); 
%  load FInalTestTask1InterruptOhneLastEinschwingung;
%  NumOfSimulation=length(Drehzahl_Sim);
%     plot(Drehzahl_DBDD.time,Drehzahl_DBDD.signals.values,'k'); 
%     plot(Drehzahl_NeuKurve.time,Drehzahl_NeuKurve.signals.values,'r'); 
%     for i=1:NumOfSimulation
%         plot(Drehzahl_Sim(i).time,Drehzahl_Sim(i).signals.values,'g'); 
%     end
%     plot(Drehzahl_DBDD.time,Drehzahl_DBDD.signals.values,'k'); 
%     plot(Drehzahl_NeuKurve.time,Drehzahl_NeuKurve.signals.values,'r'); 
%     xlabel('Zeit(s)');
%     ylabel('Drehzahl(rad/s)')
% pause
% %nach intterupt upper bound


%nach Periode
% MasterArbeit_EreignisgeneratorsOhneTotzone;
% set_param('MasterArbeit_EreignisgeneratorsOhneTotzone','StartTime','0','StopTime','SimulationTime');
% sim('MasterArbeit_EreignisgeneratorsOhneTotzone')
% EreignisgeneratorsNachPeriode=Drehzahl;

% %nach Totzone
% MasterArbeit_EreignisgeneratorsNachTotzone;
% set_param('MasterArbeit_EreignisgeneratorsNachTotzone','StartTime','0','StopTime','SimulationTime');
% sim('MasterArbeit_EreignisgeneratorsNachTotzone')
% EreignisgeneratorsNachTotzone=Drehzahl;
% %nach ISS
% MasterArbeit_EreignisgeneratorsNachISS;
% set_param('MasterArbeit_EreignisgeneratorsNachISS','StartTime','0','StopTime','SimulationTime');
% sim('MasterArbeit_EreignisgeneratorsNachISS')
% EreignisgeneratorsNachISS=Drehzahl;
% %nach Interrupt
% MasterArbeit_EreignisgeneratorsNachInterrupt;
% set_param('MasterArbeit_EreignisgeneratorsNachInterrupt','StartTime','0','StopTime','SimulationTime');
% sim('MasterArbeit_EreignisgeneratorsNachInterrupt')
% EreignisgeneratorsNachInterrupt=Drehzahl;
% %plot 4 Kurven
% figure(1)
% hold on
% plot(EreignisgeneratorsNachPeriode.time,EreignisgeneratorsNachPeriode.signals.values,'g')
% plot(EreignisgeneratorsNachTotzone.time,EreignisgeneratorsNachTotzone.signals.values,'g')
% plot(EreignisgeneratorsNachISS.time,EreignisgeneratorsNachISS.signals.values,'r')
% plot(EreignisgeneratorsNachInterrupt.time,EreignisgeneratorsNachInterrupt.signals.values,'b')
% xlabel('Zeit(s)')
% ylabel('Drehzahl(rad/s)')
% legend('Nach Heemels','Nach Tabuada','Nach Interrupt')

%vergleichen Anzahl der Erreignisse mit Schwellwert
%nach Periode
% NumOfTask=100;
% MasterArbeit_EreignisgeneratorsOhneTotzone;
% j=1;
% %Die Beziehungen zwischen der Anzahl der Ereignisse, der Wert von $J_{abs}$ und Schwellwert e
% for i=100:50:500
% time1=0:i/1000:50; %period s
% time1=time1(1:NumOfTask);
% Instanz=ones(1,NumOfTask)*0.1;   %ausfuhrungszeit s
% set_param('MasterArbeit_EreignisgeneratorsOhneTotzone','StartTime','0','StopTime','SimulationTime');
% set_param('MasterArbeit_EreignisgeneratorsOhneTotzone','stopfcn','Evaluation')
% sim('MasterArbeit_EreignisgeneratorsOhneTotzone')
% Anzahl_EreignisgeneratorsNachPeriode(j)=floor(50*1000/i)
% Jabs_EreignisgeneratorsNachPeriode(j)=max(Jabs.signals.values)
% j=j+1;
% end
% figure(2)
% hold on
% subplot(121)
% plot(100:50:500,Anzahl_EreignisgeneratorsNachPeriode(1:9));
% xlabel('Periode(ms)')
% ylabel('Anzahl der Ereignisse')
% subplot(122)
% plot(100:50:500,Jabs_EreignisgeneratorsNachPeriode(1:9));
% xlabel('Periode(ms)')
% ylabel('Jabs')

%vergleichen Anzahl der Erreignisse mit Schwellwert
% %nach Totzone
% MasterArbeit_EreignisgeneratorsNachTotzone;
% j=1;
% %Die Beziehungen zwischen der Anzahl der Ereignisse, der Wert von $J_{abs}$ und Schwellwert e
% for i=0.01:0.01:0.09
% Totzone_Wert=i;
% set_param('MasterArbeit_EreignisgeneratorsNachTotzone','StartTime','0','StopTime','SimulationTime');
% set_param('MasterArbeit_EreignisgeneratorsNachTotzone','stopfcn','Evaluation')
% sim('MasterArbeit_EreignisgeneratorsNachTotzone')
% Anzahl_EreignisgeneratorsNachTotzone(j)=max(Anzahl(:,2));
% Jabs_EreignisgeneratorsNachTotzone(j)=max(Jabs.signals.values);
% j=j+1;
% end
% figure(2)
% hold on
% subplot(121)
% plot(0.01:0.01:0.09,Anzahl_EreignisgeneratorsNachTotzone(1:9));
% xlabel('Schwellwert: e')
% ylabel('Anzahl der Ereignisse')
% subplot(122)
% plot(0.01:0.01:0.09,Jabs_EreignisgeneratorsNachTotzone(1:9));
% xlabel('Schwellwert: e')
% ylabel('Jabs')

%nach ISS
% MasterArbeit_EreignisgeneratorsNachISS;
% j=1;
% Kp=8;
% Ki=8;
% Kd=4;
% sollwert=10;
% %Die Beziehungen zwischen der Anzahl der Ereignisse, der Wert von $J_{abs}$ und Schwellwert e
% for i=0.0001:0.0001:0.0006
% rho_Wert=i
% set_param('MasterArbeit_EreignisgeneratorsNachISS','StartTime','0','StopTime','SimulationTime');
% set_param('MasterArbeit_EreignisgeneratorsNachISS','stopfcn','Evaluation')
% sim('MasterArbeit_EreignisgeneratorsNachISS')
% Anzahl_EreignisgeneratorsNachISS(j)=max(Anzahl(:,2));
% Jabs_EreignisgeneratorsNachISS(j)=max(Jabs.signals.values);
% j=j+1;
% end
% figure(2)
% hold on
% subplot(121)
% plot(0.0001:0.0001:0.0006,Anzahl_EreignisgeneratorsNachISS(1:6));
% xlabel('Schwellwert: e')
% ylabel('Anzahl der Ereignisse')
% subplot(122)
% plot(0.0001:0.0001:0.0006,Jabs_EreignisgeneratorsNachISS(1:6));
% xlabel('Schwellwert: e')
% ylabel('Jabs')

% %nach Interrupt
% MasterArbeit_EreignisgeneratorsNachInterrupt;
% j=1;
% Kp=2;
% Ki=1.8;
% Kd=0.1;
% sollwert=10;
% %Die Beziehungen zwischen der Anzahl der Ereignisse, der Wert von $J_{abs}$ und Schwellwert e
% for i=1:0.5:5
% Kp=i
% set_param('MasterArbeit_EreignisgeneratorsNachInterrupt','StartTime','0','StopTime','SimulationTime');
% set_param('MasterArbeit_EreignisgeneratorsNachInterrupt','stopfcn','Evaluation')
% sim('MasterArbeit_EreignisgeneratorsNachInterrupt')
% Anzahl_EreignisgeneratorsNachInterrupt(j)=max(Anzahl(:,2));
% Jabs_EreignisgeneratorsNachInterrupt(j)=max(Jabs.signals.values);
% j=j+1;
% end
% figure(2)
% hold on
% subplot(121)
% plot(1:0.5:5,Anzahl_EreignisgeneratorsNachInterrupt(1:9));
% xlabel('Kp')
% ylabel('Anzahl der Ereignisse')
% subplot(122)
% plot(1:0.5:5,Jabs_EreignisgeneratorsNachInterrupt(1:9));
% xlabel('Kp')
% ylabel('Jabs')

%Simulation und Validierung obere Schranke nach Tatiana
% %case study 1
% NumOfInstanz=30;%Anzahl der Instanzen ber¨¹cksichtigt
% Ereignis_Periode=30;%Anzahl der Instanzen ber¨¹cksichtigen
% Ereignis_Jitter=50;%Einheit:ms
% Ereignis_Delta=5;%Einheit:ms
% Ereignis_WCET=10;%Ressource Einheit
% TDMA_Slot=6;%ms
% TDMA_Cycle=10;%ms
% TDMA_Bandwidth=1;%Ressource Einhei/ms
% SimulationTime=(NumOfTask+10)*Ereignis_WCET;%Einheit:ms
% 
% %Initialisierung des TDMA Models 
% %A_U: ausgehende obere Ankunftskurve A_L: ausgehende untere Ankunftskurve
% %B_U: ausgehende obere Servicekurve  B_L: ausgehende untere Servicekurve
% %AU:  eingehende obere Ankunftskurve AL:  eingehende untere Ankunftskurve
% %BU:  eingehende obere Servicekurve  BL:  eingehende untere Servicekurve
% [ A_U,A_L,B_U,B_L,AU,AL,BU,BL ] = DelayDensity_TDMAModelInit( Ereignis_Periode,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,TDMA_Bandwidth,TDMA_Cycle,TDMA_Slot,SimulationTime);
% %berechnen Antwortzeit und Startszeit von jedes Instanz
% [WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( AU,BL,B_L,Ereignis_WCET,SimulationTime)
% %berechnen $dR^+(\Delta)$
% SchrankeNachTatiana = DelayDensity_GenerateDelayDensity( WorstResponstimeOfTask,NumOfInstanz);
% Schranke_DBDD(1:NumOfInstanz)=(1:NumOfInstanz)*SchrankeNachTatiana(1);
% figure(1)
% hold on
% plot(1:NumOfInstanz,Schranke_DBDD,'k')
% plot(1:NumOfInstanz,SchrankeNachTatiana,'r')
% xlabel('Intervall')
% ylabel('Zeit(ms)')
% 
% %kurve nach victor
% for i=1:RepeatInstantNum %RepeatInstantNum herstellen
%     for j=1:length(WorstResponstimeOfTask)
%         index=mod(j,i);
%         if index==0
%             index=i;
%         end
%         Array(i,j)=WorstResponstimeOfTask(index);
%     end
%     DelayDensity_NewKurve(i,:)=DelayDensity_GenerateDelayDensity(Array(i,:),NumOfInstanz);%Falsh geschrieben:Array
% end
% DelayDensity_NewKurve_Oberschranken=DelayDensity_NewKurve(1,:);
% for i=2:RepeatInstantNum
%     DelayDensity_NewKurve_Oberschranken=DelayDensity_MaxArray(DelayDensity_NewKurve_Oberschranken,DelayDensity_NewKurve(i,:));
% end
% Schranke_Victor=DelayDensity_NewKurve_Oberschranken;
% plot(1:NumOfInstanz,Schranke_Victor,'b')
% legend('Kurve nach DBDD','Kurve nach Tatiana','Neue Kurve')
% 
% %Simulation und Validierung Kurve nach Tatiana
% NumOfTest=20;%Anzahl der Simulierung
% Ereignis_Phase=0;%Wie viel Zeiteinheiten Ankunftskurve verzoegert ist
% TDMA_Phase=0;%Wie viel Zeiteinheiten Servicekurve verzoegert ist
% for i=1:NumOfTest
%   %Initialisierung eine konkrete random Ankunftskurve
%   AConcrete=DelayDensity_AConcrete_Generator(Ereignis_Periode,Ereignis_Jitter,Ereignis_Delta,Ereignis_Phase,Ereignis_WCET,SimulationTime);
%   %Initialisierung eine konkrete random Servicekurve
%   [ A_Concrete,B_Concrte,Bconcrete ]=DelayDensity_TDMAConcreteModel( AConcrete,TDMA_Bandwidth,TDMA_Cycle,TDMA_Slot,TDMA_Phase,SimulationTime);
%   %berechnen Antwortzeit und Startszeit von jedes Instanz
%   [StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( AConcrete,Bconcrete,B_Concrte,Ereignis_WCET,SimulationTime);
%   %berechnen $dR^+(\Delta)$
%   KurveSimulation = DelayDensity_GenerateDelayDensity( ResponstimeOfTask,NumOfInstanz);
%   figure(1)
%   hold on
%   %Kurve zeichnen
%   plot(1:NumOfInstanz,KurveSimulation,'g')
% end


%case study 2
NumOfInstanz=30;%Anzahl der Instanzen ber¨¹cksichtigt
p1=50;j1=250;d1=20;e1=5;ph1max=0;
p2=100;j2=100;d2=20;e2=20;ph2max=0;
p3=250;j3=80;d3=5;e3=15;ph3max=0;
TDMA_Bandwidth=1;%Ressource Einhei/ms
SimulationTime=(NumOfTask+10)*(e1+e2+e3);%Einheit:ms

%Initialisierung
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,SimulationTime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,SimulationTime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,SimulationTime);
[WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,SimulationTime)
SchrankeNachTatiana = DelayDensity_GenerateDelayDensity( WorstResponstimeOfTask,NumOfInstanz);
Schranke_DBDD(1:NumOfInstanz)=(1:NumOfInstanz)*SchrankeNachTatiana(1);
figure(1)
hold on
plot(1:NumOfInstanz,Schranke_DBDD,'k')
plot(1:NumOfInstanz,SchrankeNachTatiana,'r')
xlabel('Intervall')
ylabel('Zeit(ms)')
legend('Kurve nach DBDD','Kurve nach Tatiana')

%kurve nach victor
for i=1:RepeatInstantNum %RepeatInstantNum herstellen
    for j=1:length(WorstResponstimeOfTask)
        index=mod(j,i);
        if index==0
            index=i;
        end
        Array(i,j)=WorstResponstimeOfTask(index);
    end
    DelayDensity_NewKurve(i,:)=DelayDensity_GenerateDelayDensity(Array(i,:),NumOfInstanz);%Falsh geschrieben:Array
end
DelayDensity_NewKurve_Oberschranken=DelayDensity_NewKurve(1,:);
for i=2:RepeatInstantNum
    DelayDensity_NewKurve_Oberschranken=DelayDensity_MaxArray(DelayDensity_NewKurve_Oberschranken,DelayDensity_NewKurve(i,:));
end
Schranke_Victor=DelayDensity_NewKurve_Oberschranken;
plot(1:NumOfInstanz,Schranke_Victor,'b')
legend('Kurve nach DBDD','Kurve nach Tatiana','Neue Kurve')

%Simulation und Validierung Kurve nach Tatiana
NumOfTest=20;
ph1=0;
ph2=0;
ph3=0;
for i=1:NumOfTest
    A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,SimulationTime);
    [A1_C,B1_C]=DelayDensity_FPConcreteModelInit( A1C,CPU_Bandwidth,SimulationTime);
    A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,SimulationTime);
    [A2_C,B2_C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,SimulationTime);
    A3C=DelayDensity_AConcrete_Generator(p3,j3,d3,ph3,e3,SimulationTime);
    [A3_C,B3_C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,SimulationTime);
    [StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,SimulationTime);
    KurveSimulation = DelayDensity_GenerateDelayDensity(ResponstimeOfTask,NumOfInstanz);
    figure(1)
    hold on
    %Kurve zeichnen
    plot(1:NumOfInstanz,KurveSimulation,'g')
end

% %Kapital 4 Case Study
% %Regelguete Ereignissegenerator nach Interrupt
% Kp=2;
% Ki=1.8;
% Kd=0.1;
% Umax=150;
% Totzone_Wert=0.01;
% rho_Wert=0.00001;
% CPU_Bandwidth=1;%resource unit/ms
% SimulationTime=50;%s
% sollwert=10;%rad/s
% 
% %Einsch?tzung
% MinimalAbtastzeit=2*3.14/sollwert;
% NumOfTask=400;
% NumOfInstanz=NumOfTask;%Anzahl der Instanzen ber¨¹cksichtigt
% Instanz=ones(1,NumOfInstanz)*0.05;%ausfuhrungszeit s
% time1=(0:1:(NumOfInstanz-1))*MinimalAbtastzeit %period s
% 
% %Simulation
% MasterArbeit_EreignisgeneratorsNachInterrupt;
% set_param('MasterArbeit_EreignisgeneratorsNachInterrupt','StartTime','0','StopTime','SimulationTime');
% set_param('MasterArbeit_EreignisgeneratorsNachInterrupt','stopfcn','Evaluation')
% sim('MasterArbeit_EreignisgeneratorsNachInterrupt')
% EreignisgeneratorsNachInterrupt=Drehzahl;
% plot(EreignisgeneratorsNachInterrupt.time,EreignisgeneratorsNachInterrupt.signals.values,'b')
% xlabel('Zeit(s)')
% ylabel('Drehzahl(rad/s)')
% legend('Nach Heemels','Nach Tabuada','Nach Interrupt')


%kapital 5 
%case study:RotierendesSystemMitTDMAundFP
CPU_Bandwidth=1;
simulationtime=8000;
NumOfInstanz=25;%Anzahl der Instanzen ber¨¹cksichtigt
NumOfTest=50;

p1=300;j1=450;d1=5;e1=10;ph1=0;

TDMA_Cycle=100;
TDMA_Slot=60;
TDMA_Phase=0;


p2=100;j2=250;d2=2;e2=5;ph2=0;
p3=150;j3=240;d3=2;e3=10;ph3=0;
p4=200;j4=400;d4=2;e4=10;ph4=0;
p5=250;j5=450;d5=2;e5=20;ph5=0;
e6=20;ph6=0;
%
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L,B1U,B1L ] = DelayDensity_TDMAModelInit( p1,j1,d1,e1,CPU_Bandwidth,TDMA_Cycle,TDMA_Slot,simulationtime);
A6U=DelayDensity_ConvertAnkunftskurve(A1_U,e1,e6,simulationtime);
A6L=DelayDensity_ConvertAnkunftskurve(A1_L,e1,e6,simulationtime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L,B2U,B2L ] = DelayDensity_FPModelInit( p2,j2,d2,e2,CPU_Bandwidth,simulationtime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,simulationtime);
[ A4_U,A4_L,B4_U,B4_L,A4U,A4L ] = DelayDensity_ConnectWithFPModel( B3_U,B3_L,p4,j4,d4,e4,simulationtime);
[ A5_U,A5_L,B5_U,B5_L,A5U,A5L ] = DelayDensity_ConnectWithFPModel( B4_U,B4_L,p5,j5,d5,e5,simulationtime);
[ A6_U,A6_L,B6_U,B6_L] = DelayDensity_GPCModel(A6U,A6L,B5_U,B5_L);
% hold on
% plot(0:simulationtime,B4_U(1:simulationtime+1),'b'); 
% plot(0:simulationtime,B4_L(1:simulationtime+1),'r'); 
% pause
%Task 2
% [WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A2U,B2L,B2_L,e2,simulationtime)
%Task 3
% [WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,simulationtime)
%Task 4
%[WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A4U,B3_L,B4_L,e4,simulationtime)
%Task 5
%[WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A5U,B4_L,B5_L,e5,simulationtime)
%Task 6
[WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A6U,B5_L,B6_L,e6,simulationtime)

% figure(8)
% hold on
% % plot(0:simulationtime,A1U(1:simulationtime+1),'b');
% plot(0:simulationtime,A6U(1:simulationtime+1),'r'); 
% plot(0:simulationtime,A6L(1:simulationtime+1),'b');
% pause
    


SchrankeNachTatiana = DelayDensity_GenerateDelayDensity( WorstResponstimeOfTask,NumOfInstanz);
Schranke_DBDD(1:NumOfInstanz)=(1:NumOfInstanz)*SchrankeNachTatiana(1);
figure(1)
hold on
plot(1:NumOfInstanz,Schranke_DBDD,'k')
% plot(1:NumOfInstanz,SchrankeNachTatiana,'r')
xlabel('Intervall')
ylabel('Zeit(ms)')

%kurve nach victor
for i=1:RepeatInstantNum %RepeatInstantNum herstellen
    for j=1:length(WorstResponstimeOfTask)
        index=mod(j,i);
        if index==0
            index=i;
        end
        Array(i,j)=WorstResponstimeOfTask(index);
    end
    DelayDensity_NewKurve(i,:)=DelayDensity_GenerateDelayDensity(Array(i,:),NumOfInstanz);
end
DelayDensity_NewKurve_Oberschranken=DelayDensity_NewKurve(1,:);
for i=2:RepeatInstantNum
    DelayDensity_NewKurve_Oberschranken=DelayDensity_MaxArray(DelayDensity_NewKurve_Oberschranken,DelayDensity_NewKurve(i,:));
end
Schranke_Victor=DelayDensity_NewKurve_Oberschranken;
plot(1:NumOfInstanz,Schranke_Victor,'b')
legend('Kurve nach DBDD','Neue Kurve')

%simulation

%Simulation
for i=1:NumOfTest
    A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,simulationtime);
    [A2_C,B2_C,B2C]=DelayDensity_FPConcreteModelInit( A2C,CPU_Bandwidth,simulationtime);
    A3C=DelayDensity_AConcrete_Generator(p3,j3,d3,ph3,e3,simulationtime);
    [A3_C,B3_C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);
    A4C=DelayDensity_AConcrete_Generator(p4,j4,d4,ph4,e4,simulationtime);
    [A4_C,B4_C]=DelayDensity_ConnectWithConcreteFPModel( B3_C,A4C,simulationtime);
    A5C=DelayDensity_AConcrete_Generator(p5,j5,d5,ph5,e5,simulationtime);
    [A5_C,B5_C]=DelayDensity_ConnectWithConcreteFPModel( B4_C,A5C,simulationtime);
    
    A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,simulationtime);
%     A6C=A6C_/e6*e5;
    [ A1_C_,B1_C,B1C ] = DelayDensity_TDMAConcreteModel( A1C,CPU_Bandwidth,TDMA_Cycle,TDMA_Slot,TDMA_Phase,simulationtime);
    A1_C=DelayDensity_ConvertAnkunftskurve(A1_C_,e1,e6,simulationtime);
%     A1_C=A1_C_/e1*e6;
    
%     j=1;
%     for i=1:simulationtime
%        if(A1_C_(i)==j*e6)
%            starttime(j)=i-1;
%            j=j+1;
%        end
%     end
%     j=1;
%     value=0;
%     for i=1:simulationtime
%        if(j<=length(starttime))
%            if(i-1==starttime(j))
%                value=value+e6;
%                j=j+1;
%            end
%        end
%        A1_C(i)=value;
%     end
%     plot(0:simulationtime,A1_C(1:simulationtime+1))
    
    
    [ A6_C,B6_C] = DelayDensity_ConnectWithConcreteFPModel( B5_C,A1_C,simulationtime);

    [StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( A1_C,B5_C,B6_C,e6,simulationtime)
    Kurve = DelayDensity_GenerateDelayDensity( ResponstimeOfTask,NumOfInstanz );

    figure(1)
    hold on
    plot(1:NumOfInstanz,Kurve,'g')

end



%case study 2
%DelayDensity_GeneticAlgorithm








