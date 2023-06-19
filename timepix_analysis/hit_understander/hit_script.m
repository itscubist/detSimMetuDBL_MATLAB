clear all
close all
row_size = 256;
column_size = 256;
filename = 't2';
file_ext = 'pmf';
Hits = dlmread(strcat(filename,'.',file_ext,'_Hit.',file_ext),' ');
c1 = cell(1,256);
for i = 1:1:256
    for j = 1:1:256
        if (Hits(j,i) ~= 0)
            c1{i} = [c1{i},Hits(j,i)];
        end
    end
end