function [ slope ] = leastSquareSolve2( x,y, n)

b = zeros(length(x),n +1);
x3 = (x - min(x)) / (max(x) - min(x));
y3 = (y - min(y)) / (max(y) - min(y));
x3 = x3';
y3 = y3';
temp = ones(1,length(x))';
for i = n : -1 : 0
    b(:,i + 1) = temp;
    temp = temp .* x3;
end
c = linsolve(b,y3);
x2 = linspace(min(x3),max(x3),1000);
y2 = polyval(c,x2);
y6 = polyval(c,x3);
x4 = (x2 ) * (max(x) - min(x)) + min(x);
y4 = (y2 ) * (max(y) - min(y)) + min(y);
slope = (y4(end)-y4(1))/(x4(end)-x4(1));
%slope = slope^-1;

end