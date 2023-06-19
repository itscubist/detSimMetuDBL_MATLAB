% A function that calculates the poisson probabilities of events with given
% poisson parameter and interval until the last event probability

function [probabilities,events] = poisson_probabilities ...
    (poisson_par, interval, last_event)
    events = 0:1:last_event;
    probabilities = zeros(1,last_event+1);
    poisson_par_interval = poisson_par*interval;
    probabilities(1) = exp(-1*poisson_par_interval );
    % Finding Poisson Probabilities per interval
    for i = 1:1:last_event
        probabilities(i+1) = (poisson_par_interval)/events(i+1)*probabilities(i);
    end
end