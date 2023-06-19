clear all
close all

%% Constants and parameters

flux = 1 * 10^10; % in particle per cm^2 per s
step = 10^-11; % simulation step in seconds
step_ns = step * 10^9;
area = (0.15)*(0.15)*pi; % detector area in cm^2
events = 0:1:20; % arrange it not to miss any probabilities
sim_end = 100000; % end time of simulation
signal_cut = 1; % in ns cuts signal from fornt and behind
time = 0:step_ns:sim_end; % simulation time in ns
signal_top = -60/1000; % peak voltage of signal in V

%% Probability of number of events at each step
particle_per_sec = flux*area;
ft = particle_per_sec* step ; % ffe
norm = exp(-1*ft); % ffe
probabilities = zeros(1,length(events));
probabilities(1) = norm;
for i = 2:1:length(events)
    probabilities(i) = ft/events(i)*probabilities(i-1);
end

%% Single pulse shape
pulse_length = 10000;
% pulse_noncausal = gausswin(pulse_length/2,12)'; %create the pulse
% pulse = [zeros(1,pulse_length/2),pulse_noncausal]; % make it causal
%pulse = signal_top*gausswin(pulse_length,12)'; %the non causal pulse
pulse = signal_top*[zeros(1,4500),ones(1,1000),zeros(1,4500)];
%pulse = signal_top * ones(1,1000);
%figure(1)
plot(pulse) % check the pulse
%title('pulse shape')
%xlabel('time (0.01 ns)')
%ylabel('normalized magnitude')
%hold on
% pulse_mf = conv(pulse,pulse,'same');
% plot(pulse_mf,'r')

% Simulation to find how many particles are coming each 0.1 ns
rand_array = rand(1,length(time));
particle_array = zeros(1,length(time));
for i= 1:1:length(time)
    probability_sum = 0;
    for j = 1:1:length(probabilities)
        probability_sum  = probability_sum + probabilities(j);
        if(rand_array(i) < probability_sum)
            particle_array(i) = events(j);
            break;
        end
    end
end
% Number of particles sent
real_part_count = sum(particle_array((signal_cut/step_ns):((sim_end-signal_cut)/step_ns)))
% To add some uncertainty
particle_array = RandomRipple(particle_array,0.05,0.05);

%% Plotting arrangements
figure(2) % To check particle array
stem(time,0.1*particle_array,'r')
hold on
% How the signal looks
signal = conv(particle_array,pulse,'same');
signal = signal((signal_cut/step_ns):((sim_end-signal_cut)/step_ns));
time3 = time((signal_cut/step_ns):((sim_end-signal_cut)/step_ns));
time2 = -(pulse_length/2*step_ns-step_ns):step_ns:(length(time)*step_ns+pulse_length/2*step_ns-step_ns);


signal = signal - mean(signal); % Broadband Amplifier makes DC value 0
signal_rms = rms(signal);

% The Downsampler
time4 = [];
signal2 = [];
for i = 1:1:length(time3)
    if(mod((i-2),100) == 0)
        time4 = [time4,time3(i)];
        signal2 = [signal2,signal(i)];
    end
end

plot(time4,signal2)
title('A sample output signal with given flux')
xlabel('Time (ns)')
ylabel('Voltage (V) ( 1 signal peak is at -60 mV for comparison)')
legend('particle arrivals','output signal')
hold off

% %% Integral Reading
% %Noise parameters
% noise_on=1;
% noise_rms = 15; % noise rms in terms of mV
% noise_power = (noise_rms)^2/1000; % noise power in terms of mW
% noise = wgn(1,length(signal),noise_power/1000,'linear');
% SNR = rms(signal)/rms(noise)
% if(noise_on)
%     signal_f = signal+noise;
% else
%     signal_f = signal;
% end
% 
% %ADC parameters
% integral_step = 1; % ADC sampling period in ns
% adc_bit = 14; % ADC bit
% adc_max = 1; % maximum of dynamic range of ADC in mV
% adc_minp = -1; % minimum of dynamic range of ADC in mV
% adc_step = (adc_max-adc_minp)/(2^adc_bit);
% 
% % Loop
% multiple_signal = integral_step/step_ns ; % steps required for one 1 ns to pass
% sum_pulse = 0;
% integral_signal = 0;
% adc_array_no_quant=[];
% k=1;
% for i=1:1:length(time3)
%     if (mod(i,multiple_signal) == 1)
%         %integral_signal = integral_signal + signal_f(i);
%         adc_array_no_quant(k) = signal_f(i);
%         k = k + 1;
%     end
% end
% 
% for i=1:1:length(pulse)
%     if (mod(i,100) == 1)
%         sum_pulse = sum_pulse + pulse(i);
%     end
% end
% % Quantization of the samples
% partition = (adc_minp+adc_step):adc_step:adc_max;
% codebook = adc_minp:adc_step:adc_max;
% [index,adc_array] = quantiz(adc_array_no_quant,partition,codebook);
% 
% % Simplest way, just look to lowest value
% adc_min = max(adc_array); % Beware min became max, signal is negative...
% % Average minimum value over number of expected minimas to reduce the error
% expected_minima_number = (sim_end-2*signal_cut)/(5540*2)*10.7;
% sorted_adc_array = sort(adc_array);
% adc_min_values = sorted_adc_array(1:round(expected_minima_number));
% adc_min_average = mean(adc_min_values); % In case there is nothing to average
% if (round(expected_minima_number) == 0)
%     adc_min_averages = adc_min;
% end
% 
% part_count = (-adc_min_average)*(sim_end-2*signal_cut)/sum_pulse
% part_count_simple = (-adc_min)*(sim_end-2*signal_cut)/sum_pulse
% 
% 
% 
% 
% %% Convert Back to Flux
% statistical_flux = real_part_count*(10^9)/(area*(sim_end-2*signal_cut))
% 
% measured_flux = part_count*(10^9)/(area*(sim_end-2*signal_cut))
% percentage_error = 100*(statistical_flux - measured_flux)/statistical_flux
% 
% measured_flux_simple = part_count_simple*(10^9)/(area*(sim_end-2*signal_cut))
% percentage_error_simple = 100*(statistical_flux - measured_flux_simple)/statistical_flux