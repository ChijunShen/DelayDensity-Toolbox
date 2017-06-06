function [ A_Concrete,B_Concrete,BConcrete ] = DelayDensity_TDMAConcreteModel( AConcrete,CPU_Bandwidth,tdma_cycle,tdma_slot,tdma_phase,simulationtime)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

%construct BConcrete
for i=1:simulationtime+tdma_cycle+tdma_slot+tdma_phase+1;
     term(i)=i-floor(i/tdma_cycle)*tdma_cycle-(tdma_cycle-tdma_slot);
     if term(i)<0
         term(i)=0;
     end
     tmp_BConcrete(i)=(floor(i/tdma_cycle)*tdma_slot+term(i))*CPU_Bandwidth;
end
tmp=tmp_BConcrete;
tmp_BConcrete(1)=0;%CPU_Bandwidth;
for i=1:simulationtime+tdma_phase+1;
    tmp_BConcrete(i+1)=tmp(i+tdma_cycle-tdma_slot);
end

% figure(1)
% plot(0:1:simulationtime+tdma_phase,tmp_BConcrete(1:simulationtime+tdma_phase+1),'r');

% tmp_BConcrete=tmp_BConcrete(1:simulationtime+tdma_phase+1);
for i=1:tdma_phase
    BConcrete(i)=0;
end
for i=tdma_phase+1:simulationtime+tdma_phase+1
    BConcrete(i)=tmp_BConcrete(i-tdma_phase);
end
BConcrete=BConcrete(1:simulationtime+1);
% figure(2)
% hold on
% plot(0:1:simulationtime,BConcrete,'r');

if(length(AConcrete)>length(BConcrete))
LengthOfDelta=length(BConcrete);
fprintf('DelayDensity_TDMAConcreteModel warning: the lenght of array of AConcrete and BConcrete is not equal!\n');
elseif(length(AConcrete)<length(BConcrete)) 
LengthOfDelta=length(AConcrete);
fprintf('DelayDensity_TDMAConcreteModel warning: the lenght of array of AConcrete and BConcrete is not equal!\n');
else
LengthOfDelta=length(AConcrete);
end

[ A_U,A_L,B_U,B_L ] = DelayDensity_GPCModel( AConcrete,AConcrete,BConcrete,BConcrete );

A_Concrete=A_U;
B_Concrete=B_L;    

end

