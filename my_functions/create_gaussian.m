% A function that generates a gaussian with given parameters, it will span
% from -5 to 5 sigma, and will have the given precision, it is advised to
% give at least 0.1*sigma precision.

function [gaussian,index] = create_gaussian(mean,sigma,precision)
    index = -5*sigma : precision : 5*sigma;
    gaussian = 1/(sqrt(2*pi)*sigma) * exp(-((index-mean).^2/(2*sigma^2)));
    gaussian = gaussian/sum(gaussian);
end