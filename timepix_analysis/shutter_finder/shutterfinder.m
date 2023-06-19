filename = 'test1'; %100 us
file_ext = 'pmf';
% noise = [];
% for i= 1:1:99
%     Events = dlmread(strcat(filename, num2str(i),'.',file_ext,'_Event.',file_ext),' ');
%     noise(i) = sum(sum(Events>0));
% end
% figure(1)
% hold on
% plot(noise)
% 
% filename = 'test2'; %10 us
% file_ext = 'pmf';
% noise2 = [];
% for i= 1:1:99
%     Events = dlmread(strcat(filename, num2str(i),'.',file_ext,'_Event.',file_ext),' ');
%     noise2(i) = sum(sum(Events>0));
% end
% plot(noise2,'r')
% 
% filename = 'test3'; %1 us
% file_ext = 'pmf';
% noise3 = [];
% for i= 1:1:99
%     Events = dlmread(strcat(filename, num2str(i),'.',file_ext,'_Event.',file_ext),' ');
%     noise3(i) = sum(sum(Events>0));
% end
% plot(noise3,'g')
% 
% 
% filename = 'test4'; %100 ns
% file_ext = 'pmf';
% noise4 = [];
% for i= 1:1:99
%     Events = dlmread(strcat(filename, num2str(i),'.',file_ext,'_Event.',file_ext),' ');
%     noise4(i) = sum(sum(Events>0));
% end
% plot(noise4,'c')

filename = 'test5'; %25 ns
file_ext = 'pmf';
noise5 = [];
for i= 1:1:99
    Events = dlmread(strcat(filename, num2str(i),'.',file_ext,'_Events.',file_ext),' ');
    noise5(i) = sum(sum(Events>0));
    if(sum(sum(Events==38)))
        disp 'Happy Ending'
    end
end
% plot(noise5,'k')
% legend
% 
% hold off