function [ A_Concrete,B_Concrete] = DelayDensity_ConnectWithConcreteFPModel( BConcrete,AConcrete,simulationtime)
%function [ A_Concrete,B_Concrete,AConcrete] = DelayDensity_ConnectWithConcreteFPModel( BConcrete,period,deadline,phase,wcet,simulationtime)

% if(phase==0)
%     AU(1)=wcet;
% end
% for i=2:1:simulationtime+1
%     AU(i)=wcet*ceil((i-1-phase)/(period));
% end
% if phase~=0
%     for i=1:phase+1
%         AU(i)=0;
%     end
% end
% 
% AL=AU;

% figure(1)
% plot(0:1:simulationtime,AU,'.');
% plot(0:1:simulationtime,AL,'.');
[ A_U,A_L,B_U,B_L ] = DelayDensity_GPCModel( AConcrete,AConcrete,BConcrete,BConcrete );

% figure(2)
% hold on
% plot(0:1:simulationtime,A_U,'b');
% % % plot(0:1:simulationtime,AU,'b.');
% % plot(0:1:simulationtime,A_L,'r');
% % % plot(0:1:simulationtime,AL,'b.');
% % plot(0:1:simulationtime,BL,'b.');
% % figure(2)
% % hold on
% plot(0:1:simulationtime,B_U,'g');
% plot(0:1:simulationtime,B_L,'r');

A_Concrete=A_U;
B_Concrete=B_L;
% AConcrete=AU;

end
