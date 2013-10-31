function [ timedelay, coefficient ] = Timedelay(time, w1, w2 )
%UNTITLED3 Summary of this function goes here
%   This function will take in 2 waveform arrays and return the probable
%   time delay between the voltage curves!

%test to see if matrices are the same length
len = length(w1);
len1 = length(w2);
if len~= len1
    display('ERROR: Matrix lengths do not match')
    return;
end


%Now to find the Time Delay once graphs have been overlayed properly
%dt is the time difference and loops until about 3/4 of total length
maxDt = round(len/4);
corr = zeros(0,(2*maxDt+1));

for k = -maxDt:maxDt
    %sets corr value at row 'dt' and root mean squares to zero for each 
    %iteration
    dt = k+maxDt+1;
    shift = abs(k);
    %adds corr(dt) value to the multiple of Waveform1 voltages 
    %at time 't' with Waveform2 voltages at time 't+dt'
   
    % updates root mean square data for each Waveform by adding
    %the squared value of the voltage at each time step (denoted by 'x')
    
    if(k<0) 
        corr(dt) = sum(w1(1:(len-shift)).*w2((1+shift):len));
        rms_f1 = sum(w1(1:(len-shift)).^2);
        rms_f2 = sum(w2((1+shift):len).^2);
    else
        corr(dt) = sum(w2(1:(len-shift)).*w1((1+shift):len));
        rms_f1 = sum(w2(1:(len-shift)).^2);
        rms_f2 = sum(w1((1+shift):len).^2);
    end
    
    %Updates root mean square values by getting the sq. root of previous
    %values
    rms_f1 = sqrt(rms_f1);  %/(n-dt));
    rms_f2 = sqrt(rms_f2);  %/(n-dt));
        %r(dt) = corr(dt)/((n)-dt);

    corr(dt) = corr(dt)/(rms_f1*rms_f2);
   % m
   % dt
   % corr(dt)
end

%correlation coefficient vs time delay
% corr;

%Finds the maximum value that these two waveforms correlate
[~, maxInd] = max(abs(transpose(corr)));
coefficient=corr(maxInd);
if maxInd > (maxDt+1)
    maxInd = maxInd-(maxDt+1);
    timedelay = -time(maxInd);
elseif maxInd <maxDt
    maxInd = (maxDt+1)-maxInd;
    timedelay = time(maxInd);
else
    timedelay = 0;
    return;
end

end
