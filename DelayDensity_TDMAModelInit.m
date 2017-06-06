function [ A_U,A_L,B_U,B_L,AU,AL,BU,BL ] = DelayDensity_TDMAModelInit( period,jitter,delta,wcet,CPU_Bandwidth,tdma_cycle,tdma_slot,simulationtime)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明


%DelayDensity_FPModelInit
%resource based

%Au
AU(1)=wcet;
for i=2:simulationtime+1;
    tmp=wcet*ceil((i-1)/delta);
    AU(i)=wcet*ceil((i+2*jitter-1)/period);
    if(tmp<AU(i))
        AU(i)=tmp;
    end
end

% AU(1)=wcet;%wcet;
% for i=2:1:simulationtime+1
%     AU(i)=wcet*ceil((i-1)/(period));
% end

% AL(1)=0;
% for i=2:1:simulationtime+1
%     AL(i)=wcet*floor((i-1)/(period));
% end
for i=1:(2+2*jitter);
AL(i)=0;
end
for i=(2+2*jitter):(simulationtime+1);
     AL(i)=wcet*floor((i-2-2*jitter)/(period));
end
% 
% figure(1)
% hold on
% plot(0:1:simulationtime,AU,'r');
% plot(0:1:simulationtime,AL,'b');

%BL
BL(1)=0;
for i=1:simulationtime;
     term(i)=i-floor(i/tdma_cycle)*tdma_cycle-(tdma_cycle-tdma_slot);
     if term(i)<0
         term(i)=0;
     end
     BL(i)=(floor(i/tdma_cycle)*tdma_slot+term(i))*CPU_Bandwidth;
end
tmp=BL;
for i=1:simulationtime;
    BL(i+1)=tmp(i);
end

%BH
for i=1:simulationtime+tdma_cycle+tdma_slot+1;
     term(i)=i-floor(i/tdma_cycle)*tdma_cycle-(tdma_cycle-tdma_slot);
     if term(i)<0
         term(i)=0;
     end
     tmp_BU(i)=(floor(i/tdma_cycle)*tdma_slot+term(i))*CPU_Bandwidth;
end
tmp=tmp_BU;
tmp_BU(1)=0;%CPU_Bandwidth;
for i=1:simulationtime;
    tmp_BU(i+1)=tmp(i+tdma_cycle-tdma_slot);
end

BU=tmp_BU(1:simulationtime+1);

% figure(2)
% hold on
% plot(0:1:simulationtime,BU,'r');
% plot(0:1:simulationtime,BL,'b');

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

