function [ A_Concrete,B_Concrete,BConcrete] = DelayDensity_FPConcreteModelInit( AConcrete,CPU_Bandwidth,simulationtime)
%DelayDensity_FPModelInit
%old version function [ A_Concrete,B_Concrete,AConcrete,BConcrete ] = DelayDensity_FPConcreteModelInit( period,deadline,phase,wcet,CPU_Bandwidth,simulationtime)
%resource based

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

% AL=AU;

% figure(1)
% hold on
% plot(0:1:simulationtime,AU,'.r');
% plot(0:1:simulationtime,AL,'.b');

for i=0:1:simulationtime
    BU(i+1)=i*CPU_Bandwidth;
end
    BL=BU;
% figure(1)
% plot(0:1:simulationtime,BU,'r.');
[ A_U,A_L,B_U,B_L ] = DelayDensity_GPCModel( AConcrete,AConcrete,BU,BL );


% figure(1)
% hold on
% plot(0:1:simulationtime,A_U,'b');%in Real
% % plot(0:1:simulationtime,AU,'r.');
% % plot(0:1:simulationtime,A_L,'r');
% % plot(0:1:simulationtime,AL,'b.');
% % plot(0:1:simulationtime,BL,'b.');
% % figure(2)
% % hold on
% % plot(0:1:simulationtime,B_U,'g');
% plot(0:1:simulationtime,B_L,'g');%in Real
A_Concrete=A_U;
B_Concrete=B_L;
BConcrete=BU;
end