function [ A_U,A_L,B_U,B_L,AU,AL] = DelayDensity_ConnectWithFPModel( BU,BL,period,jitter,delta,wcet,simulationtime)
% AU(1)=wcet;
% for i=2:1:simulationtime+1
%     AU(i)=wcet*ceil((i-1)/(period));
% end
%Au
AU(1)=wcet;
for i=2:simulationtime+1;
    tmp=wcet*ceil((i-1)/delta);
    AU(i)=wcet*ceil((i+2*jitter-1)/period);
    if(tmp<AU(i))
        AU(i)=tmp;
    end
end
% AL(1)=0;
% AL(2)=0;
% for i=2:1:simulationtime+1
%     AL(i)=wcet*floor((i-1)/(period));
% end
% AL(1)=0;
% AL(2)=0;
% for i=3:1:simulationtime+1
%      AL(i)=wcet*floor((i-1)/(period));
% end
for i=1:(2+2*jitter);
AL(i)=0;
end
for i=(2+2*jitter):(simulationtime+1);
     AL(i)=wcet*floor((i-1-2*jitter)/(period));
end
% figure(1)
% plot(0:1:simulationtime,AU,'.');
% plot(0:1:simulationtime,AL,'.');
[ A_U,A_L,B_U,B_L ] = DelayDensity_GPCModel( AU,AL,BU,BL );

% figure(1)
% hold on
% plot(0:1:simulationtime,A_U,'b');
% % plot(0:1:simulationtime,AU,'b.');
% plot(0:1:simulationtime,A_L,'r');
% % plot(0:1:simulationtime,AL,'b.');
% % plot(0:1:simulationtime,BL,'b.');
% figure(2)
% hold on
% plot(0:1:simulationtime,B_U,'g');
% plot(0:1:simulationtime,B_L,'b');

end

