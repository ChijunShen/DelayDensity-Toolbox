 warning off
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L,B1U,B1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);
[ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,simulationtime);
[ A4_U,A4_L,B4_U,B4_L,A4U,A4L ] = DelayDensity_ConnectWithFPModel( B3_U,B3_L,p4,j4,d4,e4,simulationtime);
[ A6_U,A6_L,B6_U,B6_L,A6U,A6L,B6U,B6L ] = DelayDensity_TDMAModelInit( p6,j6,d6,e6,CPU_Bandwidth,TDMA_Cycle,TDMA_Slot,simulationtime);
[ A5_U,A5_L,B5_U,B5_L] = DelayDensity_GPCModel(A6_U*e5,A6_L*e5,B4_U,B4_L);

[WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A6_U*e5,B4_L,B5_L,e5,simulationtime)
Sort_ResponstimeOfTask5=sort(WorstResponstimeOfTask,'descend');
MaxDelayDensity=DelayDensity_GenerateDelayDensity(WorstResponstimeOfTask,NumOfTask)/1000;

time1=WorstStartTimeOfTask(1:NumOfTask)/1000; %Task Start Time  unit:s
SimulationTimeInSecond=SimulationTime/1000;



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


Instanz_Neu_DBDD(1:NumOfTask)=Sort_ResponstimeOfTask5(1);
Instanz=Instanz_Neu_DBDD(1:NumOfTask)/1000; %Responsetime unit:s
GesamtModel
set_param('GesamtModel','StartTime','0','StopTime','SimulationTimeInSecond');
set_param('GesamtModel','Solver','ode45')
set_param('GesamtModel','stopfcn','Evaluation')
sim('GesamtModel')
figure(10)
hold on
plot(RealSystemDrehzahl.time,RealSystemDrehzahl.signals.values,'r')
figure(11)
hold on
Latenz=DelayDensity_NewKurve_Oberschranken;
plot(1:NumOfTask,Latenz,'b')
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

fprintf('Bei DBDD:\n');
fprintf('Risetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',tr,adjust_time,overshoot,Latenz(1));
fprintf('Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
fprintf('DeltaLatenzDurchschnitt:%.3f Quadratisch:%.3f \n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
fprintf('************************ \n',tr,adjust_time,overshoot);


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
plot(1:NumOfTask,Latenz,'b')
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
%fprintf(fid,'P:%d J:%d D:%d WCET:%d TDMA_Slot:%d TDMA_Cycle:%d TDMA_Bandwidth:%d\n',Ereignis_Abtastzeit,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,TDMA_Slot,TDMA_Cycle,TDMA_Bandwidth);
fprintf(fid,'Maximal Latenzdicht: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Latenz);
fprintf(fid,'InstanzStartTime: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',time1);
fprintf(fid,'Instanz: \n%g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Instanz);
fprintf(fid,'\nRisetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',tr,adjust_time,overshoot,Latenz(1));
fprintf(fid,'Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_LargestJabs,Test_LargestJitae,Test_LargestJsqr);
fprintf(fid,'DeltaLatenzDurchschnitt:%.3f DeltaLatenzQuadratisch:%.3f\n',Test_LatenzDurchschnitt,Test_LatenzQuadratisch);
fprintf(fid,'**********************\n');

%Simulation
for i=1:NumOfTest
% TDMA_Phase=floor((TDMA_Cycle-TDMA_Slot)*rand(1)+0.5);
% AConcrete=DelayDensity_TDMAModel_AConcrete_Generator(Ereignis_Abtastzeit,Ereignis_Jitter,Ereignis_Delta,Ereignis_WCET,NumOfTask,SimulationTime);
% [ A_Concrete,B_Concrte,Bconcrete ]=DelayDensity_TDMAConcreteModel( AConcrete,Ereignis_WCET,TDMA_Bandwidth,TDMA_Cycle,TDMA_Slot,TDMA_Phase,SimulationTime);
% [StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( AConcrete,Bconcrete,B_Concrte,Ereignis_WCET,NumOfTask,SimulationTime);
% Latenzdicht = DelayDensity_GenerateDelayDensity( ResponstimeOfTask )/1000;
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
%     [StartTimeOfCase5,ResponstimeOfCase5]=DelayDensity_ResponseTimeAnalyse( A6_C,B4_C,B5_C,e5,simulationtime);
%     SortArray=sort(ResponstimeOfCase5,'descend');
%     Schranke=sort([Schranke(1,:);SortArray(1:10)],'descend');
%     Schranke(1,:)
    
%     figure(20);
%     hold on
%     DelayDensity_FPModel_Case=DelayDensity_GenerateDelayDensity(ResponstimeOfCase5,NumOfTask);
%     plot(1:NumOfTask,DelayDensity_FPModel_Case,'b-');
[StartTimeOfTask,ResponstimeOfTask]=DelayDensity_ResponseTimeAnalyse( A6_C,B4_C,B5_C,e5,simulationtime);
Latenzdicht = DelayDensity_GenerateDelayDensity( ResponstimeOfTask,NumOfTask )/1000;
Instanz=ResponstimeOfTask(1:NumOfTask)/1000;
time1=StartTimeOfTask(1:NumOfTask)/1000;
GesamtModel
set_param('GesamtModel','StartTime','0','StopTime','SimulationTimeInSecond');
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
%decide
if Test_Jabs(i)>Test_LargestJabs||Test_Jitae(i)>Test_LargestJitae||Test_Jabs(i)>Test_LargestJabs
    figure(10)
    hold on
    plot(RealSystemDrehzahl.time,RealSystemDrehzahl.signals.values,'r')
    figure(11)
    hold on
    plot(1:NumOfTask,Latenzdicht*1000,'r')
else
    figure(10)
    hold on
    plot(RealSystemDrehzahl.time,RealSystemDrehzahl.signals.values,'g')
    figure(11)
    hold on
    plot(1:NumOfTask,Latenzdicht*1000,'g')

end
fprintf('Simulation Case Num: %03d Risetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',i,tr,adjust_time,overshoot,Latenzdicht(1));
fprintf('Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_Jabs(i),Test_Jitae(i),Test_Jsqr(i));
fprintf('DeltaLatenzDurchschnitt:%.3f DeltaQuadratisch:%.3f\n',LatenzDurchschnitt(i),LatenzQuadratisch(i));
fprintf(fid,'Simulation Case Num: %03d\n',i);
fprintf(fid,'Latenzdicht: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Latenzdicht);
fprintf(fid,'InstanzStartTime: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',time1);
fprintf(fid,'Instanz: %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n',Instanz);
fprintf(fid,'\nRisetime:%.3f Adjusttime:%.3f Overshoot:%.3f%% MaxR:%.3f\n',tr,adjust_time,overshoot,Latenzdicht(1));
fprintf(fid,'Jabs:%.3f Jitae:%.3f Test_Jsqr:%.3f \n',Test_Jabs(i),Test_Jitae(i),Test_Jsqr(i));
fprintf(fid,'DeltaLatenzDurchschnitt:%.3f DeltaQuadratisch:%.3f\n',LatenzDurchschnitt(i),LatenzQuadratisch(i));
end