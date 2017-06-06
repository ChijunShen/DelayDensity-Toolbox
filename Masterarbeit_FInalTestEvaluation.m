%FinalTestEvaluation
clear
clc

%Task1

%Ohne Lastmoment
    %nach Periode
        %mit Einschwingung
%             load FinalTestTask1PeriodeOnheLastEinschwingung
%             mitLast=0;
        %ohne Einschwingung
%             load FinalTestTask1PeriodeOnheLastOnheEinschwingung
%             mitLast=0;
    %nach Totzone
         %mit Einschwingung
%             load FinalTestTask1TotzoneOhneLastEinschwingung  
%             mitLast=0;
         %ohne Einschwingung 
%             load FinalTestTask1TotzoneOhneLastOhneEinschwingung 
%             mitLast=0;
    %nach ISS
        %mit Einschwingung
%             load FinalTestTask1ISSOhneLastEinschwingung
%             mitLast=0;
        %ohne Einschwingung
%              load FinalTestTask1ISSOhneLastOhneEinschwingung 
%               mitLast=0;
    %nach Interrupt
        %mit Einschwingung
%              load FInalTestTask1InterruptOhneLastEinschwingung
%              mitLast=0;
        %ohne Einschwingung
%              load FinalTestTask1InterruptOhneLastOhneEinschwingung
%              mitLast=0;
%Mit Lastmoment
    %nach Periode
        %mit Einschwingung
%              load FInalTestTask1PeriodischeMitLastEinschwingung
%              mitLast=1;
        %ohne Einschwingung
%             load FinalTestTask1PeriodeMitLastOhneEinschwingung
%             mitLast=1;
    %nach Totzone
         %mit Einschwingung
%             load FinalTestTask1TotzoneMitLastEinschwingung  
%             mitLast=1;
         %ohne Einschwingung 
%             load FinalTestTask1TotzoneMitLastOhneEinschwingung
%             mitLast=1;
    %nach ISS
        %mit Einschwingung
%             load FinalTestTask1ISSMitLastEinschwingung 
%             mitLast=1;
        %ohne Einschwingung
            %load FInalTestTask1ISSMitLastOhneEinschwingung     
    %nach Interrupt
        %mit Einschwingung
%             load FInalTestTask1InterruptMitLastEinschwingung  
%             mitLast=1;
        %ohne Einschwingung
%             load FInalTestTask1InterruptMitLastOhneEinschwingung
%             mitLast=1;
        
%Task2
%Ohne Lastmoment
    %nach Periode
        %mit Einschwingung
%             load FinalTestTask2PeriodeohneLastEinschwingung
        %ohne Einschwingung
            %load FinalTestTask2PeriodeohneLastOhneEinschwingung
    %nach Totzone
         %mit Einschwingung
            %load FinalTestTask2TotzoneohneLastEinschwingung         
         %ohne Einschwingung 
            %load FinalTestTask2TotzoneohneLasohnetEinschwingung  
    %nach ISS
        %mit Einschwingung
            %load FinalTestTask2ISSOhneLastEinschwingung
        %ohne Einschwingung
            %load FinalTestTask2ISSOhneLastOhneEinschwingung         
    %nach Interrupt
        %mit Einschwingung
            %load FInalTestTask2InterruptOhneLastEinschwingung
        %ohne Einschwingung
%            load FInalTestTask2InterruptOhneLastOhneEinschwingung


%Mit Lastmoment
    %nach Periode
        %mit Einschwingung
%             load FInalTestTask2PeriodischeMitLastEinschwingung
%             mitLast=1;
        %ohne Einschwingung
            %load FInalTestTask2PeriodischeMitLastOhneEinschwingung
    %nach Totzone
         %mit Einschwingung
            %load FInalTestTask2TotzoneMitLastEinschwingung         
         %ohne Einschwingung 
            %load FInalTestTask2TotzoneMitLastOhneEinschwingung
    %nach ISS
        %mit Einschwingung
            %load FInalTestTask2ISSMitLastEinschwingung
        %ohne Einschwingung
%            load FInalTestTask2ISSMitLastOhneEinschwingung 
    %nach Interrupt
        %mit Einschwingung
            %load FInalTestTask2InterruptMitLastEinschwingung
        %ohne Einschwingung
            %load FInalTestTask2InterruptMitLastOhneEinschwingung
            
NumOfSimulation=length(Drehzahl_Sim);


%Bewertung


