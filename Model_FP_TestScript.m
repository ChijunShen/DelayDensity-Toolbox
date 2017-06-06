warning off
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,SimulationTime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,SimulationTime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,SimulationTime);
[WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,SimulationTime)
MaxDelayDensity=DelayDensity_GenerateDelayDensity(WorstResponstimeOfTask,NumOfTask)/1000

time1=WorstStartTimeOfTask(1:NumOfTask)/1000; %Task Start Time  unit:s
Latenz=MaxDelayDensity;
SimulationTimeInSecond=SimulationTime/1000;



% figure(1)
% hold on
% plot(0:1200,A3U(1:1201),'r');
% plot(0:1200,A3L(1:1201),'r');
% plot(0:1200,B2_U(1:1201),'b');
% plot(0:1200,B2_L(1:1201),'b');
% xlabel('Zeit Einheit(ms)');
% ylabel('Ressource Einheit');
% pause

%DBDD
GesamtModel
Instanz(1:NumOfTask)=Latenz(1);
Latenz_DBDD(1:NumOfTask)=(1:NumOfTask)*Latenz(1);
set_param('GesamtModel','StartTime','0','StopTime','SimulationTimeInSecond');
set_param('GesamtModel','Solver','ode45')
set_param('GesamtModel','stopfcn','Evaluation')
sim('GesamtModel')
figure(10)
hold on
plot(RealSystemDrehzahl.time,RealSystemDrehzahl.signals.values,'k')
figure(11)
hold on
plot(1:NumOfTask,Latenz_DBDD,'k')
Test_LangstRiseTime=tr;
Test_LangstAdjustTime=adjust_time;
Test_LargestJabs=max(Jabs.signals.values); 
Test_LargestJitae=max(Jitae.signals.values); 
Test_LargestJsqr=max(Jsqr.signals.values);
%LatenzDurchschnitt: 1/k Summe(dri-dri-1) LatenzQuadratisch:Summe(dri-dri-1)`2
Test_LatenzDurchschnitt=Latenz(1);
Test_LatenzQuadratisch=Latenz(1)*Latenz(1);
for k=2:NumOfTask-1
    Test_LatenzDurchschnitt=Test_LatenzDurchschnitt+Latenz(k)-Latenz(k-1);
    Test_LatenzQuadratisch=Test_LatenzQuadratisch+(Latenz(k)-Latenz(k-1))^2;
end
Test_LatenzDurchschnitt=Test_LatenzDurchschnitt/(NumOfTask-1);
Test_LatenzQuadratisch=Test_LatenzQuadratisch;

fprintf('Bei DB-DD:\n');
fprintf('Risetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',tr,adjust_time,overshoot,Latenz(1));
fprintf('Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
fprintf('DeltaLatenzDurchschnitt:%.3f Quadratisch:%.3f \n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
fprintf('************************ \n',tr,adjust_time,overshoot);

overshoot_DBDD=overshoot;
Jabs_DBDD=Test_LargestJabs;
Jsqr_DBDD=Test_LargestJsqr;
Jitae_DBDD=Test_LargestJitae;

%DFDD
Instanz=WorstResponstimeOfTask(1:NumOfTask)/1000; %Responsetime unit:s
set_param('GesamtModel','StartTime','0','StopTime','SimulationTimeInSecond');
set_param('GesamtModel','Solver','ode45')
set_param('GesamtModel','stopfcn','Evaluation')
sim('GesamtModel')
figure(10)
hold on
plot(RealSystemDrehzahl.time,RealSystemDrehzahl.signals.values,'r')
figure(11)
hold on
plot(1:NumOfTask,Latenz,'r')
Test_LangstRiseTime=tr;
Test_LangstAdjustTime=adjust_time;
Test_LargestJabs=max(Jabs.signals.values); 
Test_LargestJitae=max(Jitae.signals.values); 
Test_LargestJsqr=max(Jsqr.signals.values);
%LatenzDurchschnitt: 1/k Summe(dri-dri-1) LatenzQuadratisch:Summe(dri-dri-1)`2
Test_LatenzDurchschnitt=Latenz(1);
Test_LatenzQuadratisch=Latenz(1)*Latenz(1);
for k=2:NumOfTask-1
    Test_LatenzDurchschnitt=Test_LatenzDurchschnitt+Latenz(k)-Latenz(k-1);
    Test_LatenzQuadratisch=Test_LatenzQuadratisch+(Latenz(k)-Latenz(k-1))^2;
