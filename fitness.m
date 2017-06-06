%计算种群个体适应度，对不同的优化目标，此处需要改写
%pop_size: 种群大小
%chromo_size: 染色体长度

function fitness(pop_size, chromo_size)
global fitness_value;
global pop;
global G;
global simulationtime
global NumOfTask
global NumOfSimulation
global CPU_Bandwidth
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

global jabs_value
fprintf('generation %d procedure:fitness  calculation\n',G);

for i=1:pop_size
    fitness_value(i) = 0.;
    jabs_value(i)=0;
end
task_ph1=zeros(pop_size,1);
task_ph2=zeros(pop_size,1);
task_e3=zeros(pop_size,1);
task_d3=zeros(pop_size,1);
task_j3=zeros(pop_size,1);
task_p3=zeros(pop_size,1);


for i=1:pop_size
%     for j=1:chromo_size
%         if pop(i,j) == 1
%             fitness_value(i) = fitness_value(i)+2^(j-1);
%         end        
%     end
%      fitness_value(i) = -1+fitness_value(i)*(3.-(-1.))/(2^chromo_size-1);
%      fitness_value(i) = -(fitness_value(i)-2).^2+4;
%      for j=1:8
%          if pop(i,j) == 1
%              task_ph1(i) = task_ph1(i)+2^(j-1);
%          end        
%      end
%      for j=9:16
%          if pop(i,j) == 1
%              task_ph2(i) = task_ph2(i)+2^(j-1-8);
%          end        
%      end
%      for j=17:24
%          if pop(i,j) == 1
%              task_e3(i) = task_e3(i)+2^(j-1-16);
%          end        
%      end
%      for j=25:32
%          if pop(i,j) == 1
%              task_d3(i) = task_d3(i)+2^(j-1-24);
%          end        
%      end
%      for j=33:40
%          if pop(i,j) == 1
%              task_j3(i) = task_j3(i)+2^(j-1-32);
%          end        
%      end
%      for j=41:48
%          if pop(i,j) == 1
%              task_p3(i) = task_p3(i)+2^(j-1-40);
%          end        
%      end

while 1
    task_p1=DelayDensity_GetValueFromBinary(pop(i,:),1,8);
    task_j1=DelayDensity_GetValueFromBinary(pop(i,:),9,16);
    task_d1=DelayDensity_GetValueFromBinary(pop(i,:),17,24);
    task_e1=DelayDensity_GetValueFromBinary(pop(i,:),25,32);
    task_ph1=DelayDensity_GetValueFromBinary(pop(i,:),33,40);
    
    task_p1=round(task_p1/255*p1max);
    task_j1=round(task_j1/255*j1max);
    task_d1=round(task_d1/255*d1max);
    task_e1=round(task_e1/255*e1max);
    task_ph1=round(task_ph1/255*ph1max);
    
    task_p2=DelayDensity_GetValueFromBinary(pop(i,:),41,48);
    task_j2=DelayDensity_GetValueFromBinary(pop(i,:),49,56);
    task_d2=DelayDensity_GetValueFromBinary(pop(i,:),57,64);
    task_e2=DelayDensity_GetValueFromBinary(pop(i,:),65,72);
    task_ph2=DelayDensity_GetValueFromBinary(pop(i,:),73,80);
    
    task_p2=round(task_p2/255*p2max);
    task_j2=round(task_j2/255*j2max);
    task_d2=round(task_d2/255*d2max);
    task_e2=round(task_e2/255*e2max);
    task_ph2=round(task_ph2/255*ph2max);
    
    Auslastung=task_e1/task_p1+task_e2/task_p2+e3/p3;
    if (Auslastung<0.5)
        break;
    end
     %fprintf('generation %d:\np1:%dms j1:%d d1:%d e1:%d ph1:%d\np2:%dms j2:%d d2:%d e2:%d ph2:%d\np3:%dms j3:%d d3:%d e3:%d ph3:%d Auslastung:%5.2f Wrong',G,task_p1,task_j1,task_d1,task_e1,task_ph1,task_p2,task_j2,task_d2,task_e2,task_ph2,p3,j3,d3,e3,ph3,Auslastung);
    
    for j=1:chromo_size
        pop(i,j) = round(rand);
    end
    

end
     
%      task_ph1(i)=round(task_ph1(i)/255*ph1);
%      task_ph2(i)=round(task_ph2(i)/255*ph2);
%      
%      task_p3(i)=p3min+round(task_p3(i)/255*(p3max-p3min));
%      task_j3(i)=j3min+round(task_j3(i)/255*(j3max-j3min));
%      task_d3(i)=d3min+round(task_d3(i)/255*(d3max-d3min));
%      task_e3(i)=e3min+round(task_e3(i)/255*(e3max-e3min));
     
     
     
%      task_p(i)=round(task_p(i)/512*p3);
%      if task_p(i)<10
%          task_p(i)=10;
%      end
%      task_j(i)=round(task_j(i)/512*j3);
%      task_d(i)=round(task_d(i)/512*d3);
     fprintf('generation %d:\np1:%dms j1:%d d1:%d e1:%d ph1:%d\np2:%dms j2:%d d2:%d e2:%d ph2:%d\np3:%dms j3:%d d3:%d e3:%d ph3:%d Auslastung:%5.2f',G,task_p1,task_j1,task_d1,task_e1,task_ph1,task_p2,task_j2,task_d2,task_e2,task_ph2,p3,j3,d3,e3,ph3,Auslastung);
     [fitness_value_result,jabs_value_result]=DelayDensity_FP_Simulation( simulationtime,NumOfTask,NumOfSimulation,CPU_Bandwidth,task_p1,task_j1,task_d1,task_e1,task_ph1,task_p2,task_j2,task_d2,task_e2,task_ph2,p3,j3,d3,e3,ph3 );
     fprintf('DeltaOvershoot:%4.2f%%  DeltaJabs:%4.2f%%\n',fitness_value_result,jabs_value_result);
     
     
     fitness_value(i)=fitness_value_result;
     jabs_value(i)=jabs_value_result;
end
