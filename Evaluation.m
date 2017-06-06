% figure
% hold on
% sollwert=8;
% plot(Drehzahl.time,Drehzahl.signals.values(:,1),'b-',Drehzahl.time,Drehzahl.signals.values(:,2),'r:');
% xlabel('Time(sec)')
% ylabel('Speed(rad/s)')
% legend('ereignis basiert Reglung','konventionell PID Reglung')

% Rise time
yr= 0.99*sollwert;
%rise_idx= min(find(Drehzahl.signals.values(:,1)>=yr))
rise_idx=1;
adjust_idx=length(Drehzahl.signals.values);
while 1
    if(Drehzahl.signals.values(rise_idx,1)>=yr)
        break;
    end
    if rise_idx==adjust_idx 
        fprintf('Evaluation Error: System not arrive to Sollwert. Maybe number of tasks are set too low');
    end
    rise_idx=rise_idx+1;
end
tr= Drehzahl.time(rise_idx);
maxy=max(Drehzahl.signals.values);     %求响应的最大值
overshoot=(maxy(1)-sollwert)/sollwert*100;   %求取超调量
while(Drehzahl.signals.values(adjust_idx)>=0.999*yr)&&(Drehzahl.signals.values(adjust_idx)<1.05*yr)
adjust_idx=adjust_idx-1;
end
adjust_time=Drehzahl.time(adjust_idx); %求调节时间
% plot( [tr tr], [0 yr],'r--');
% % Draw vertical line at tr
% str= sprintf('tr=\n%3.2f s', tr);
% % Let user label tr
% gtext( str );
% rise_idx=1;
while 1
    if(Drehzahl.signals.values(rise_idx,1)>=yr)
        break;
    end
    rise_idx=rise_idx+1;
end
tr= Drehzahl.time(rise_idx);
% plot( [tr tr], [0 yr],'b--');
% % Draw vertical line at tr
% str= sprintf('tr=\n%3.2f s', tr);
% % Let user label tr
% gtext( str );