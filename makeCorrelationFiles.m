function makeCorrelationFiles2(trialName)
innerNodes = getNodes([trialName '\inner']);
outerNodes = getNodes([trialName '\outer']);
brainNodes = getNodes([trialName '\brain']);
airNodes = [innerNodes outerNodes];
numAir = length(airNodes);
numBrain = length(brainNodes);

accel = zeros(numAir, numBrain);
press = zeros(numAir, numBrain);
strain = zeros(numAir, numBrain);
accel_t = zeros(numAir, numBrain);
press_t = zeros(numAir, numBrain);
strain_t = zeros(numAir, numBrain);

corr = csvread([trialName '\corr.txt']);
count = 1;
for i=1:length(corr)
        x = corr(i,:);
        row = getRow(x(1),airNodes);
        col = getCol(x(2),brainNodes);
        accel(row,col)=x(3);
        press(row,col)=x(5);
        strain(row,col)=x(7);
        accel_t(row,col)=x(4);
        press_t(row,col)=x(6);
        strain_t(row,col)=x(8);
        count = count+1;
end

%write P-A
csvwrite(strcat(trialName,'\','accel'), accel);
%write P-P
csvwrite(strcat(trialName,'\','press'), press);
%write P-S
csvwrite(strcat( trialName,'\','strain'), strain);

%write P-A
csvwrite(strcat(trialName,'\','accel_t'), accel_t);
%write P-P
csvwrite(strcat(trialName,'\','press_t'), press_t);
%write P-S
csvwrite(strcat(trialName,'\','strain_t'), strain_t);

csvwrite(strcat(trialName,'\','brain_nodes'), brainNodes);
csvwrite(strcat(trialName,'\','external_nodes'),[innerNodes outerNodes]);

end

function nodes = getNodes(d)
dir_n = dir([d '\NODE*']);
num_nodes = size(dir_n,1);
nodes = zeros(1,num_nodes);
for n = 1:num_nodes
    nodes(n)=str2double(dir_n(n).name(5:end));
end
sort(nodes);
end

function col=getCol(n,nodes)
    col = find(nodes==n);
end

function row=getRow(n,nodes)
    row = find(nodes==n);
end