%load time4
%load signal2

A = [time4; signal2];
header1 = 'x-axis,WaveGen-ARB';
header2 = 'second,Volt';

fid = fopen('togen1e10.csv','w');
fprintf(fid, [ header1 '\n' header2 '\n']);
fprintf(fid,'%4.2fE-009,%4.4fE+00\n',A);
fclose(fid);