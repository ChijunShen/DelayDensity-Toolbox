function [ output_Ankunftskurve ] = DelayDensity_ConvertAnkunftskurve( Ankunftskurve, e1, e2,simulationtime)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明


j=1;
starttime=zeros(1,simulationtime);
for i=1:simulationtime
   if(Ankunftskurve(i)==j*e1)
       starttime(j)=i-1;
       j=j+1;
   end
end
k=1;
value=0;
for i=1:simulationtime+1
   if(k<=j)
       if(i-1==starttime(k))
           value=value+e2;
           k=k+1;
       end
   end
   output_Ankunftskurve(i)=value;
end

% plot(0:simulationtime-1,output_Ankunftskurve(1:simulationtime+1))
% pause

end

