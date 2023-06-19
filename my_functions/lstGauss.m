% Author: Baran Bodur and Serhan Yılmaz
% Least Square Fit to Partial Gaussians

function [final, fit] = lstGauss(guess, data, index, fit_index, max_it, ...
    min_fix)

it = 0; % Initialize number of iterations
while(1)
    it=it+1; % Count iterations
    fit_cur = guess(1)*exp(-(index-guess(2)).^2/(2*guess(3)^2))+guess(4);
    diff = (data - fit_cur)'; % Find difference from the data
    % Calculate derivatives
    der1 = (exp(-(index-guess(2)).^2/(2*guess(3)^2)))';
    der2 = ((index-guess(2))/(guess(3)^2).*...
        (guess(1)*exp(-(index-guess(2)).^2/(2*guess(3)^2))))';
    der3= ((index-guess(2)).^2/(guess(3)^3).*...
        (guess(1)*exp(-(index-guess(2)).^2/(2*guess(3)^2))))';
    der4 = ones(1,length(index))';
    der = [der1,der2,der3,der4];
    correction = linsolve(der,diff); % Find correction for this iteration
    guess = guess + correction; % Add correction
    fix = sum(correction.*correction); 
    if(fix<min_fix) % break when desired precision is achieved
        break;
    end
    if(it>max_it) % break when maximum number of iterations reached
        display('Iteration terminated.');
        break;
    end
end
final = guess; % final parameters
fit = guess(1)*exp(-(fit_index-guess(2)).^2/(2*guess(3)^2))+guess(4); %fit


end