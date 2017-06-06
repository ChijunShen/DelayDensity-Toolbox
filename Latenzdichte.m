NumOfEvents=length(Event.time);
figure(1);
i=1;
%Summe Responstime
for i=1:NumOfEvents
    if(i==1)
        DelayOfEvents(i)=Delay.signals.values(1);
    else
        DelayOfEvents(i)=Delay.signals.values(floor(Event.time(i)+1));
    end
end
for i=1:NumOfEvents
    SumOfEvent(i)=0;
    for j=1:i
        SumOfEvent(i)=SumOfEvent(i)+DelayOfEvents(j);
    end
end
%Max LatenzDichte Formula: sup{f(delta+lamda)-f(delta)}
for i=1:NumOfEvents-1
    Latenz(i)=0;
    Max=0;
    for j=1:NumOfEvents
        if(j+i>NumOfEvents) 
            break;
        end
        Temp=SumOfEvent(i+j)-SumOfEvent(j);
        if(Temp>Max)
            Max=Temp;
        end
    end
    Latenz(i)=Max;
end
%plot Sample
ResponsetimeIndex=1:NumOfEvents;
subplot(2,1,1);
hold on
for i=ResponsetimeIndex
    plot([i,i],[0,DelayOfEvents(i)]);
end
title('response time');
xlabel('k');
ylabel('r(k)');
%plot cumulative sum of delay
%subplot(3,1,2);
%hold on
%for i=ResponsetimeIndex
%    plot([i,i],[0,SumOfEvent(i)]);
%end
%title('sum of delays');
%xlabel('k');
%ylabel('sum(k)');
%plot Latenzdichte
LatenzIndex=1:NumOfEvents-1;
subplot(2,1,2);
hold on
for i=LatenzIndex
    plot([i,i],[0,Latenz(i)]);
end
%plot([0,NumOfEvents-1],[0,(NumOfEvents-1)*Latenz(1)],'r');
title('Maximum Delay Density');
xlabel('Delta');
ylabel('Density(k)');



%DelayOfEvents=Delay.signals.values(floor(Event.time+2))