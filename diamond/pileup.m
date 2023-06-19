clear all
close all
%% Constants and parameters

flux = 1 * 10^10; % in particle per cm^2 per s
t_pulse = 10 * 10^-9; % seconds
area = 0.15*0.15*pi; % detector area in cm^2
events = 0:1:10; % arrange it to see the graph in best scale

%% Calculation assuming poisson process
particle_per_sec = flux*area;
ft = particle_per_sec* t_pulse ; % ffe
norm = exp(-1*ft); % ffe
% probabilities = norm * ft.^events ./ factorial(events); 

% Special treatment is needed for numerical precision
probabilities = [];
probabilities(1) = norm;
for i = 2:1:length(events)
    probabilities(i) = ft/events(i)*probabilities(i-1);
end

expected = sum(probabilities.*events);
stdev = sqrt(sum(probabilities.*(events-expected).^2));
check_norm = sum(probabilities);
expected_str = strcat('mean:  ',num2str(expected));
stdev_str = strcat('stdev:  ',num2str(stdev));
check_norm_str = strcat('normalizes to:  ',num2str(check_norm));
%% Plotting results
figure(1)
plot(events,probabilities)
title('Probability Distribution of the Events')
xlabel('Events per 10 ns')
ylabel('Probabilities')
txt1 = strvcat(expected_str,stdev_str,check_norm_str);
text(15,0.32,txt1) % arrange to see them on screen
grid on

