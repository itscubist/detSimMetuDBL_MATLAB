%% License and Manual
% Author: Baran Bodur and Serhan Yılmaz
% Timepix3 Flux Measurement
% Idea: Do not use what you do not know
% Timepix3 Mode ToA + ToT, Frame Based, VCO on or off
% Timepix3 Parameters Ikrum is max, threshold is energywise max


tic(); % Start measuring time
addpath('/media/cubist/files/all/matlabsaves/my_functions'); % Import
%% Parameters
% Detector Parameters
intr_row_size = 256;
intr_column_size = 256;
pixel_area = 0.0055*0.0055; % in cm2
clock_to_ns = 25; % length of a clock cycle in ns

% Multi Frame Options (for combining frames, automatically done with .pmf)
no_of_frames = 20;
row_size = intr_row_size * no_of_frames;
column_size = intr_column_size;
% Choose sub-detector resolution (Possible values: 1,2,4,8,16,...)
% Caution: Statistics will decrease by the same ratio
row_divide = 1; % Resolution in cm will be 1.41/row_divide
column_divide = 1; % Resolution in cm will be 1.41/column_divide

%ToA Format and Acquisiton Time used in Timepix3
ToA_format = 1; % 0 for clock cycle, 1 for ns
shutter_length = 2500000000000; % in ns or clock cycle(25 MHz) depending on ToA format

%Options (Enabled: 1 , Disabled: 0)
timing_downsample_on = 0; % For low fluxes, no need of ns precision but longer shutter
obtain_clustering_statistics = 0; % If statistics are desired
first_statistics_run = 0; % Resets to previous statistics to zero
statistics_to_file = 0; % Saves statistics to file in the given order

%Time Downsampling Parameters (How many times downsample)
downsample_ratio = 1;
%Declustering Parameters (Per unit time, be careful if time is downsampled)
neighbouring_degree = 3;
degree1_ToAdiff = 80;
degree2_ToAdiff = 80;
degree3_ToAdiff = 50;
%% Obtain Data From File with Given Name and Extension
filename = './meas3'; % Saved Name (also with Directory if desired)
file_ext = 'pmf'; % Saved Extension

ToT = dlmread(strcat(filename,'.',file_ext,'_ToT.',file_ext),' ');
ToA = dlmread(strcat(filename,'.',file_ext,'_ToA.',file_ext),' ');
%fToA = dlmread(strcat(filename,'.',file_ext,'_FTOA.',file_ext),' ');

%ToA = round(25*ToA - 1.56*fToA); % Do not care about sub-nanosecond resolution
ToA = round(ToA);
%% Timing Downsample if thought to be necessary

if(timing_downsample_on)
    [ToA,shutter_length] = downsample(ToA,shutter_length,downsample_ratio);
end

%% Decluster

[total_hit, ToT_center, degree1ToA_dist_p, degree2ToA_dist_p,...
    degree3ToA_dist_p,early_pixels] = decluster5(ToT,ToA,neighbouring_degree,...
    degree1_ToAdiff,degree2_ToAdiff,degree3_ToAdiff,shutter_length,...
    row_size, column_size,intr_column_size,intr_row_size,...
    obtain_clustering_statistics);

%% Sub-Detector Hit Count
if(row_divide == 1 && column_divide == 1)
    sub_hits = total_hit;
    error_sub_hits = sqrt(total_hit);
else
[sub_hits, error_sub_hits] = sub_hit2(intr_row_size,intr_column_size,...
    row_size,column_size,ToT_center,row_divide,column_divide,early_pixels);
end

%% Find Measurement Time and Area, then uncorrected flux
[flux_divider] = time_area_norm3(ToT,ToA,shutter_length,row_size,...
column_size, ToA_format, pixel_area, clock_to_ns,timing_downsample_on,... 
    downsample_ratio, row_divide, column_divide, intr_row_size,...
    intr_column_size,early_pixels); %in cm2*s

sub_hits
total_hit
flux_divider
flux = sub_hits./flux_divider
error = error_sub_hits./flux_divider

%% Flux Correcter (which is not neeeded anymore)
%dead_time_area = sum(sum(ToT))*clock_to_ns*10^-9*pixel_area; % in s*cm2
%flux_corrected = flux_divider/(flux_divider-dead_time_area)*flux_uncorrected
%error_corrected = flux_divider/(flux_divider-dead_time_area)*error_uncorrected

