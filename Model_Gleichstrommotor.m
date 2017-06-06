%Matlab Modellierung eines permannentmagneterregten Gleichstrommotors
%Frank Shen, Uni Ulm
%2017

clear
clc

%Gleichstrommotor System Parameter
L_A=0.5;           %Ankerinduktivitat Unit:H  
R_A=1.0;           %Ankerwiderstand Unit:Ohm
K_M=0.01;          %Motorkonstant Unit:Nm/A
K_B=0.01;          %back emf constant
K_F=0.1;           %Reibungskonstante Unit:Nms
J_M=0.01;          %Ankertragheitsmoment Unit:kgm2
M_L=0;             %Lastdrehenmoment Unit:Nm

%PID-Reglegungen
Kp=0.4;%0.4; casestudy 1
Ki=0.5;%8;
Kd=0.3;%5
Umax=500;

%Ereignisgenerator
EncoderDegree=180;
Ereignisgenerator_Sampletime=0.01;%s

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

GesamtModel


%Genetic Algorithmus parameter suchen
% Kp=1;
% Ki=2;
% Kd=0.5;
% NumOfTask=200;
% sollwert=15;%rad/s
% Totzone_Wert=0.001;%Ereignisbasierte Regelung mit Totzone
% rho_Wert=0.0001;
% c3=20;
% r3=10*c3;
% p3=500;
% Instanz=r3*ones(1,NumOfTask)/1000;
% time1=(0:p3:(NumOfTask-1)*p3)/1000;
% 
% set_param('GesamtModel','StartTime','0','StopTime','50');
% set_param('GesamtModel','Solver','ode45')
% sim('GesamtModel')
%plot(Drehzahl.time,Drehzahl.signals.values(:,1),'LineWidth',1.5);
%xlabel('Zeit(s)')
%ylabel('Drehzahl(rad/s)')
%plot(Drehzahl1(:,1),Drehzahl1(:,2),'LineWidth',1.5);

%Delaydensity TDMA Model
% Kp=0.4;%0.4; casestudy 1
% Ki=1.7;%3;%8;
% Kd=1;%5
% sollwert=15;%rad/s
% Totzone_Wert=0.1;%Ereignisbasierte Regelung mit Totzone
% rho_Wert=0.001;
% NumOfTask=30;%Number Of Instanz
% Ereignis_Periode=30;%ms
% Ereignis_Jitter=50;%ms 450
% Ereignis_Delta=5;%ms
% Ereignis_WCET=10;%resource unit
% TDMA_Slot=6;%ms
% TDMA_Cycle=10;%ms
% TDMA_Bandwidth=1;%resource unit/ms
% SimulationTime=(NumOfTask+10)*Ereignis_Abtastzeit;%ms
% Model_TDMA_TestScript

%Delaydensity FP Model
sollwert=10;%rad/s
Totzone_Wert=0.1;%Ereignisbasierte Regelung mit Totzone
rho_Wert=0.001;
NumOfTask=60;%Number Of Instanz

%task1
% Kp=3;
% Ki=5;
% Kd=2;
% p1=87;j1=45;d1=6;e1=7;ph1max=23;%ms
% p2=23;j2=4;d2=7;e2=1;ph2max=14;%ms
% p3=200;j3=250;d3=10;e3=20;ph3max=0;%resource unit

%task2
% Kp=3;
% Ki=5;
% Kd=2;
% p1=73;j1=13;d1=10;e1=17;ph1max=1;%ms
% p2=51;j2=93;d2=10;e2=2;ph2max=66;%ms
% p3=400;j3=450;d3=10;e3=50;ph3max=0;%resource unit

%task4
% Kp=0.5;
% Ki=2;
% Kd=0.2;
% p1=65;j1=47;d1=1;e1=5;ph1max=7;%ms
% p2=85;j2=29;d2=6;e2=1;ph2max=18;%ms
% p3=200;j3=250;d3=10;e3=20;ph3max=0;%resource unit

