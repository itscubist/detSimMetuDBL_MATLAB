% A function that gives the sigma of a gaussian distributed electrons in 2D
% after their creation in a single point with given diffusion constant and
% time
% Variables:
% time: Time in ns after the creation of electrons
% diffusion_constant: electron diffusion constant of a material in units of
% um^2/ns

function diffusion_sigma = rotsym_electron_diff(diffusion_constant, time)
    diffusion_sigma = sqrt(2*diffusion_constant*time);
end