function correlate(filename1, filename2, outfile, N1,N2)
%first line: (X,Y) 
%<time>\t<accel>\t<pressure>\t<strain>
%filename1 = strcat('node', num2str(filenum1));
%filename2 = strcat('node', num2str(filenum2));
%open file 1, parse
if(exist(outfile,'file'))
   return; 
end
data1 = dlmread(filename1, '\t', 1, 0); %reads tab separated data starting at second line
time = data1(:,1);
time(3);
press_1 = data1(:,3);

%open file 2, parse
data2 = dlmread(filename2, '\t', 1, 0);

accel_2 = data2(:,2);
press_2 = data2(:,3);
strain_2 = data2(:,4);


[delay1, coeff1] = Timedelay(time, press_1, accel_2);
[delay2, coeff2] = Timedelay(time, press_1, press_2);
[delay3, coeff3] = Timedelay(time, press_1, strain_2);
cleanupObject = onCleanup(@()cleanUp(outfile, N1,N2,delay1,delay2,delay3,coeff1,coeff2,coeff3));


end

function cleanUp(outfile, N1, N2, delay1, delay2, delay3, coeff1,coeff2,coeff3)
f = fopen(outfile, 'w+');
if (f~=-1)
    fprintf(f,'%s,%s,%f,%f,%f,%f,%f,%f',N1,N2,coeff1,delay1,coeff2,delay2,coeff3,delay3);
end
    fclose(f);
end