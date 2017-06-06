function [ DeltaOvershoot,DeltaJabs ] = DelayDensity_FP_Simulation( simulationtime,NumOfTask,NumOfSimulation,CPU_Bandwidth,p1,j1,d1,e1,ph1,p2,j2,d2,e2,ph2,p3,j3,d3,e3,ph3)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    warning off;
    Test_Jitae_Max=0;
    global time1
    global Instanz
    global Drehzahl
    global Drehzahl
    global tr
    global adjust_time
    global Jabs
    global Jitae
    global Jsqr
    global overshoot
    [ A1_U,A1_L,B1_U,B1_L,A1U,A1L ] = DelayDensity_FPModelInit( p1,j1,d1,e1,CPU_Bandwidth,simulationtime);
    [ A2_U,A2_L,B2_U,B2_L,A2U,A2L ] = DelayDensity_ConnectWithFPModel( B1_U,B1_L,p2,j2,d2,e2,simulationtime);
    [ A3_U,A3_L,B3_U,B3_L,A3U,A3L ] = DelayDensity_ConnectWithFPModel( B2_U,B2_L,p3,j3,d3,e3,simulationtime);
    [WorstStartTimeOfTask,WorstResponstimeOfTask,RepeatInstantNum]=DelayDensity_ResponseTimeAnalyse( A3U,B2_L,B3_L,e3,simulationtime);
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
%         GesamtModel    
    set_param('GesamtModel','StartTime','0','StopTime','50');
    set_param('GesamtModel','Solver','ode45')
    set_param('GesamtModel','stopfcn','Evaluation')
    sim('GesamtModel')
    
%     TestTask_LangstRiseTime=tr;
%     TestTask_LangstAdjustTime=adjust_time;
    TestTask_LargestJabs=max(Jabs.signals.values); 
%     TestTask_LargestJitae=max(Jitae.signals.values); 
%     TestTask_LargestJsqr=max(Jsqr.signals.values);
    TestTask_Overshoot=overshoot;
    
    Test_DeltaJabs_Max=-50000;
    Test_DeltaOvershoot=-50000;
    
%     fprintf('pause')
%     pause

    
    
    
    
    for i=1:NumOfSimulation
        A1C=DelayDensity_AConcrete_Generator(p1,j1,d1,ph1,e1,simulationtime);
        [A1_C,B1_C,B1C]=DelayDensity_FPConcreteModelInit( A1C,CPU_Bandwidth,simulationtime);
        A2C=DelayDensity_AConcrete_Generator(p2,j2,d2,ph2,e2,simulationtime);
         [A2_C,B2_C]=DelayDensity_ConnectWithConcreteFPModel( B1_C,A2C,simulationtime);
        A3C=DelayDensity_AConcrete_Generator(p3,j3,d3,ph3,e3,simulationtime);
        
%         p3
%         j3
%         d3
%         ph3
%         e3
%         figure(1)
%         hold on
%         plot(0:simulationtime,A3C,'r');
%         pause
        
        [A3_C,B3_C]=DelayDensity_ConnectWithConcreteFPModel( B2_C,A3C,simulationtime);
        

    %     [StartTimeOfCase1,ResponstimeOfCase1]=DelayDensity_ResponseTimeAnalyse( A1C,B1C,B1_C,e1,simulationtime);
    %     [StartTimeOfCase2,ResponstimeOfCase2]=DelayDensity_ResponseTimeAnalyse( A2C,B1_C,B2_C,e2,simulationtime);
%         plot(0:simulationtime,B2_C,'b');
%         pause
        [StartTimeOfCase3,ResponstimeOfCase3]=DelayDensity_ResponseTimeAnalyse( A3C,B2_C,B3_C,e3,simulationtime);
        
%         %plot
%         figure(1);
%         subplot(2,1,1);
%         %plot(1:8,ResponstimeOfCase3(1:8));
%         hold on
%         plot([0,0],[0,0]);
%         for j=1:8
%             plot([j,j],[0,ResponstimeOfCase3(j)]);
%         end
%         xlabel('k');
%         ylabel('Latenz')
%         subplot(2,1,2);
%         hold on
%         plot([0,0],[0,0]);
%         DelayDensity=DelayDensity_GenerateDelayDensity(ResponstimeOfCase3(1:8),8);
%         %plot(1:8,DelayDensity);
%         for j=1:8
%             plot([j,j],[0,DelayDensity(j)]);
%         end
%         xlabel('Intervalbereich')
%         ylabel('Latenzdichte')
%         print -depsc latenzdichtebeispiel
%         pause
        
        
        Instanz=ResponstimeOfCase3(1:NumOfTask)/1000;
        time1=StartTimeOfCase3(1:NumOfTask)/1000;
%         GesamtModel
        set_param('GesamtModel','StartTime','0','StopTime','50');
        set_param('GesamtModel','Solver','ode45')
%         set_param('GesamtModel','stopfcn','Evaluation')
        sim('GesamtModel')
        %Latenzdicht
        %Instanz
%         TestCase_RiseTime(i)=tr;
%         TestCase_AdjustTime(i)=adjust_time;
        TestCase_Jabs=max(Jabs.signals.values); 
%         TestCase_Jitae(i)=max(Jitae.signals.values); 
%         TestCase_Jsqr(i)=max(Jsqr.signals.values);
        TestCase_Overshoot=overshoot;
        %LatenzDurchschnitt: 1/k Summe(dri-dri-1) LatenzQuadratisch:Summe(dri-dri-1)`2
%         LatenzDurchschnitt(i)=Latenzdicht(1);
%         LatenzQuadratisch(i)=Latenzdicht(1)*Latenzdicht(1);
%         for k=2:NumOfTask-1
%             LatenzDurchschnitt(i)=LatenzDurchschnitt(i)+Latenzdicht(k)-Latenzdicht(k-1);
%             LatenzQuadratisch(i)=LatenzQuadratisch(i)+(Latenzdicht(k)-Latenzdicht(k-1))^2;
%         end
%         LatenzDurchschnitt(i)=LatenzDurchschnitt(i)/(NumOfTask-1);
%         LatenzQuadratisch(i)=LatenzQuadratisch(i);
%         if(TestCase_Jabs-TestTask_LargestJabs>Test_DeltaJabs_Max) Test_DeltaJabs_Max=TestCase_Jabs-TestTask_LargestJabs;
        if(TestCase_Overshoot-TestTask_Overshoot>Test_DeltaOvershoot)
            Test_DeltaOvershoot=TestCase_Overshoot-TestTask_Overshoot;
            Test_DeltaJabs_Max=TestCase_Jabs-TestTask_LargestJabs;
        end
    end
        
        DeltaOvershoot=Test_DeltaOvershoot;
        DeltaJabs=Test_DeltaJabs_Max;
end

