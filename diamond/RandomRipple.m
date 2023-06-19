% A function that creates a positive and negative uniformly distributed
% ripple around the center

function output = RandomRipple(input,pos_ripple_perc,neg_ripple_perc)
    total_ripple = pos_ripple_perc + neg_ripple_perc;
    shift = 1 - neg_ripple_perc;
    output = input.*(rand(1,length(input))*total_ripple + shift);
end