% A function to generate events in a Poisson process
% Poisson Parameter : Events/Sec
% End_Time = Time until simulation ends
% Step = How often poisson probabilities are checked

% Note: In order to make simulation realistic, step should be 10 times
% smaller than the minimum time period a person is interested in and
% poisson probability of two events generated in a step should be ~zero.

function [events,time,event_pos] = poisson_generator(poisson_par, end_time, step)

    time = 0:step:end_time;
    probabilities = zeros(1,5);
    poisson_par_step = poisson_par*step;
    probabilities(1) = exp(-1*poisson_par_step );
    % Finding Poisson Probabilities per step
    for i = 2:1:5
        probabilities(i) = (poisson_par_step)/(i-1)*probabilities(i-1);
    end
    
    if (probabilities(3)> 0.0001)
       Warning = ' Probability of two events in a step is higher than 10^-4' 
    end
    % Creating events in given time window with calculated probabilities
    rand_array = rand(1,length(time));
    events = zeros(1,length(time));
    event_pos = [];
    for i= 1:1:length(time)
        probability_sum = 0;
        for j = 1:1:length(probabilities)
            probability_sum  = probability_sum + probabilities(j);
            if(rand_array(i) < probability_sum)
                events(i) = j-1;
                break;
            end
        end
        if(events(i)>0)
            event_pos = [event_pos,i];
        end
    end
end