%ohne Lastmoment
if mitLast==0
    StarttimeIndex=1;%0s
    figure(1)
    hold on
    plot(Drehzahl_DBDD.time,Drehzahl_DBDD.signals.values,'k'); 
    plot(Drehzahl_NeuKurve.time,Drehzahl_NeuKurve.signals.values,'r'); 
    for i=1:NumOfSimulation
        plot(Drehzahl_Sim(i).time,Drehzahl_Sim(i).signals.values,'g'); 
    end
    plot(Drehzahl_DBDD.time,Drehzahl_DBDD.signals.values,'k'); 
    plot(Drehzahl_NeuKurve.time,Drehzahl_NeuKurve.signals.values,'r'); 
    legend('nach DBDD','nach neue Kurve','Simulation');
    xlabel('Zeit[s]');
    ylabel('Drehzahl[rad/s]')
    
     for i=1:NumOfSimulation
        Drehzahl=Drehzahl_Sim(i);
        %max wert finden
        MaxWert=0;
        LengthOfArray=length(Drehzahl.signals.values);
        for j=StarttimeIndex:LengthOfArray
            if(MaxWert<=Drehzahl.signals.values(j))
                MaxWert=Drehzahl.signals.values(j);
            end
        end
        overshoot=(MaxWert-sollwert)/sollwert*100;   %overshoot
        OvershootSim(i)=overshoot;       
    end
    Sum=0;
    Drehzahl=Drehzahl_DBDD;
    
    MaxWert=0;
    for j=StarttimeIndex:length(Drehzahl.signals.values)
        if(MaxWert<=Drehzahl.signals.values(j))
            MaxWert=Drehzahl.signals.values(j);
        end                  
    end
    overshoot=(MaxWert-sollwert)/sollwert*100;   %overshoot
    OvershootSchatz_DBDD=overshoot;
    
    MaxWert=0;
    Drehzahl=Drehzahl_NeuKurve;
    for j=StarttimeIndex:length(Drehzahl.signals.values)
        if(MaxWert<=Drehzahl.signals.values(j))
            MaxWert=Drehzahl.signals.values(j);
        end                  
    end
    overshoot=(MaxWert-sollwert)/sollwert*100;   %overshoot
    OvershootSchatz=overshoot;   

%     for i=1:NumOfSimulation
%         Drehzahl=Drehzahl_Sim(i);
%         % Rise time
%         yr= 0.99*sollwert;
%         rise_idx=1;
%         adjust_idx=length(Drehzahl.signals.values);
%         while 1
%             if(Drehzahl.signals.values(rise_idx,1)>=yr)
%                 break;
%             end
%             if rise_idx==adjust_idx 
%                 fprintf('Evaluation Error: System not arrive to Sollwert. Maybe number of tasks are set too low');
%             end
%             rise_idx=rise_idx+1;
%         end
%         tr= Drehzahl.time(rise_idx);
%         maxy=max(Drehzahl.signals.values);     
%         overshoot=(maxy(1)-sollwert)/sollwert*100;   %overshoot
%         while(Drehzahl.signals.values(adjust_idx)>=0.999*yr)&&(Drehzahl.signals.values(adjust_idx)<1.05*yr)
%         adjust_idx=adjust_idx-1;
%         end
%         adjust_time=Drehzahl.time(adjust_idx); %adjusttime
%         while 1
%             if(Drehzahl.signals.values(rise_idx,1)>=yr)
%                 break;
%             end
%             rise_idx=rise_idx+1;
%         end
%         tr= Drehzahl.time(rise_idx);
% 
%         OvershootSim(i)=overshoot;
%     end
    %Jabs 0.001
    ZeitAbstand=0.001;
    SollDrehzahl=10;
    for i=1:NumOfSimulation
        Sum=0;
        Drehzahl=Drehzahl_Sim(i);
        for j=1:length(Drehzahl.signals.values)
             value=abs(Drehzahl.signals.values(j)-SollDrehzahl)*ZeitAbstand;
             Sum=Sum+value;                    
        end
        JabsSim(i)=Sum;                
    end            
    %Jitae
    ZeitAbstand=0.001;
    SollDrehzahl=10;
    for i=1:NumOfSimulation
        Sum=0;
        Drehzahl=Drehzahl_Sim(i);
        for j=1:length(Drehzahl.signals.values)
             value=abs(Drehzahl.signals.values(j)-SollDrehzahl)*Drehzahl.time(j)*ZeitAbstand;
             Sum=Sum+value;                    
        end
        JitaeSim(i)=Sum;                
    end
    %Jsqr
    ZeitAbstand=0.001;
    SollDrehzahl=10;
    for i=1:NumOfSimulation
        Sum=0;
        Drehzahl=Drehzahl_Sim(i);
        for j=1:length(Drehzahl.signals.values)
             value=(Drehzahl.signals.values(j)-SollDrehzahl)*(Drehzahl.signals.values(j)-SollDrehzahl)*ZeitAbstand;
             Sum=Sum+value;                    
        end
        JsqrSim(i)=Sum;                
    end 
    %Jabs
    figure(2)
    subplot(2,2,1)
    hist(JabsSim,10)
    xlabel('Jabs')
    ylabel('Anzahl')
    line([JabsSchatz JabsSchatz], [0 30],'Color','r')
    line([JabsSchatz_DBDD JabsSchatz_DBDD], [0 30],'Color','k')
    %Jitae
    subplot(2,2,2)
    hist(JitaeSim,10)
    xlabel('Jitae')
    ylabel('Anzahl')
    line([JitaeSchatz JitaeSchatz], [0 30],'Color','r')
    line([JitaeSchatz_DBDD JitaeSchatz_DBDD], [0 30],'Color','k')
    %Jsqr
    subplot(2,2,3)
    hist(JsqrSim,10)
    xlabel('Jsqr')
    ylabel('Anzahl')
    line([JsqrSchatz JsqrSchatz], [0 30],'Color','r')
    line([JsqrSchatz_DBDD JsqrSchatz_DBDD], [0 30],'Color','k')
    %uberschwingung
    subplot(2,2,4)
    hist(OvershootSim,10)
    xlabel('Uberschwingweite[%]')
    ylabel('Anzahl')
    line([OvershootSchatz OvershootSchatz], [0 30],'Color','r')
    line([OvershootSchatz_DBDD OvershootSchatz_DBDD], [0 30],'Color','k')
