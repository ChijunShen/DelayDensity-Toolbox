%Oberschranken von drei Kurven testen
%FP
clear;
clc;
%hier kann man die Parameter von Task Set einstellen
%2 Prioritat:Task1>Task2
p1=70;j1=80;d1=1;e1max=26;ph1max=0;e1=10;
p2=100;j2=120;d2=1;e2max=62;ph2max=p2;e2=20;
% for e1=10:e1max
% for e2=40:e2max
% FileName=sprintf('FP_P1_%d_P2_%d_e1_%d_e2_%d',p1,p2,e1,e2);
% fid=fopen(FileName,'w');
% fprintf(fid,'FP_P1_%d_P2_%d_e1_%d_e2_%d\n',p1,p2,e1,e2);
% U=e1/p1+e2/p2;%Auslastung
% fprintf(fid,'Auslastung:%d\n',U);
% fprintf(fid,'Simulation Begions:\n');

%hier kann man die Parameter von FP einstellen
CPU_Bandwidth=1;%resource unit/s
NumOfTask=20;
simulationtime=4000;%time unit

%dr+ berechnen
[ A1_U,A1_L,B1_U,B1_L,A1U,A1L,B1U,B1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
[ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);

%Analysieren
[StartTimeOfTask1,ResponstimeOfTask1]=DelayDensity_ResponseTimeAnalyse( A1U,B1L,B1_L,e1,simulationtime);
[StartTimeOfTask2,ResponstimeOfTask2,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A2U,B1_L,B2_L,e2,simulationtime);

%ploten
% DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask1,ResponstimeOfTask1,10,2,1,simulationtime);
% DelayDensity_ResponseTimeAnalysePlot( StartTimeOfTask2,ResponstimeOfTask2,10,2,2,simulationtime);
% DelayDensity_ResponseTimeAnalysePlot2Tasks( StartTimeOfTask1,ResponstimeOfTask1,StartTimeOfTask2,ResponstimeOfTask2,1,simulationtime);
% ResultOfTask = DelayDensity_FeasibleTest( ResponstimeOfTask2,p2);
% if ResultOfTask==0
%     fprintf('System by dr+ is not Feasible\n')
% end

DelayDensity_FPModel=DelayDensity_GenerateDelayDensity(ResponstimeOfTask2,NumOfTask);
Latenz_DBDD(1:NumOfTask)=(1:NumOfTask)*DelayDensity_FPModel(1);
figure(20);
hold on
plot(1:NumOfTask,DelayDensity_FPModel,'r');%kurve DFDD
plot(1:NumOfTask,Latenz_DBDD,'k');%kurve DBDD

%kurve 1
if RepeatInstantNum~=0
    for i=1:length(ResponstimeOfTask2)
        RepeatIndex=mod(i,RepeatInstantNum);
        if RepeatIndex==0
            RepeatIndex=RepeatInstantNum;
        end
        Instanz_Neu(i)=ResponstimeOfTask2(RepeatIndex); 
    end
%     for i=1:NumOfTask
%         RepeatIndex=mod(i,RepeatInstantNum);
%         Instanz_Neu(i)=ResponstimeOfTask2(RepeatIndex+1); 
%     end
    DelayDensity_FPModel_Neu=DelayDensity_GenerateDelayDensity(Instanz_Neu,NumOfTask);
%     figure(20);
%     hold on
     plot(1:NumOfTask,DelayDensity_FPModel_Neu,'m');
end



%kurve2
if RepeatInstantNum~=0
    for i=1:RepeatInstantNum %RepeatInstantNum herstellen
        for j=1:NumOfTask
            index=mod(j,i);
            if index==0
                index=i;
            end
            Array(i,j)=ResponstimeOfTask2(index);
        end
        DelayDensity_NewKurve(i,:)=DelayDensity_GenerateDelayDensity(Array(i,:),NumOfTask);%Falsh geschrieben:Array
    end

    DelayDensity_NewKurve_Oberschranken=DelayDensity_NewKurve(1,:);
    for i=2:RepeatInstantNum
        DelayDensity_NewKurve_Oberschranken=DelayDensity_MaxArray(DelayDensity_NewKurve_Oberschranken,DelayDensity_NewKurve(i,:));
    end
    plot(1:NumOfTask,DelayDensity_NewKurve_Oberschranken,'y');
end







% % simulation
% TestBestanden=1;
% NichtBeIndex=0;
% figureIndex=100;
% allIndex=1000;
% for i=0:ph1max
%     for j=0:ph2max
% %         for k=1:10000;
%             ph1=i;
%             ph2=j;
%              %Simulation
%              A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,simulationtime);
%             [A1_C,B1_C,B1C]=DelayDensity_FPConcreteModelInit( A1C,CPU_Bandwidth,simulationtime);
%             A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,simulationtime);
%             [A2_C,B2_C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,simulationtime);
% %             A3C=DelayDensity_AConcrete_Generator(p3,j3,d3,ph3,e3,NumOfTask,simulationtime);
% %             [A3_C,B3_C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);
%             
%             [StartTimeOfCase1,ResponstimeOfCase1]=DelayDensity_ResponseTimeAnalyse( A1C,B1C,B1_C,e1,simulationtime);
%             [StartTimeOfCase2,ResponstimeOfCase2]=DelayDensity_ResponseTimeAnalyse( A2C,B1_C,B2_C,e2,simulationtime);
% %             [StartTimeOfCase,ResponstimeOfCase]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,NumOfTask,simulationtime);
%             
% 
%             ResultOfTask = DelayDensity_FeasibleTest( ResponstimeOfCase2,p2);%deadline not considered
%             %ResultOfTask3=DelayDensity_FeasibleTest(ResponstimeOfCase,p3);
%             
%             
%             fprintf(fid,'study case: ph1:%d ph2:%d\n',i,j);
%             fprintf(fid,'StartTimeOfCase1: %g %g %g %g %g %g %g %g %g %g\n',StartTimeOfCase1);
%             fprintf(fid,'ResponstimeOfCase1: %g %g %g %g %g %g %g %g %g %g\n',ResponstimeOfCase1);
%             fprintf(fid,'StartTimeOfCase2: %g %g %g %g %g %g %g %g %g %g\n',StartTimeOfCase2);
%             fprintf(fid,'ResponstimeOfCase2: %g %g %g %g %g %g %g %g %g %g\n',ResponstimeOfCase2);
%             
%             
%             if(ResultOfTask)
%                 TestCase_DelayDensity_FPModel=DelayDensity_GenerateDelayDensity(ResponstimeOfCase2,NumOfTask); 
% %                 figure(20);
% %                 hold on
%                  if ~DelayDensity_TestUpperBound(DelayDensity_NewKurve_Oberschranken,TestCase_DelayDensity_FPModel)
%                      TestBestanden=0;
%                      NichtBeIndex=ph1*100+ph2;
% %                     plot(1:NumOfTask,TestCase_DelayDensity_FPModel,'r--'); 
% %                     allIndex=allIndex+1;
% %                     figureIndex=figureIndex+1;
%                else
% %                     plot(1:NumOfTask,TestCase_DelayDensity_FPModel,'k--');
%                 end
%                 
%             end
% %             fprintf('procent: %3.2f\n',j/ph2max);
% %         end
%     end
%   end
% % 
%     if TestBestanden==1
%         %fprintf('study case: e1:%d e2:%d\n passed\n',e1,e2)
%     else
%         fprintf('study case: e1:%d e2:%d\n not passed Index:%d \n',i,j,NichtBeIndex)
%     end
%     fclose(fid);
% end
% end