%task5
Kp=0.5;
Ki=2;
Kd=0.2;
p1=73;j1=13;d1=10;e1=17;ph1max=1;%ms
p2=51;j2=93;d2=10;e2=2;ph2max=66;%ms
p3=400;j3=450;d3=10;e3=50;ph3max=0;%resource unit






CPU_Bandwidth=1;%resource unit/ms
SimulationTime=26000;%ms
Model_FP_TestScript


%Case Study
% Kp=0.4;%0.4; casestudy 1
% Ki=0.5;%8;
% Kd=0.3;%5
% sollwert=20;%rad/s
% Totzone_Wert=0.05;%Ereignisbasierte Regelung mit Totzone
% rho_Wert=0.001;
% %5 is regler task FP
% p1=100;j1=120;d1=2;e1=10;ph1=0;
% p2=200;j2=240;d2=2;e2=10;ph2=0;
% p3=300;j3=320;d3=2;e3=10;ph3=0;
% p4=400;j4=30;d4=2;e4=10;ph4=0;
% %p5=30;j5=100;d5=2;e5=4;ph5=0;
% e5=20;
% %bus tdma 1 Ereignis von Encoder
% p6=50;j6=100;d6=2;e6=1;ph6=0;
% TDMA_Cycle=7;
% TDMA_Slot=2;
% TDMA_Phase=0;
% CPU_Bandwidth=1;
% simulationtime=15000;
% SimulationTime=15000;
% NumOfTask=200;
% Model_CaseStudy_TestScript



%Steuerbarkeits und Beobachtbarkeitsmatrix
% Steuerbarkeitsmatrix=[System_B System_A*System_B System_A*System_A*System_B]
% Rang_Steuerbarkeitsmatrix=rank(Steuerbarkeitsmatrix)
% Beobachtbarkeitsmatrix=[System_C;System_C*System_A;System_C*System_A*System_A]
% Rang_Beobachtbarkeitsmatrix=rank(Beobachtbarkeitsmatrix)
% Eigenwert=eig(System_A)







%Parameter verteilte System
% task_execution_time=0;
% verteilteSystem_delay=0;




%Luenberger-,Beobachter Stoegrosse Beobachter
% l=[1;1;1];
% Cd=1;
% Ad=-1;
% Cd_Matrix=[Cd;Cd;Cd]
% Luenberger_A=[System_A Cd_Matrix;0 0 0 Ad];
% Luenberger_B=[System_B;0];
% Luenberger_C=[System_C 0];
% LuenbergerBeobachtbarkeitsmatrix=[Luenberger_C;Luenberger_C*Luenberger_A;Luenberger_C*Luenberger_A*Luenberger_A;Luenberger_C*Luenberger_A*Luenberger_A*Luenberger_A];
% Rang_LuenbergerBeobachtbarkeitsmatrix=rank(LuenbergerBeobachtbarkeitsmatrix)
% eig(System_A-l*System_C)

