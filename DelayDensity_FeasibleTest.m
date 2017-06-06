function [ ResultOfTask ] = DelayDensity_FeasibleTest( ResponstimeOfTask,RelativDeadline)
%DelayDensity_FeasibleTest
%
% if(length(StartTimeOfTask)~=length(StartTimeOfTask))
%     fprintf('DelayDensity_FeasibleTest warning: the lenght of array of StartTimeOfTask and ResponstimeOfTask is not equal!\n');
% end
% RealEndTimeOfTask=StartTimeOfTask+ResponstimeOfTask;
% SollEndTimeOfTask=StartTimeOfTask+Deadline;
ResultOfTask=1;
for i=1;length(ResponstimeOfTask);
    if(ResponstimeOfTask(i)>RelativDeadline)
        ResultOfTask=0;
        break;
    end
end
if(ResultOfTask==1)
%     fprintf('Schedule is feasible!\n');
else
%     fprintf('Schedule is not feasible!\n');  
end

