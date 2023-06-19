function [ slope,error ] = leastSquareSolve( x,y, n)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
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

plot(x,y,'*','Color','red');
x2 = linspace(min(x3),max(x3),1000);
y2 = polyval(c,x2);
y6 = polyval(c,x3);
x4 = (x2 ) * (max(x) - min(x)) + min(x);
y4 = (y2 ) * (max(y) - min(y)) + min(y);
slope = (y4(end)-y4(1))/(x4(end)-x4(1))
%slope = slope^-1;
y7 = (y6 ) * (max(y) - min(y)) + min(y);
error = mean(abs(y7 - y'));
x5 = (max(x4) + min(x4)) * 0.5;
y5 = (max(y4) + min(y4)) * (0.5-0.1*sign(c(1)));

hold on
plot(x4,y4);
axis([0,1.05*max(x),0,1.05*max(y)])
plot(x4,y4 - error,'k--');
plot(x4,y4 + error,'k--');
%text(x5,y5,['Slope : ', num2str(slope)])
%text(x5,y5,{['Slope : ', num2str(c(1))];['Cuts y axis at : ', num2str(c(2))]});
hold off

end

