function [ Result ] = LD_Compare( SimulationCaseIndex ,Test_Anzahl)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

%Test Case
for i=2:Test_Anzahl
    Instanz(i)=Latenz(i)-Latenz(i-1);
end
SimulationTime=time1(Test_Anzahl)+10;
GesamtModel
set_param('GesamtModel','StartTime','0','StopTime','SimulationTime');
set_param('GesamtModel','Solver','ode45')
sim('GesamtModel')

Ergebnis_TestCase=Drehzahl;


end

