%Simulation Script
%Frank, Uni Ulm
clc;
warning off;
%Task_BCET=floor(Ereignis_BCET/TDMA_Bandwidth/TDMA_Slot)*TDMA_Cycle+Ereignis_BCET/TDMA_Bandwidth-floor(Ereignis_BCET/TDMA_Bandwidth/TDMA_Slot)*TDMA_Slot;
% Task_BCET=1;
% Task_WCET=Latenz(1);%langeste ResponseTime
% fprintf('Instanz_BCET: %d s Instanz_WCET: %d s\n',Task_BCET,Task_WCET);
% if(Task_BCET>Task_WCET) 
%     fprintf('Task_BCET>Task_WCET System Error!\n');
% end

Test_Anzahl=NumOfTask;
[ A_U,A_L,B_U,B_L,AU,AL,BU,BL ] = DelayDensity_TDMAModelInit( Ereignis_Abtastzeit,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,TDMA_Bandwidth,TDMA_Cycle,TDMA_Slot,SimulationTime);
[WorstStartTimeOfTask,WorstResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( AU,BL,B_L,Ereignis_WCET,NumOfTask,SimulationTime);
MaxDelayDensity = DelayDensity_GenerateDelayDensity( WorstResponstimeOfTask );
time1=WorstStartTimeOfTask(1:Test_Anzahl)/1000

%Langest Anstiegzeit bei Maximal Latenzdichte berechnen 
Latenz=MaxDelayDensity/1000
%Instanz herstellen
% Instanz(1)=Latenz(1);
% for i=2:Test_Anzahl
%     Instanz(i)=Latenz(i)-Latenz(i-1);
% end
Instanz=WorstResponstimeOfTask(1:NumOfTask)/1000
%Instanz=Responstime(1:Test_Anzahl)
%SimulationTime=time1(Test_Anzahl)+Ereignis_Abtastzeit*5;
GesamtModel
SimulationTime=SimulationTime/1000
set_param('GesamtModel','StartTime','0','StopTime','SimulationTime');
set_param('GesamtModel','Solver','ode45')
set_param('GesamtModel','stopfcn','Evaluation')
sim('GesamtModel')
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

fprintf('Bei Maximal Latenzdichte:\n');
fprintf('Risetime:%.2f Adjusttime:%.2f Overshoot:%.2f%% \n',tr,adjust_time,overshoot);
fprintf('Jabs:%.2f Jitae:%.2f Test_Jsqr:%.2f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
fprintf('DeltaLatenzDurchschnitt:%.2f Quadratisch:%.2f\n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
fprintf('************************ \n',tr,adjust_time,overshoot);


%Langest Anstiegzeit bei random Instanz berechnen
NameOfFile=input('Input the Name of File to save:','s');
NumOfTest=input('Input the Number of Simulation:');
fprintf('random Instanz unter Maximal Latenzdichte herstellen...\n');
fid=fopen(NameOfFile,'w');
fprintf(fid,'TestCase:\n');
%fprintf(fid,'P:%d J:%d D:%d WCET:%d TDMA_Slot:%d TDMA_Cycle:%d TDMA_Bandwidth:%d\n',Ereignis_Abtastzeit,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,TDMA_Slot,TDMA_Cycle,TDMA_Bandwidth);
fprintf(fid,'Maximal Latenzdicht: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Latenz);
fprintf(fid,'InstanzStartTime: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',time1);
fprintf(fid,'Instanz: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Instanz);
fprintf(fid,'Risetime:%.2f Adjusttime:%.2f Overshoot:%.2f%% \n',tr,adjust_time,overshoot);
fprintf(fid,'Jabs:%.2f Jitae:%.2f Test_Jsqr:%.2f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
fprintf(fid,'DeltaLatenzDurchschnitt:%.2f DeltaLatenzQuadratisch:%.2f\n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
fprintf(fid,'**********************\n');
for i=1:NumOfTest
%[Instanz,SotierendLatenzdicht,Latenzdicht]=SotierendeLatenzInstanzErzeuger(Latenz,Task_BCET,Task_WCET,Test_Anzahl,1);

% [Instanz,Latenzdicht]=LatenzInstanzErzeuger(Latenz,Task_BCET,Task_WCET,Test_Anzahl,1);
TDMA_Phase=floor((TDMA_Cycle-TDMA_Slot)*rand(1));
AConcrete=DelayDensity_TDMAModel_AConcrete_Generator(Ereignis_Abtastzeit,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,NumOfTask,SimulationTime);
[ A_Concrete,B_Concrte,Bconcrete ]=DelayDensity_TDMAConcreteModel( AConcrete,Ereignis_WCET,TDMA_Bandwidth,TDMA_Cycle,TDMA_Slot,TDMA_Phase,SimulationTime);
[StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( AConcrete,Bconcrete,B_Concrte,Ereignis_WCET,NumOfTask,SimulationTime);
Latenzdicht = DelayDensity_GenerateDelayDensity( ResponstimeOfTask );
% Latenzdicht = Latenzdicht(1:NumOfTask+1);
Instanz=ResponstimeOfTask;
time1=StartTimeOfTask;
% %if Jitter is > 0 und <Period so changed in Time Domain
% if Ereignis_Jitter>0 && Ereignis_Jitter<Ereignis_Abtastzeit
%     for j=2:NumOfTask
%         time1(j)=(j-1)*Ereignis_Abtastzeit-Ereignis_Jitter+2*Ereignis_Jitter*rand(1);
%     end
% end
GesamtModel
set_param('GesamtModel','StartTime','0','StopTime','SimulationTime');
set_param('GesamtModel','Solver','ode45')
set_param('GesamtModel','stopfcn','Evaluation')
sim('GesamtModel')
%Latenzdicht
%Instanz
Test_RiseTime(i)=tr;
Test_AdjustTime(i)=adjust_time;
Test_Jabs(i)=max(Jabs.signals.values); 
Test_Jitae(i)=max(Jitae.signals.values); 
Test_Jsqr(i)=max(Jsqr.signals.values);
%LatenzDurchschnitt: 1/k Summe(dri-dri-1) LatenzQuadratisch:Summe(dri-dri-1)`2
LatenzDurchschnitt(i)=Latenzdicht(1);
LatenzQuadratisch(i)=Latenzdicht(1)*Latenzdicht(1);
for k=2:NumOfTask-1
    LatenzDurchschnitt(i)=LatenzDurchschnitt(i)+Latenzdicht(k)-Latenzdicht(k-1);
    LatenzQuadratisch(i)=LatenzQuadratisch(i)+(Latenzdicht(k)-Latenzdicht(k-1))^2;
end
LatenzDurchschnitt(i)=LatenzDurchschnitt(i)/(NumOfTask-1);
LatenzQuadratisch(i)=LatenzQuadratisch(i);
fprintf('Simulation Case Num: %03d Risetime:%.2f Adjusttime:%.2f Overshoot:%.2f%% \n',i,tr,adjust_time,overshoot);
fprintf('Jabs:%.2f Jitae:%.2f Test_Jsqr:%.2f \n',Test_Jabs(i),Test_Jitae(i),Test_Jsqr(i));
fprintf('DeltaLatenzDurchschnitt:%.2f DeltaQuadratisch:%.2f\n',LatenzDurchschnitt(i),LatenzQuadratisch(i));
fprintf(fid,'Simulation Case Num: %03d\n',i);
fprintf(fid,'Latenzdicht: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Latenzdicht);
fprintf(fid,'InstanzStartTime: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',time1);
fprintf(fid,'\nInstanz: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Instanz);
fprintf(fid,'Risetime:%.2f Adjusttime:%.2f Overshoot:%.2f%% \n',tr,adjust_time,overshoot);
fprintf(fid,'Jabs:%.2f Jitae:%.2f Test_Jsqr:%.2f \n',Test_Jabs(i),Test_Jitae(i),Test_Jsqr(i));
fprintf(fid,'DeltaLatenzDurchschnitt:%.2f DeltaQuadratisch:%.2f\n',LatenzDurchschnitt(i),LatenzQuadratisch(i));
end

%Analysis
fprintf('Simulation Fertig und Analyse beginnt... \n');
%adjusttime
Test_Bestanden=1;
Test_AdjustTime_Max=Test_AdjustTime(1);
Test_AdjustTime_Index=1;
for i=1:NumOfTest
    if Test_AdjustTime(i)>Test_LangstAdjustTime
        Test_Bestanden=0;        
    end
    if Test_AdjustTime(i)>Test_AdjustTime_Max
        Test_AdjustTime_Max=Test_AdjustTime(i);
        Test_AdjustTime_Index=i;
    end
end
if Test_Bestanden==1
    fprintf('Adjusttime Ergebnis bestanden... \n Simulation Case %03d:Test_AdjustTime_Max:%.2f\n',Test_AdjustTime_Index,Test_AdjustTime_Max);
    fprintf(fid,'Adjusttime Ergebnis bestanden... \n Simulation Case %03d:Test_AdjustTime_Max:%.2f\n',Test_AdjustTime_Index,Test_AdjustTime_Max);
else
    fprintf('Adjusttime Ergebnis nicht bestanden... \nSimulation Case %03d:Test_AdjustTime_Max:%.2f\n',Test_AdjustTime_Index,Test_AdjustTime_Max);
    fprintf(fid,'Adjusttime Ergebnis nicht bestanden... \nSimulation Case %03d:Test_AdjustTime_Max:%.2f\n',Test_AdjustTime_Index,Test_AdjustTime_Max);
end
%Jabs
Test_Bestanden=1;
Test_Jabs_Max=Test_Jabs(1);
Test_Jabs_Index=1;
for i=1:NumOfTest
    if Test_Jabs(i)>Test_LargestJabs
        Test_Bestanden=0;        
    end
    if Test_Jabs(i)>Test_Jabs_Max
        Test_Jabs_Max=Test_Jabs(i);
        Test_Jabs_Index=i;
    end
end
if Test_Bestanden==1
    fprintf('Jabs Ergebnis bestanden... \n Simulation Case %03d:Test_Jabs_Max:%.2f\n',Test_Jabs_Index,Test_Jabs_Max);
    fprintf(fid,'Jabs Ergebnis bestanden... \n Simulation Case %03d:Test_Jabs_Max:%.2f\n',Test_Jabs_Index,Test_Jabs_Max);
else
    fprintf('Jabs Ergebnis nicht bestanden... \nSimulation Case %03d:Test_Jabs_Max:%.2f\n',Test_Jabs_Index,Test_Jabs_Max);
    fprintf(fid,'Jabs Ergebnis nicht bestanden... \nSimulation Case %03d:Test_Jabs_Max:%.2f\n',Test_Jabs_Index,Test_Jabs_Max);
end
%Jabs Test_Jsqr(i)
Test_Bestanden=1;
Test_Jsqr_Max=Test_Jsqr(1);
Test_Jsqr_Index=1;
for i=1:NumOfTest
    if Test_Jsqr(i)>Test_LargestJsqr
        Test_Bestanden=0;        
    end
    if Test_Jsqr(i)>Test_Jsqr_Max
        Test_Jsqr_Max=Test_Jsqr(i);
        Test_Jsqr_Index=i;
    end
end
if Test_Bestanden==1
    fprintf('Jsqr Ergebnis bestanden... \n Simulation Case %03d:Test_Jsqr_Max:%.2f\n',Test_Jsqr_Index,Test_Jsqr_Max);
    fprintf(fid,'Jsqr Ergebnis bestanden... \n Simulation Case %03d:Test_Jsqr_Max:%.2f\n',Test_Jsqr_Index,Test_Jsqr_Max);
else
    fprintf('Jsqr Ergebnis nicht bestanden... \nSimulation Case %03d:Test_Jsqr_Max:%.2f\n',Test_Jsqr_Index,Test_Jsqr_Max);
    fprintf(fid,'Jsqr Ergebnis nicht bestanden... \nSimulation Case %03d:Test_Jsqr_Max:%.2f\n',Test_Jsqr_Index,Test_Jsqr_Max);
end
fclose(fid);


