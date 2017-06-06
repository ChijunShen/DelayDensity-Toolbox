clc
clear

global time1
global Instanz
global Drehzahl
global tr
global adjust_time
global Jabs
global overshoot

global Jitae
global Jsqr

global simulationtime
global NumOfTask
global NumOfSimulation
global CPU_Bandwidth
global p1
global j1
global d1
global e1
global ph1
global p2
global j2
global d2
global e2
global ph2

global p1max
global j1max
global d1max
global e1max
global ph1max
global p2max
global j2max
global d2max
global e2max
global ph2max

global p3
global j3
global d3
global e3
global ph3

global p3max
global p3min
global j3max
global j3min
global d3max
global d3min
global e3max
global e3min

global G ; %当前代 the current generation
global fitness_value;%当前代适应度矩阵 the current fitness matrix
global best_fitness;%历代最佳适应值 the best fitness value of all the generations
global fitness_avg;%历代平均适应值矩阵 the average fittness value
global best_individual;%历代最佳个体 the best individual
global best_generation;%最佳个体出现代 the best generation

global jabs_value
global jabs_average


elitism = true;%选择精英操作
pop_size = 20;%种群大小20
chromo_size = 80;%染色体大小
generation_size = 8;%迭代次数
cross_rate = 0.6;%交叉概率
mutate_rate = 0.3;%变异概率

sollwert=10;
% p1=500;j1=250;d1=20;e1=50;ph1=500;%1 unit ms
% p2=100;j2=100;d2=20;e2=20;ph2=100;
% p3min=100;p3max=300;
% j3min=10;j3max=200;
% d3min=2;d3max=10;
% e3min=10;e3max=30;
%unit ms
p1max=50;j1max=10;d1max=10;e1max=20;ph1max=p1max;
p2max=50;j2max=10;d2max=10;e2max=20;ph2max=p2max;
p3=00;j3=100;d3=10;e3=20;ph3=0;
ph3=0;
CPU_Bandwidth=1;
simulationtime=40000;
NumOfTask=100;
NumOfSimulation=1;%3
Totzone_Wert=0.1;%Ereignisbasierte Regelung mit Totzone
rho_Wert=0.001;

%Gleichstrommotor System Parameter
L_A=0.5;           %Ankerinduktivitat Unit:H  
R_A=1.0;           %Ankerwiderstand Unit:Ohm
K_M=0.01;          %Motorkonstant Unit:Nm/A
K_B=0.01;          %back emf constant
K_F=0.1;           %Reibungskonstante Unit:Nms
J_M=0.01;          %Ankertragheitsmoment Unit:kgm2
M_L=0;             %Lastdrehenmoment Unit:Nm

%PID-Reglegungen
Kp=2;%
Ki=4;%
Kd=0.3;%
Umax=500;

%Ereignisgenerator
EncoderDegree=180;
Ereignisgenerator_Sampletime=0.01;%s

%Gleichstrommotor Modell Vereinfachung
A=L_A*J_M/K_M;
B=(K_F*L_A+R_A*J_M)/K_M;
C=R_A*K_F/K_M+K_B;
S1=L_A/K_M;
S2=R_A/K_M;

%Gleichstrommotor System Matrix
System_A=[0 1 0;0 0 1;0 -C/A -B/A];
System_B=[0;0;1/A];
System_C=[1 0 0];
System_S1=[0;0;S1/A];
System_S2=[0;0;S2/A];

%LQ-Regelungen
Q=[1 0 0;0 4000 0;0 0 0];
R=10;
[K,s,e] = lqr(System_A,System_B,Q,R,0);
V=-1/(System_C*inv(System_A-System_B*K)*System_B);%Vorfilter
Idea=[100000;100];
Ereignis_Abtastzeit=200;%not used ,just to let the Simulink Module work

GesamtModel
[m,n,p,q] = GeneticAlgorithm(pop_size, chromo_size, generation_size, cross_rate, mutate_rate,elitism);




