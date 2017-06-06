function [ Instanz,Latenz ] = LatenzInstanzErzeuger( MaximalLatezdichte,BCET,WCET,Anzahl,Options)
%LatenzInstanzErzeuger  Frank Shen Uni Ulm
%Eingabe:
%MaximalLatezdichte: das Maximale Latenzdichte
%BCET:Best Case Execution Time
%WCET:Worst Case Execution Time
%Anzahl: Anzahl ausgebende Instanz
%Options: 1:unter Grenze 2:Oben Grenze 3:Zwischen
LatenzdichteToleranz=0;%grosser als 9 Prozent Latenz
while 1
%Instanz Erzeugen
DeltaLength=WCET-BCET;
Instanz=zeros(1,Anzahl);
for i=1:Anzahl
    Instanz(i)=BCET+DeltaLength*rand(1);
end
%Summe Responstime
NumOfInstanz=Anzahl;
SumOfEvent=zeros(1,Anzahl);
for i=1:NumOfInstanz
    SumOfEvent(i)=0;
    for j=1:i
        SumOfEvent(i)=SumOfEvent(i)+Instanz(j);
    end
end
%Max LatenzDichte Formula: sup{f(delta+lamda)-f(lamda)}
Latenz=zeros(1,Anzahl);
for i=1:NumOfInstanz-1
    Latenz(i)=0;
    Max=SumOfEvent(i);
    for j=1:NumOfInstanz
        if(j+i>NumOfInstanz) 
            break;
        end
        Temp=SumOfEvent(i+j)-SumOfEvent(j);
        if(Temp>Max)
            Max=Temp;
        end
    end
    Latenz(i)=Max;
end
Latenz(Anzahl)=SumOfEvent(Anzahl);
%Veryfy Instanz
IstOk=1;
for i=1:NumOfInstanz
    if(Options==1)%unter Grenze
        if(Latenz(i)>MaximalLatezdichte(i)||Latenz(i)<=LatenzdichteToleranz*MaximalLatezdichte(i))
            IstOk=0;
        end
    end
    if(Options==2)
            if(Latenz(i)<MaximalLatezdichte(i))
                IstOk=0;
            end
    end
    if(Options==3)
        IstOk=0;
        if(Latenz(i)<MaximalLatezdichte(i)&&Latenz(i-1)>MaximalLatezdichte(i-1))
            IstOk=1;
            break;
        end
    end
end
if(IstOk==1) 
    break;
end
end

