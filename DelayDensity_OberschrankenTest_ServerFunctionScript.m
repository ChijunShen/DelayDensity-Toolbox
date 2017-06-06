clc
clear
simulationtime=2500;
NumOfTask=20;
CPU_Bandwidth=1;
p1max=50;
p1min=20;
j1max=0;
j1min=0;
d1=2;
e1max=6;
e1min=5;
ph1max=0;

p2max=70;
p2min=40;
j2max=0;
j2min=0;
d2=2;
e2max=6;
e2min=5;
ph2max=0;

p3max=100;
p3min=30;
j3max=0;
j3min=0;
d3=2;
e3max=20;
e3min=10;
DelayDensity_OberschrankenTest_ServerFunction( simulationtime,NumOfTask,CPU_Bandwidth,p1max,p1min,j1max,j1min,d1,e1max,e1min,ph1max,p2max,p2min,j2max,j2min,d2,e2max,e2min,ph2max,p3max,p3min,j3max,j3min,d3,e3max,e3min);