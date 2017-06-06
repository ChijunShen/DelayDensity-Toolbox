%�Ŵ��㷨������
%pop_size: ������Ⱥ��С
%chromo_size: ����Ⱦɫ�峤��
%generation_size: �����������
%cross_rate: ���뽻�����
%cross_rate: ����������
%elitism: �����Ƿ�Ӣѡ��
%m: �����Ѹ���
%n: ��������Ӧ��
%p: �����Ѹ�����ִ�
%q: �����Ѹ����Ա���ֵ

function [m,n,p,q] = GeneticAlgorithm(pop_size, chromo_size, generation_size, cross_rate, mutate_rate, elitism)

global G ; %��ǰ��
global fitness_value;%��ǰ����Ӧ�Ⱦ���
global best_fitness;%���������Ӧֵ
global fitness_avg;%����ƽ����Ӧֵ����
global best_individual;%������Ѹ���
global best_generation;%��Ѹ�����ִ�

global jabs_value
global jabs_average

global pop



fitness_avg = zeros(generation_size,1);

disp "GeneticAlgorithm"

fitness_value(pop_size) = 0.;
best_fitness = 0.;
best_generation = 0;
initilize(pop_size, chromo_size);%��ʼ��
% pop
% pause
for G=1:generation_size   
    fitness(pop_size, chromo_size);  %������Ӧ�� 
    rank(pop_size, chromo_size);  %�Ը��尴��Ӧ�ȴ�С��������
    selection(pop_size, chromo_size, elitism);%ѡ�����
    crossover(pop_size, chromo_size, cross_rate);%�������
    mutation(pop_size, chromo_size, mutate_rate);%�������
end
plotGA(generation_size);%��ӡ�㷨��������
fprintf('**************\nGeneticAlgorithm ends\n m:best_individual \nn:best_fitness');
m = best_individual%�����Ѹ���
n = best_fitness%��������Ӧ��
p = best_generation%�����Ѹ�����ִ�;
q = 0;


fitness_avg=fitness_avg
jabs_average=jabs_average
% fprintf('**************\nErgebnis:\n');
% 
%  for j=1:8
%      if m(j) == 1
%          task_ph1(i) = task_ph1(i)+2^(j-1);
%      end        
%  end
%  for j=9:16
%      if m(j) == 1
%          task_ph2(i) = task_ph2(i)+2^(j-1-8);
%      end        
%  end
%  for j=17:24
%      if m(j) == 1
%          task_e3(i) = task_e3(i)+2^(j-1-16);
%      end        
%  end
%  for j=25:32
%      if m(j) == 1
%          task_d3(i) = task_d3(i)+2^(j-1-24);
%      end        
%  end
%  for j=33:40
%      if m(j) == 1
%          task_j3(i) = task_j3(i)+2^(j-1-32);
%      end        
%  end
%  for j=41:48
%      if m(j) == 1
%          task_p3(i) = task_p3(i)+2^(j-1-40);
%      end        
%  end
%  fprintf('generation %d: ph1:%dms ph2:%dms p3:%dms j3:%dms d3:%dms e3:%dms\n',G,task_ph1(i),task_ph2(i),task_p3(i),task_j3(i),task_d3(i),task_e3(i));

    task_p1=DelayDensity_GetValueFromBinary(m,1,8);
    task_j1=DelayDensity_GetValueFromBinary(m,9,16);
    task_d1=DelayDensity_GetValueFromBinary(m,17,24);
    task_e1=DelayDensity_GetValueFromBinary(m,25,32);
    task_ph1=DelayDensity_GetValueFromBinary(m,33,40);
    
    task_p1=round(task_p1/255*p1max);
    task_j1=round(task_j1/255*j1max);
    task_d1=round(task_d1/255*d1max);
    task_e1=round(task_e1/255*e1max);
    task_ph1=round(task_ph1/255*ph1max);
    
    task_p2=DelayDensity_GetValueFromBinary(m,41,48);
    task_j2=DelayDensity_GetValueFromBinary(m,49,56);
    task_d2=DelayDensity_GetValueFromBinary(m,57,64);
    task_e2=DelayDensity_GetValueFromBinary(m,65,72);
    task_ph2=DelayDensity_GetValueFromBinary(m,73,80);
    
    task_p2=round(task_p2/255*p2max);
    task_j2=round(task_j2/255*j2max);
    task_d2=round(task_d2/255*d2max);
    task_e2=round(task_e2/255*e2max);
    task_ph2=round(task_ph2/255*ph2max);
    
    Auslastung=task_e1/task_p1+task_e2/task_p2+e3/p3;
    fprintf('Worst Case\np1:%dms j1:%d d1:%d e1:%d ph1:%d\np2:%dms j2:%d d2:%d e2:%d ph2:%d\np3:%dms j3:%d d3:%d e3:%d ph3:%d Auslastung:%5.2f\nbest fitness value:%f',G,task_p1,task_j1,task_d1,task_e1,task_ph1,task_p2,task_j2,task_d2,task_e2,task_ph2,p3,j3,d3,e3,ph3,Auslastung,n);


%�����Ѹ������ֵ���Բ�ͬ���Ż�Ŀ�꣬�˴���Ҫ��д
% q = 0.;
% for j=1:chromo_size
%     if best_individual(j) == 1
%             q = q+2^(j-1);
%     end 
% end
%      task_p=0;
%      task_j=0;
%      task_d=0;
%      for j=1:8
%          if best_individual(i,j) == 1
%              task_d = task_d+2^(j-1);
%          end        
%      end
%      for j=9:16
%          if best_individual(i,j) == 1
%              task_j = task_j+2^(j-1-8);
%          end        
%      end
%      for j=17:24
%          if best_individual(i,j) == 1
%              task_p = task_p+2^(j-1-16);
%          end        
%      end
%      
%      task_p=round(task_p/512*p3);
%      task_p=task_p
%      task_j=task_j
%      task_d=task_d
%      
% 
%      
% q = -1+q*(3.-(-1.))/(2^chromo_size-1);