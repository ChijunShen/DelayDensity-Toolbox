%��ӡ�㷨��������
%generation_size: ��������

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
