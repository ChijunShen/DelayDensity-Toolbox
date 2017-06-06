function [starttime,responsetime,RepeatNumber] = DelayDensity_ResponseTimeAnalyse( AU,BL,B_L,wcet,simulationtime)

%Sigma B_L-B_l
for i=1:1:(simulationtime+1)
    if(AU(i)<0)
        AU(i)=0;
    end
    if(BL(i)<0)
        BL(i)=0;
    end
    if(B_L(i)<0)
        B_L(i)=0;
    end
end
sigma(1)=BL(1)-B_L(1);
if sigma(1)<0
    sigma(1)=0;
end
for i=2:1:(simulationtime+1)
    temp=BL(i)-B_L(i);
    if temp<sigma(i-1)
        temp=sigma(i-1);
    end
    sigma(i)=temp;
end
% figure(3)
% hold on
% plot(0:1:500,AU(1:501),'b');
% % plot(0:1:simulationtime,BL,'y');
% plot(0:1:500,sigma(1:501),'r');
% xlabel('Zeit[ms]')
% ylabel('Ressource Einheit')
% legend('obere eingehende Ankunftskurve','zur Verfugung stehende Resourcen')
% pause



%Responstime Berechnen
% for i=1:NumOfTask;
SumOfTasks=0;
i=1;
while 1
    %inverse au finden
    for j=0:1:simulationtime
        if AU(j+1)==i*wcet;
            if(j==0)
                time1(1)=0;
                break;
            else
                time1(i)=j-1;%uberlegen
                break;
            end
        end
    end 
    %inverse sigma finden
    for j=0:1:simulationtime
        if sigma(j+1)==i*wcet;
            time2(i)=j;
            SumOfTasks=SumOfTasks+1;
            break;
        elseif sigma(j+1)>i*wcet
            fprintf('DelayDensity_ResponseTimeAnalyse warning: interpolation be used!\n');
            time2(i)=j-1+(i*wcet-sigma(j))/(sigma(j+1)-sigma(j));
            SumOfTasks=SumOfTasks+1;
            break;
        end
        %if(j==simulationtime)
            %fprintf('DelayDensity_ResponseTimeAnalyse warning: inverse sigma cannot be found!\n');
        %end
    end
    if j==simulationtime
        break;
    end
%     if SumOfTasks==NumOfTask+1
%         break;
%     end
    responsetime(i)=time2(i)-time1(i);
    i=i+1;
end
starttime=time1;



%schnitt punkt suchen
RepeatNumber=0;
for i=1:simulationtime+1
    if sigma(i)>=AU(i) && sigma(i)~=0
%         sigma(i);
%         AU(i);
        RepeatNumber=floor(sigma(i)/wcet);
        if RepeatNumber==0
            RepeatNumber=1;
        end
%         fprintf('DelayDensity_ResponseTimeAnalyse Schnittpunkt gefunden zwischen Zeitpunkt %d and %d RepeatNum:%d\n ',i-1,i,RepeatNumber);
        break;       
    end
end
if RepeatNumber==0
%     figure(88);
%     hold on;
%     plot(0:simulationtime,sigma,'b');
%     plot(0:simulationtime,AU,'r');
    fprintf('DelayDensity_ResponseTimeAnalyse Error: Schnittpunkt nicht gefunden');
end
end