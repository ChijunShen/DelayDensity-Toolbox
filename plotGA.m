%打印算法迭代过程
%generation_size: 迭代次数

function plotGA(generation_size)
global fitness_avg;
global jabs_average;
x = 1:1:generation_size;
y = fitness_avg;
figure(1)
plot(x,y)
figure(2)
y = jabs_average;
plot(x,y);