end

%mit Lastmoment ausser Interrupt
%15s index 15248
if mitLast==1
    StarttimeIndex=15248;%15s
    figure(1)
    hold on

    plot(Drehzahl_DBDD.time,Drehzahl_DBDD.signals.values,'k'); 
    plot(Drehzahl_NeuKurve.time,Drehzahl_NeuKurve.signals.values,'r'); 
    for i=1:NumOfSimulation
        plot(Drehzahl_Sim(i).time,Drehzahl_Sim(i).signals.values,'g'); 
    end
    plot(Drehzahl_DBDD.time,Drehzahl_DBDD.signals.values,'k'); 
    plot(Drehzahl_NeuKurve.time,Drehzahl_NeuKurve.signals.values,'r'); 
    legend('nach DBDD','nach neue Kurve','Simulation');
    xlabel('Zeit[s]');
    ylabel('Drehzahl[rad/s]')

    for i=1:NumOfSimulation
        Drehzahl=Drehzahl_Sim(i);
        %max wert finden
        MaxWert=0;
        LengthOfArray=length(Drehzahl.signals.values);
        for j=StarttimeIndex:LengthOfArray
            if(MaxWert<=Drehzahl.signals.values(j))
                MaxWert=Drehzahl.signals.values(j);
            end
        end
        overshoot=(MaxWert-sollwert)/sollwert*100;   %overshoot
        OvershootSim(i)=overshoot;       
    end
    Sum=0;
    MaxWert=0;
    Drehzahl=Drehzahl_DBDD;
    for j=StarttimeIndex:length(Drehzahl.signals.values)
        if(MaxWert<=Drehzahl.signals.values(j))
            MaxWert=Drehzahl.signals.values(j);
        end                  
    end
    overshoot=(MaxWert-sollwert)/sollwert*100;   %overshoot
    OvershootSchatz_DBDD=overshoot;
    
    MaxWert=0;
    Drehzahl=Drehzahl_NeuKurve;
    for j=StarttimeIndex:length(Drehzahl.signals.values)
        if(MaxWert<=Drehzahl.signals.values(j))
            MaxWert=Drehzahl.signals.values(j);
        end                  
    end
    overshoot=(MaxWert-sollwert)/sollwert*100;   %overshoot
    OvershootSchatz=overshoot;   
    
    
    %Jabs 0.001
    ZeitAbstand=0.001;
    SollDrehzahl=10;
    for i=1:NumOfSimulation
        Sum=0;
        Drehzahl=Drehzahl_Sim(i);
        for j=StarttimeIndex:length(Drehzahl.signals.values)
             value=abs(Drehzahl.signals.values(j)-SollDrehzahl)*ZeitAbstand;
             Sum=Sum+value;                    
        end
        JabsSim(i)=Sum;                
    end

    Sum=0;
    Drehzahl=Drehzahl_DBDD;
    for j=StarttimeIndex:length(Drehzahl.signals.values)
         value=abs(Drehzahl.signals.values(j)-SollDrehzahl)*ZeitAbstand;
         Sum=Sum+value;                    
    end
    JabsSchatz_DBDD=Sum;

    Sum=0;
    Drehzahl=Drehzahl_NeuKurve;
    for j=StarttimeIndex:length(Drehzahl.signals.values)
         value=abs(Drehzahl.signals.values(j)-SollDrehzahl)*ZeitAbstand;
         Sum=Sum+value;                    
    end
    JabsSchatz=Sum;   
    %Jitae
    ZeitAbstand=0.001;
    SollDrehzahl=10;
    for i=1:NumOfSimulation
        Sum=0;
        Drehzahl=Drehzahl_Sim(i);
        for j=StarttimeIndex:length(Drehzahl.signals.values)
             value=abs(Drehzahl.signals.values(j)-SollDrehzahl)*Drehzahl.time(j)*ZeitAbstand;
             Sum=Sum+value;                    
        end
        JitaeSim(i)=Sum;                
    end
    Sum=0;
    Drehzahl=Drehzahl_DBDD;
    for j=StarttimeIndex:length(Drehzahl.signals.values)
         value=abs(Drehzahl.signals.values(j)-SollDrehzahl)*Drehzahl.time(j)*ZeitAbstand;
         Sum=Sum+value;                    
    end
    JitaeSchatz_DBDD=Sum;

    Sum=0;
    Drehzahl=Drehzahl_NeuKurve;
    for j=StarttimeIndex:length(Drehzahl.signals.values)
         value=abs(Drehzahl.signals.values(j)-SollDrehzahl)*Drehzahl.time(j)*ZeitAbstand;
         Sum=Sum+value;                    
    end
    JitaeSchatz=Sum;   
    %Jsqr
    ZeitAbstand=0.001;
    SollDrehzahl=10;
    for i=1:NumOfSimulation
        Sum=0;
        Drehzahl=Drehzahl_Sim(i);
        for j=StarttimeIndex:length(Drehzahl.signals.values)
             value=(Drehzahl.signals.values(j)-SollDrehzahl)*(Drehzahl.signals.values(j)-SollDrehzahl)*ZeitAbstand;
             Sum=Sum+value;                    
        end
        JsqrSim(i)=Sum;                
    end 
    Sum=0;
    Drehzahl=Drehzahl_DBDD;
    for j=StarttimeIndex:length(Drehzahl.signals.values)
         value=(Drehzahl.signals.values(j)-SollDrehzahl)*(Drehzahl.signals.values(j)-SollDrehzahl)*ZeitAbstand;
         Sum=Sum+value;                    
    end
    JsqrSchatz_DBDD=Sum;

    Sum=0;
    Drehzahl=Drehzahl_NeuKurve;
    for j=StarttimeIndex:length(Drehzahl.signals.values)
         value=(Drehzahl.signals.values(j)-SollDrehzahl)*(Drehzahl.signals.values(j)-SollDrehzahl)*ZeitAbstand;
         Sum=Sum+value;                    
    end
    JsqrSchatz=Sum;   
    %Jabs
    figure(2)
    subplot(4,1,1)
    hist(JabsSim,10)
    xlabel('Jabs')
    ylabel('Anzahl')
    line([JabsSchatz JabsSchatz], [0 40],'Color','r')
    line([JabsSchatz_DBDD JabsSchatz_DBDD], [0 40],'Color','k')
    %Jitae
    subplot(4,1,2)
    hist(JitaeSim,10)
    xlabel('Jitae')
    ylabel('Anzahl')
    line([JitaeSchatz JitaeSchatz], [0 40],'Color','r')
    line([JitaeSchatz_DBDD JitaeSchatz_DBDD], [0 40],'Color','k')
    %Jsqr
    subplot(4,1,3)
    hist(JsqrSim,10)
    xlabel('Jsqr')
    ylabel('Anzahl')
    line([JsqrSchatz JsqrSchatz], [0 40],'Color','r')
    line([JsqrSchatz_DBDD JsqrSchatz_DBDD], [0 40],'Color','k')
    %uberschwingung
    subplot(4,1,4)
    hist(OvershootSim,10)
    xlabel('Uberschwingweite[%]')
    ylabel('Anzahl')
    line([OvershootSchatz OvershootSchatz], [0 40],'Color','r')
    line([OvershootSchatz_DBDD OvershootSchatz_DBDD], [0 40],'Color','k')
end