%% Obtain Clustering Statistics for the given chip and particle configuration
if(obtain_clustering_statistics)
    % 0) Enable initialization only in first run
    if(first_statistics_run)
        degree1ToA_dist = [];
        degree2ToA_dist = [];
        degree3ToA_dist = [];
        non0ToT_1D = [];
        non0ToTc_1D = [];
        total_hit_combined = 0;
    end
    % 1) Occupancy and ToA
    %Combine statistics from all data (use clear all to restart collecting)
    total_hit_combined = total_hit_combined + total_hit;
    degree1ToA_dist = [degree1ToA_dist,degree1ToA_dist_p];
    degree2ToA_dist = [degree2ToA_dist,degree2ToA_dist_p];
    degree3ToA_dist = [degree3ToA_dist,degree3ToA_dist_p];
    %Occupancy ratio by degree
    degree1_occupancy = length(degree1ToA_dist)/total_hit_combined;
    degree2_occupancy = length(degree2ToA_dist)/total_hit_combined;
    degree3_occupancy = length(degree3ToA_dist)/total_hit_combined;
    occupancy_per_degree = [degree1_occupancy, degree2_occupancy, ...
        degree3_occupancy];
    %Number of occurances
    if (degree1_occupancy > 0)
        degree1ToA_prob = hist(degree1ToA_dist,(0:1:degree1_ToAdiff));
    else
        degree1ToA_prob = [];
    end
    if(degree2_occupancy > 0)
        degree2ToA_prob = hist(degree2ToA_dist,(0:1:degree2_ToAdiff));
    else
        degree2ToA_prob = [];
    end
    if(degree3_occupancy > 0)
        degree3ToA_prob = hist(degree3ToA_dist,(0:1:degree3_ToAdiff));
    else
        degree3ToA_prob = [];
    end
    %Occurances normalized to probability
    degree1ToA_prob = degree1ToA_prob/sum(degree1ToA_prob);
    degree2ToA_prob = degree2ToA_prob/sum(degree2ToA_prob);
    degree3ToA_prob = degree3ToA_prob/sum(degree3ToA_prob);
    % 2) ToT and center ToT 
    % Seperate diffused and cneter ToTs
    non0ToT_1D_p = TwotoOneD(ToT(ToT_center == 0));
    non0ToTc_1D_p = TwotoOneD(ToT(ToT_center > 0));
    non0ToT_1D_p = non0ToT_1D_p(non0ToT_1D_p>0);
    % Combine statistics from all data (use clear all to restart collecting)
    non0ToT_1D = [non0ToT_1D, non0ToT_1D_p];
    non0ToTc_1D = [non0ToTc_1D, non0ToTc_1D_p];
    %Number of Occurances
    ToT_prob = hist(non0ToT_1D,(1:1:max(non0ToT_1D)));
    ToTc_prob = hist(non0ToTc_1D,(1:1:max(non0ToTc_1D)));
    % Occurances normalized to probability
    ToT_prob = ToT_prob/sum(ToT_prob);
    ToTc_prob = ToTc_prob/sum(ToTc_prob);
    % 3) Save clustering statistics to file for later use
    if(statistics_to_file)
        occupancy = [length(occupancy_per_degree),occupancy_per_degree];
        degree1ToA = [length(degree1ToA_prob),degree1ToA_prob];
        degree2ToA = [length(degree2ToA_prob),degree2ToA_prob];
        degree3ToA = [length(degree3ToA_prob),degree3ToA_prob];
        ToT_probf = [length(ToT_prob),ToT_prob];
        ToTc_probf = [length(ToTc_prob),ToTc_prob];
        % Determine filename
        write_to = '../statistics_data/alpha_notall.txt';
        % Size of occupancy + Occupancy from degree 1 to 3
        dlmwrite(write_to,occupancy,'delimiter',',');
        % Size of 1st degree ToA prob dist + 1st degree ToA probabilities
        dlmwrite(write_to,degree1ToA,'-append','delimiter',',');
        % Size of 2nd degree ToA prob dist + 2nd degree ToA probabilities
        dlmwrite(write_to,degree2ToA,'-append','delimiter',',');
        % Size of 3rd degree ToA prob dist + 3rd degree ToA probabilities
        dlmwrite(write_to,degree3ToA,'-append','delimiter',',');
        % Size of diffusion ToTs + diffusion ToT probabilities
        dlmwrite(write_to,ToT_probf,'-append','delimiter',',');
        % Size of center ToTs + center ToT probabilities
        dlmwrite(write_to,ToTc_probf,'-append','delimiter',',');
    end
end

toc() % Measure elaspsed time

