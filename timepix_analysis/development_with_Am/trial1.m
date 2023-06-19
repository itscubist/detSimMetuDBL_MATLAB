set(gca,'FontSize',30,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',30,'fontWeight','bold')
% First obtain the data
row_size = 256;
column_size = 256;
filename = 't3';
file_ext = 'txt';
Events = dlmread(strcat(filename,'.',file_ext,'_Event.',file_ext),' ');
iToT = dlmread(strcat(filename,'.',file_ext,'_iToT.',file_ext),' ');
ToTperEvent = iToT./Events;
%ToTperEvent_1D = TwotoOneD(ToTperEvent);

%Then clean the data from weird pixels
mean_sum = 0;
mean_square_sum = 0;
sum_count = 0;
ignored_pixels = zeros(256); % remember ignored pixels
for r = 1:1:row_size
    for c = 1:1:column_size
        if(ToTperEvent(r,c) == Inf || isnan(ToTperEvent(r,c)))
            ToTperEvent(r,c) = 0;
            iToT(r,c) = 0;
            Events(r,c) = 0;

        else
            mean_sum = mean_sum + ToTperEvent(r,c);
            mean_square_sum = mean_square_sum + ToTperEvent(r,c)^2;
            sum_count = sum_count + 1;
        end
    end
end
mean_ToTperEvent = mean_sum/sum_count;
std_ToTperEvent = sqrt(mean_square_sum/sum_count - mean_ToTperEvent^2);
k = 1;
t1 = 1;
t2 = 1;
%t3 = 1;
%t4 = 1;
%t5 = 1;
ToTperEvent_1D = [];
ToT1Event = [];
ToT2Event = [];
%ToT3Event = [];
%ToT4Event = [];
%ToT5Event = [];
for r = 1:1:row_size
    for c = 1:1:column_size
        if(ToTperEvent(r,c) > (mean_ToTperEvent + 1*std_ToTperEvent))
            ToTperEvent(r,c) = 0;
            iToT(r,c) = 0;
            Events(r,c) = 0;
            ignored_pixels(r,c) = 1;
        elseif(ToTperEvent(r,c) ~= 0)
            ToTperEvent_1D(k) = ToTperEvent(r,c);
            k = k + 1;
        end
        if(Events(r,c) == 1)
            ToT1Event(t1) = iToT(r,c);
            t1 = t1 + 1;
        elseif(Events(r,c) == 2)
            ToT2Event(t2) = iToT(r,c);
            t2 = t2 + 1;
        end
    end
end
iToT_1D = TwotoOneD(iToT);
Events_1D = TwotoOneD(Events);
%Plotting
figure(1)
hist(iToT_1D(iToT_1D>0),20)
title('iToT Histogram')
figure(2)
hist(ToTperEvent_1D,20)
title('ToT per Event Histogram')
figure(3)
hist(Events_1D(Events_1D>0))
title('Event Histogram')
figure(4)
hist(ToT1Event,20)
title('Histogram of 1 Event iToTs')
figure(5)
hist(ToT2Event,20)
title('Histogram of 2 Event iToTs')
xlabel('iToT')
ylabel('Count')