end
Test_LatenzDurchschnitt=Test_LatenzDurchschnitt/(NumOfTask-1);
Test_LatenzQuadratisch=Test_LatenzQuadratisch;
% 
% 
% figure(20)
% hold on
% plot(1:30,Latenz_DBDD(1:30),'k')
% plot(1:30,Latenz(1:30),'r')
% xlabel('Interval Bereich')
% ylabel('Zeit(S)')
% pause

fprintf('Bei DF-DD:\n');
fprintf('Risetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',tr,adjust_time,overshoot,Latenz(1));
fprintf('Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
fprintf('DeltaLatenzDurchschnitt:%.3f Quadratisch:%.3f \n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
fprintf('************************ \n',tr,adjust_time,overshoot);

%kurve nach victor
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
set_param('GesamtModel','StartTime','0','StopTime','SimulationTimeInSecond');
set_param('GesamtModel','Solver','ode45')
set_param('GesamtModel','stopfcn','Evaluation')
sim('GesamtModel')
figure(10)
hold on
plot(RealSystemDrehzahl.time,RealSystemDrehzahl.signals.values,'b')
figure(11)
hold on
plot(1:NumOfTask,Latenz/1000,'b')
Test_LangstRiseTime=tr;
Test_LangstAdjustTime=adjust_time;
Test_LargestJabs=max(Jabs.signals.values); 
Test_LargestJitae=max(Jitae.signals.values); 
Test_LargestJsqr=max(Jsqr.signals.values);
%LatenzDurchschnitt: 1/k Summe(dri-dri-1) LatenzQuadratisch:Summe(dri-dri-1)`2
Test_LatenzDurchschnitt=Latenz(1);
Test_LatenzQuadratisch=Latenz(1)*Latenz(1);
for k=2:NumOfTask-1
    Test_LatenzDurchschnitt=Test_LatenzDurchschnitt+Latenz(k)-Latenz(k-1);
    Test_LatenzQuadratisch=Test_LatenzQuadratisch+(Latenz(k)-Latenz(k-1))^2;
end
Test_LatenzDurchschnitt=Test_LatenzDurchschnitt/(NumOfTask-1);
Test_LatenzQuadratisch=Test_LatenzQuadratisch;
fprintf('Bei Victor:\n');
fprintf('Risetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',tr,adjust_time,overshoot,Latenz(1));
fprintf('Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
fprintf('DeltaLatenzDurchschnitt:%.3f Quadratisch:%.3f \n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
fprintf('************************ \n',tr,adjust_time,overshoot);

overshoot_Victor=overshoot;
Jabs_Victor=Test_LargestJabs;
Jsqr_Victor=Test_LargestJsqr;
Jitae_Victor=Test_LargestJitae;


NameOfFile=input('Input the Name of File to save:','s');
% NumOfTest=input('Input the Number of Simulation:');
fprintf('random Instanz unter Maximal Latenzdichte herstellen...\n');
fid=fopen(NameOfFile,'w');
% fprintf(fid,'TestCase:\n');
% %fprintf(fid,'P:%d J:%d D:%d WCET:%d TDMA_Slot:%d TDMA_Cycle:%d TDMA_Bandwidth:%d\n',Ereignis_Abtastzeit,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,TDMA_Slot,TDMA_Cycle,TDMA_Bandwidth);
% fprintf(fid,'Maximal Latenzdicht: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Latenz);
% fprintf(fid,'InstanzStartTime: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',time1);
% fprintf(fid,'Instanz: \n%g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Instanz);
% fprintf(fid,'\nRisetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',tr,adjust_time,overshoot,Latenz(1));
% fprintf(fid,'Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
% fprintf(fid,'DeltaLatenzDurchschnitt:%.3f DeltaLatenzQuadratisch:%.3f\n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
% fprintf(fid,'**********************\n');

%Simulation
% for i=1:NumOfTest
% TDMA_Phase=floor((TDMA_Cycle-TDMA_Slot)*rand(1)+0.5);
% AConcrete=DelayDensity_TDMAModel_AConcrete_Generator(Ereignis_Abtastzeit,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,NumOfTask,SimulationTime);
% [ A_Concrete,B_Concrte,Bconcrete ]=DelayDensity_TDMAConcreteModel( AConcrete,Ereignis_WCET,TDMA_Bandwidth,TDMA_Cycle,TDMA_Slot,TDMA_Phase,SimulationTime);
% [StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( AConcrete,Bconcrete,B_Concrte,Ereignis_WCET,NumOfTask,SimulationTime);
% Latenzdicht = DelayDensity_GenerateDelayDensity( ResponstimeOfTask )/1000;
% ph1=floor(ph1max*rand(1)+0.5);
% ph2=floor(ph2max*rand(1)+0.5);
ph3=floor(ph3max*rand(1)+0.5);
i=0;
for ph1=1:ph1max
    for ph2=1:ph2max
        A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,SimulationTime);
        [A1_C,B1_C]=DelayDensity_FPConcreteModelInit( A1C,CPU_Bandwidth,SimulationTime);
        A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,SimulationTime);
        [A2_C,B2_C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,SimulationTime);
        A3C=DelayDensity_AConcrete_Generator(p3,j3,d3,ph3,e3,SimulationTime);
        [A3_C,B3_C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,SimulationTime);
        [StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,SimulationTime);
        Latenzdicht = DelayDensity_GenerateDelayDensity( ResponstimeOfTask,NumOfTask )/1000;
        Instanz=ResponstimeOfTask(1:NumOfTask)/1000;
        time1=StartTimeOfTask(1:NumOfTask)/1000;
        % GesamtModel
        set_param('GesamtModel','StartTime','0','StopTime','SimulationTimeInSecond');
        set_param('GesamtModel','Solver','ode45')
        set_param('GesamtModel','stopfcn','Evaluation')
        sim('GesamtModel')
        %Latenzdicht
        %Instanz
        i=i+1;
        Test_RiseTime(i)=tr;
        Test_AdjustTime(i)=adjust_time;
        Test_Jabs(i)=max(Jabs.signals.values); 
        Test_Jitae(i)=max(Jitae.signals.values); 
        Test_Jsqr(i)=max(Jsqr.signals.values);
        % %decide
        % if Test_Jabs(i)>Test_LargestJabs||Test_Jitae(i)>Test_LargestJitae||Test_Jabs(i)>Test_LargestJabs
        %     figure(10)
        %     hold on
        %     plot(RealSystemDrehzahl.time,RealSystemDrehzahl.signals.values,'r')
        %     figure(11)
        %     hold on
        %     plot(1:NumOfTask,Latenzdicht,'r')
        % else
            figure(10)
            hold on
            plot(RealSystemDrehzahl.time,RealSystemDrehzahl.signals.values,'g')
            figure(11)
            hold on
            plot(1:NumOfTask,Latenzdicht,'g')

        % end
        fprintf('Simulation Case ph1: %d ph2: %d Risetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',ph1,ph2,tr,adjust_time,overshoot,Latenzdicht(1));
        fprintf('Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_Jabs(i),Test_Jitae(i),Test_Jsqr(i));
        fprintf('Deltaovershoot1:%f Deltaovershoot2:%f DeltaJabs1:%f DeltaJabs2:%f DeltaJsqr1:%f DeltaJsqr2:%f DeltaJitae1:%f DeltaJitae2:%f\n',overshoot-overshoot_DBDD,overshoot-overshoot_Victor,Test_Jabs(i)-Jabs_DBDD,Test_Jabs(i)-Jabs_Victor,Test_Jsqr(i)-Jsqr_DBDD,Test_Jsqr(i)-Jsqr_Victor,Test_Jitae(i)-Jitae_DBDD,Test_Jitae(i)-Jitae_Victor);
        fprintf(fid,'%f,%f,%f,%f,%f,%f,%f,%f\n',overshoot-overshoot_DBDD,overshoot-overshoot_Victor,Test_Jabs(i)-Jabs_DBDD,Test_Jabs(i)-Jabs_Victor,Test_Jsqr(i)-Jsqr_DBDD,Test_Jsqr(i)-Jsqr_Victor,Test_Jitae(i)-Jitae_DBDD,Test_Jitae(i)-Jitae_Victor);
    end
end
% end