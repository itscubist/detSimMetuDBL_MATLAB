%% License and Information
% Author: Baran Bodur
% Timepix3 Different Flux Simulator:
% Using the clustering, ToA, adn ToT statistics from a given Tpx3
% measurement, generate a frame based pixel data for a different flux
% of the same particle with same energy deposition with same Tpx3
% acquisition parameters (mainly threshold and Ikrum)
% shutter length, number of frames, and flux could be different of course

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

%ToA Format and Acquisiton Time used in Timepix3
ToA_format = 1; % 0 for clock cycle, 1 for ns
shutter_length = 250000; % in ns or clock cycle(25 MHz) depending on ToA format

% Options
save_file = 1;

%Simulation Parameters
flux = 0.01; % per cm2 per ns
step = 5; % ns
negative_time = 800; % Detector might count previous hits, this effect
% should be included for better accuracy in simulation
% choose this value greater than maximum possible ToT value.
max_event = 100; % Choose wisely max events per (no_of_frames*chip per step)
%% Obtain clustering, ToA and ToT statistics
stat_filename = '../statistics_data/alpha_all.txt'; % Choose stat file
stat_matrix = dlmread(stat_filename,','); % Read file
% Find length of given arrays (by default each row is a different array)
occupancy_per_degree_size = stat_matrix(1,1);
degree1ToA_dist_size = stat_matrix(2,1);
degree2ToA_dist_size = stat_matrix(3,1);
degree3ToA_dist_size = stat_matrix(4,1);
sideToT_size = stat_matrix(5,1);
centerToT_size = stat_matrix(6,1);
% Get data into related arrays
occupancy_per_degree = stat_matrix(1,2:(occupancy_per_degree_size+1));
degree1ToA_prob = stat_matrix(2,2:(degree1ToA_dist_size+1));
degree2ToA_prob = stat_matrix(3,2:(degree2ToA_dist_size+1));
degree3ToA_prob = stat_matrix(4,2:(degree3ToA_dist_size+1));
sideToT = stat_matrix(5,2:(sideToT_size+1));
centerToT = stat_matrix(6,2:(centerToT_size+1));
neighbouring_degree = 3; % Statistics saved this way

%% Generate Hits
hit_ns_pixel = pixel_area*flux;
[ToT,ToA,hit_count,missed_hit] = hitandcluster(hit_ns_pixel, intr_row_size,...
    intr_column_size,row_size,column_size, shutter_length, negative_time,...
    occupancy_per_degree, degree1ToA_prob, degree2ToA_prob, degree3ToA_prob,...
    sideToT,centerToT,step,neighbouring_degree,max_event);

hit_count
flux_simulated = hit_count/(row_size*column_size*pixel_area*shutter_length*10^-9)
missed_hit
%% Generate 25 ns Clock ToA and fToA (real Tpx3 Output)

%% Save Simulation Results
if (save_file)
    write_to = '../simulation_output/flux1e7_alpha_250000nsshutter_20frame';
    file_ext = 'pmf';
    dlmwrite(strcat(write_to,'.',file_ext,'_ToT.',file_ext),ToT,...
        'delimiter',' ');
    dlmwrite(strcat(write_to,'.',file_ext,'_ToA.',file_ext),ToA,...
        'delimiter',' ');
end
toc() % Measure Elapsed Time