% %fixed-priority system
% warning off;
% p1=10;
% e1=1;
% ph1max=p1;
% p2=15;
% e2=5;
% ph2max=p2;
% p3=10;%regler task
% e3=3;
% ph3max=0;
% CPU_Bandwidth=1;
% sollwert=15;
% simulationtime=400;
% Ereignis_Abtastzeit=p3;
% NumOfTask=30;
% [ A1_U,A1_L,B1_U,B1_L,A1U,A1L ] = DelayDensity_FPModelInit( p1,p1,e1,CPU_Bandwidth,simulationtime);
% [ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,p2,e2,simulationtime);
% [ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,p3,e3,simulationtime);
% [time1,Responstime]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,NumOfTask+1,simulationtime);
% DelayDensity_FPModel=DelayDensity_GenerateDelayDensity(Responstime);
% 
% %Instanz bilden
% for i=1:NumOfTask
%     Instanz(i)=DelayDensity_FPModel(i+1)-DelayDensity_FPModel(i);
% end
% Instanz
% Test_Anzahl=NumOfTask;
% GesamtModel
% set_param('GesamtModel','StartTime','0','StopTime','simulationtime');
% set_param('GesamtModel','Solver','ode45')
% set_param('GesamtModel','stopfcn','Evaluation')
% sim('GesamtModel')
% 
% Test_LangstRiseTime=tr;
% Test_LangstAdjustTime=adjust_time;
% Test_LargestJabs=max(Jabs.signals.values); 
% Test_LargestJitae=max(Jitae.signals.values); 
% Test_LargestJsqr=max(Jsqr.signals.values);
% %LatenzDurchschnitt: 1/k Summe(dri-dri-1) LatenzQuadratisch:Summe(dri-dri-1)`2
% Test_LatenzDurchschnitt=0;
% Test_LatenzQuadratisch=0;
% for k=1:NumOfTask
%     Test_LatenzDurchschnitt=Test_LatenzDurchschnitt+DelayDensity_FPModel(k+1)-DelayDensity_FPModel(k);
%     Test_LatenzQuadratisch=Test_LatenzQuadratisch+(DelayDensity_FPModel(k+1)-DelayDensity_FPModel(k))^2;
% end
% Test_LatenzDurchschnitt=Test_LatenzDurchschnitt/NumOfTask;
% Test_LatenzQuadratisch=Test_LatenzQuadratisch;
% 
% fprintf('Bei Maximal Latenzdichte:\n');
% fprintf('Risetime:%.2f Adjusttime:%.2f Overshoot:%.2f%% \n',tr,adjust_time,overshoot);
% fprintf('Jabs:%.2f Jitae:%.2f Test_Jsqr:%.2f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
% fprintf('DeltaLatenzDurchschnitt:%.2f Quadratisch:%.2f\n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
% fprintf('************************ \n',tr,adjust_time,overshoot);
% 
% NameOfFile=input('Input the Name of File to save:','s');
% NumOfTest=input('Input the Number of Simulation:');
% fprintf('random Instanz unter Maximal Latenzdichte herstellen...\n');
% fid=fopen(NameOfFile,'w');
% fprintf(fid,'TestCase:\n');
% %fprintf(fid,'P:%d J:%d D:%d WCET:%d TDMA_Slot:%d TDMA_Cycle:%d TDMA_Bandwidth:%d\n',Ereignis_Abtastzeit,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,TDMA_Slot,TDMA_Cycle,TDMA_Bandwidth);
% fprintf(fid,'Maximal Latenzdicht: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',DelayDensity_FPModel);
% fprintf(fid,'InstanzStartTime: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',time1);
% fprintf(fid,'Instanz: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Instanz);
% fprintf(fid,'Risetime:%.2f Adjusttime:%.2f Overshoot:%.2f%% \n',tr,adjust_time,overshoot);
% fprintf(fid,'Jabs:%.2f Jitae:%.2f Test_Jsqr:%.2f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
% fprintf(fid,'DeltaLatenzDurchschnitt:%.2f DeltaLatenzQuadratisch:%.2f\n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
% fprintf(fid,'**********************\n');

% %Laufende Simulation Wichtig!
% for i=1:NumOfTest
% ph1=floor(ph1max*rand(1));
% ph2=floor(ph2max*rand(1));
% ph3=floor(ph3max*rand(1));
% [A1_C,B1_C,A1C]=DelayDensity_FPConcreteModelInit( p1,p1,ph1,e1,CPU_Bandwidth,simulationtime);
% [A2_C,B2_C,A2C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,p2,p2,ph2,e2,simulationtime);
% [A3_C,B3_C,A3C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,p3,p3,ph3,e3,simulationtime);
% [time1,Responstime]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,NumOfTask+1,simulationtime);
% TestCase_DelayDensity_FPModel=DelayDensity_GenerateDelayDensity(Responstime);
% Instanz=Responstime(1:30)
% GesamtModel
% set_param('GesamtModel','StartTime','0','StopTime','simulationtime');
% set_param('GesamtModel','Solver','ode45')
% set_param('GesamtModel','stopfcn','Evaluation')
% sim('GesamtModel')
% %Instanz
% Test_RiseTime(i)=tr;
% Test_AdjustTime(i)=adjust_time;
% Test_Jabs(i)=max(Jabs.signals.values); 
% Test_Jitae(i)=max(Jitae.signals.values); 
% Test_Jsqr(i)=max(Jsqr.signals.values);
% %LatenzDurchschnitt: 1/k Summe(dri-dri-1) LatenzQuadratisch:Summe(dri-dri-1)`2
% % %LatenzDurchschnitt: 1/k Summe(dri-dri-1) LatenzQuadratisch:Summe(dri-dri-1)`2
% % Test_LatenzDurchschnitt=0;
% % Test_LatenzQuadratisch=0;
% % for k=1:NumOfTask
% %     Test_LatenzDurchschnitt=Test_LatenzDurchschnitt+DelayDensity_FPModel(k+1)-DelayDensity_FPModel(k);
% %     Test_LatenzQuadratisch=Test_LatenzQuadratisch+(DelayDensity_FPModel(k+1)-DelayDensity_FPModel(k))^2;
% % end
% LatenzDurchschnitt(i)=0;
% LatenzQuadratisch(i)=0;
% for k=1:NumOfTask
%     LatenzDurchschnitt(i)=LatenzDurchschnitt(i)+TestCase_DelayDensity_FPModel(k+1)-TestCase_DelayDensity_FPModel(k);
%     LatenzQuadratisch(i)=LatenzQuadratisch(i)+(TestCase_DelayDensity_FPModel(k+1)-TestCase_DelayDensity_FPModel(k))^2;
% end
% LatenzDurchschnitt(i)=LatenzDurchschnitt(i)/NumOfTask;
% LatenzQuadratisch(i)=LatenzQuadratisch(i);
% fprintf('Simulation Case Num: %03d Risetime:%.2f Adjusttime:%.2f Overshoot:%.2f%% \n',i,tr,adjust_time,overshoot);
% fprintf('Jabs:%.2f Jitae:%.2f Test_Jsqr:%.2f \n',Test_Jabs(i),Test_Jitae(i),Test_Jsqr(i));
% fprintf('DeltaLatenzDurchschnitt:%.2f DeltaQuadratisch:%.2f\n',LatenzDurchschnitt(i),LatenzQuadratisch(i));
% fprintf(fid,'Simulation Case Num: %03d\n',i);
% fprintf(fid,'Latenzdicht: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',TestCase_DelayDensity_FPModel);
% fprintf(fid,'InstanzStartTime: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',time1);
% fprintf(fid,'\nInstanz: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Instanz);
% fprintf(fid,'Risetime:%.2f Adjusttime:%.2f Overshoot:%.2f%% \n',tr,adjust_time,overshoot);
% fprintf(fid,'Jabs:%.2f Jitae:%.2f Test_Jsqr:%.2f \n',Test_Jabs(i),Test_Jitae(i),Test_Jsqr(i));
% fprintf(fid,'DeltaLatenzDurchschnitt:%.2f DeltaQuadratisch:%.2f\n',LatenzDurchschnitt(i),LatenzQuadratisch(i));
% end
% 
% 
% 
% 
% 
% % LatenzInstanzErzeuger_Test;
% % figure(1)
% % hold ontime
% % plot(0:1:simulationtime,A3U,'b');
% % plot(0:1:simulationtime,B2_L,'r');
% % plot(0:1:simulationtime,A2L,'r');
% % plot(0:1:simulationtime,A_L,'r');
% % % plot(0:1:simulationtime,AL,'b.');
% % % plot(0:1:simulationtime,BL,'b.');
% % figure(2)
% % hold on
% % plot(0:1:simulationtime,B_U,'g');
% % plot(0:1:simulationtime,B_L,'b');




