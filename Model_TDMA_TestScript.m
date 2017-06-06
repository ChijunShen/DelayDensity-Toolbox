%Model TDMA Matlab Simulation Script
%Frank, Uni Ulm
%2017

warning off;
%dr+ 
Test_Anzahl=NumOfTask;
[ A_U,A_L,B_U,B_L,AU,AL,BU,BL ] = DelayDensity_TDMAModelInit( Ereignis_Periode,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,TDMA_Bandwidth,TDMA_Cycle,TDMA_Slot,SimulationTime);
[WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( AU,BL,B_L,Ereignis_WCET,SimulationTime)
MaxDelayDensity = DelayDensity_GenerateDelayDensity( WorstResponstimeOfTask,NumOfTask)/1000;%unit:s
time1=WorstStartTimeOfTask(1:Test_Anzahl)/1000; %Task Start Time  unit:s
Latenz=MaxDelayDensity;
SimulationTimeInSecond=SimulationTime/1000

% 
% figure(1)
% hold on
% plot(0:250,AU(1:251),'r');
% plot(0:250,AL(1:251),'r');
% plot(0:250,BU(1:251),'b');
% plot(0:250,BL(1:251),'b');
% xlabel('Zeit Einheit');
% ylabel('Ressource Einheit');
% pause

%worst case
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

%dR+
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

%kurve 1
% if RepeatInstantNum~=0
%     for i=1:length(WorstResponstimeOfTask)
%         RepeatIndex=mod(i,RepeatInstantNum);
%         if RepeatIndex==0
%             RepeatIndex=RepeatInstantNum;
%         end
%         Instanz_Neu(i)=WorstResponstimeOfTask(RepeatIndex); 
%     end
%     DelayDensity_Kurve_Neu=DelayDensity_GenerateDelayDensity(Instanz_Neu,NumOfTask);
%     plot(1:NumOfTask,DelayDensity_Kurve_Neu/1000,'m');
% end



%kurve nach shen
% if RepeatInstantNum~=0
%     for i=1:length(WorstResponstimeOfTask)
%         RepeatIndex=mod(i,RepeatInstantNum);
%         if RepeatIndex==0
%             RepeatIndex=RepeatInstantNum;
%         end
%         Instanz_Neu(i)=Sort_ResponstimeOfTask5(RepeatIndex); 
%     end
%     DelayDensity_FPModel_Neu=DelayDensity_GenerateDelayDensity(Instanz_Neu,NumOfTask);
% end


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
% figure(11)
% hold on
% plot(1:NumOfTask,Latenz/1000,'b')
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




NameOfFile=input('Input the Name of File to save:','s');
NumOfTest=input('Input the Number of Simulation:');
fprintf('random Instanz unter Maximal Latenzdichte herstellen...\n');
fid=fopen(NameOfFile,'w');
fprintf(fid,'TestCase:\n');
%fprintf(fid,'P:%d J:%d D:%d WCET:%d TDMA_Slot:%d TDMA_Cycle:%d TDMA_Bandwidth:%d\n',Ereignis_Periode,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,TDMA_Slot,TDMA_Cycle,TDMA_Bandwidth);
fprintf(fid,'Maximal Latenzdicht: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Latenz);
fprintf(fid,'InstanzStartTime: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',time1);
fprintf(fid,'Instanz: \n%g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Instanz);
fprintf(fid,'\nRisetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',tr,adjust_time,overshoot,Latenz(1));
fprintf(fid,'Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
fprintf(fid,'DeltaLatenzDurchschnitt:%.3f DeltaLatenzQuadratisch:%.3f\n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
fprintf(fid,'**********************\n');

%Simulation
for i=1:NumOfTest
TDMA_Phase=floor((TDMA_Cycle-TDMA_Slot)*rand(1)+0.5);
Ereignis_Phase=0;
%AConcrete=DelayDensity_TDMAModel_AConcrete_Generator(Ereignis_Periode,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,NumOfTask,SimulationTime);
AConcrete=DelayDensity_AConcrete_Generator(Ereignis_Periode,Ereignis_Jitter,Ereignis_Delta,Ereignis_Phase,Ereignis_WCET,SimulationTime);
[ A_Concrete,B_Concrte,Bconcrete ]=DelayDensity_TDMAConcreteModel( AConcrete,TDMA_Bandwidth,TDMA_Cycle,TDMA_Slot,TDMA_Phase,SimulationTime);
[StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( AConcrete,Bconcrete,B_Concrte,Ereignis_WCET,SimulationTime);
Latenzdicht = DelayDensity_GenerateDelayDensity( ResponstimeOfTask,NumOfTask)/1000;
Instanz=ResponstimeOfTask(1:NumOfTask)/1000;
time1=StartTimeOfTask(1:NumOfTask)/1000;
% % GesamtModel
% set_param('GesamtModel','StartTime','0','StopTime','SimulationTimeInSecond');
% set_param('GesamtModel','Solver','ode45')
% set_param('GesamtModel','stopfcn','Evaluation')
% sim('GesamtModel')
% %Latenzdicht
% %Instanz
% Test_RiseTime(i)=tr;
% Test_AdjustTime(i)=adjust_time;
% Test_Jabs(i)=max(Jabs.signals.values); 
% Test_Jitae(i)=max(Jitae.signals.values); 
% Test_Jsqr(i)=max(Jsqr.signals.values);
% %LatenzDurchschnitt: 1/k Summe(dri-dri-1) LatenzQuadratisch:Summe(dri-dri-1)`2
% LatenzDurchschnitt(i)=Latenzdicht(1);
% LatenzQuadratisch(i)=Latenzdicht(1)*Latenzdicht(1);
% for k=2:NumOfTask-1
%     LatenzDurchschnitt(i)=LatenzDurchschnitt(i)+Latenzdicht(k)-Latenzdicht(k-1);
%     LatenzQuadratisch(i)=LatenzQuadratisch(i)+(Latenzdicht(k)-Latenzdicht(k-1))^2;
% end
% LatenzDurchschnitt(i)=LatenzDurchschnitt(i)/(NumOfTask-1);
% LatenzQuadratisch(i)=LatenzQuadratisch(i);
%decide
% if Test_Jabs(i)>Test_LargestJabs||Test_Jitae(i)>Test_LargestJitae||Test_Jabs(i)>Test_LargestJabs
% %     figure(10)
% %     hold on
% %     plot(RealSystemDrehzahl.time,RealSystemDrehzahl.signals.values,'g')
%     figure(11)
%     hold on
%     plot(1:NumOfTask,Latenzdicht,'g')
% else
%     figure(10)
%     hold on
%     plot(RealSystemDrehzahl.time,RealSystemDrehzahl.signals.values,'g')
    figure(11)
    hold on
    plot(1:NumOfTask,Latenzdicht,'g')
% 
% end
% fprintf('Simulation Case Num: %03d Risetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',i,tr,adjust_time,overshoot,Latenzdicht(1));
% fprintf('Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_Jabs(i),Test_Jitae(i),Test_Jsqr(i));
% fprintf('DeltaLatenzDurchschnitt:%.3f DeltaQuadratisch:%.3f\n',LatenzDurchschnitt(i),LatenzQuadratisch(i));
% fprintf(fid,'Simulation Case Num: %03d\n',i);
% fprintf(fid,'Latenzdicht: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Latenzdicht);
% fprintf(fid,'InstanzStartTime: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',time1);
% fprintf(fid,'Instanz: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Instanz);
% fprintf(fid,'\nRisetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',tr,adjust_time,overshoot,Latenzdicht(1));
% fprintf(fid,'Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_Jabs(i),Test_Jitae(i),Test_Jsqr(i));
% fprintf(fid,'DeltaLatenzDurchschnitt:%.3f DeltaQuadratisch:%.3f\n',LatenzDurchschnitt(i),LatenzQuadratisch(i));
end