function processTrial(working_dir, trial_dir, trial_name)
start_path=pwd();
cObject = onCleanup(@()cd(start_path));
if(~checkForDir(working_dir))
    return;
end
cd(working_dir);
if(~exist(trial_dir,'dir'))
    disp(['directory ' trial_dir ' does not exist in ' working_dir]);
    return;
end
cd(trial_dir);
% Info File
infoFile = fullfile('info.mat');
if(~exist(infoFile,'file'))
    NAME=trial_name;
    save(infoFile,'NAME');
else
    disp(['found ' infoFile]);
    load(infoFile); 
end
% Node Numbers
nodeFile = 'nodes.mat';
if(~exist(nodeFile,'file'))
    BRAIN_DIR='brain';
    LOAD_DIR='load';
    OUTER_DIR='outer';
    INNER_DIR='inner';
    src_dirs={BRAIN_DIR, LOAD_DIR, OUTER_DIR,INNER_DIR};
    if(~checkForDirs(src_dirs))
        return;
    end
    BRAIN_FILES=getNodeFiles(BRAIN_DIR);
    LOAD_FILES=getNodeFiles(LOAD_DIR);
    INNER_FILES=getNodeFiles(INNER_DIR);
    OUTER_FILES=getNodeFiles(OUTER_DIR);
    disp(['found ' num2str(length(BRAIN_FILES)) ' brain nodes']);
    disp(['found ' num2str(length(LOAD_FILES)) ' load nodes']);
    disp(['found ' num2str(length(INNER_FILES)) ' inner nodes']);
    disp(['found ' num2str(length(OUTER_FILES)) ' outer nodes']);
    BRAIN_NODES = getNodeNumbers(BRAIN_FILES);
    LOAD_NODES = getNodeNumbers(LOAD_FILES);
    INNER_NODES = getNodeNumbers(INNER_FILES);
    OUTER_NODES = getNodeNumbers(OUTER_FILES);
    save(nodeFile,'BRAIN_NODES','LOAD_NODES','INNER_NODES','OUTER_NODES');
    disp(['saved node numbers in ' nodeFile]);
else
    disp(['found ' nodeFile]);
    load(nodeFile); 
end

% Pressure Time Histories
timeHistFile = 'timehist.mat';
if(~exist(timeHistFile))
    PRESSURE = containers.Map;
    PRESSURE = addNodesToMap(PRESSURE,BRAIN_FILES,BRAIN_DIR);
    disp('added brain nodes to map');
    PRESSURE = addNodesToMap(PRESSURE,LOAD_FILES,LOAD_DIR);
    disp('added load nodes to map');
    PRESSURE = addNodesToMap(PRESSURE,INNER_FILES,INNER_DIR);
    disp('added inner nodes to map');
    PRESSURE = addNodesToMap(PRESSURE,OUTER_FILES,OUTER_DIR);
    disp('added outer nodes to map');
    save(timeHistFile,'PRESSURE');
    disp(['saved node time histories in ' timeHistFile]);
    rmdir(BRAIN_DIR,'s');
    rmdir(LOAD_DIR,'s');
    rmdir(INNER_DIR,'s');
    rmdir(OUTER_DIR,'s');
    disp('removed node files');
else
    disp(['found ' timeHistFile]);
    load(timeHistFile);
end

% Cross Correlate
xcorrFile = 'xcorr.mat';
if(~exist(xcorrFile))
    total = length(BRAIN_NODES)*(length(INNER_NODES)+length(OUTER_NODES));
    CORRELATIONS = zeros(1,total);
	BRAIN_STR = strArray(BRAIN_NODES);
	INNER_STR = strArray(INNER_NODES);
	OUTER_STR = strArray(OUTER_NODES);
    count = 0;
    for i = BRAIN_STR
       for j = INNER_STR
           count = count + 1;
           CORRELATIONS(count) = max(xcorr(PRESSURE(j),PRESSURE(i),'coeff'));
           if(mod(count,10000)==0)
                disp([num2str(count*100.0/total) '%   ' num2str(total-count) ' to go. Last coeff = ' num2str(CORRELATIONS(count))) ]);
           end
       end
       for j = OUTER_STR
           count = count + 1;
           CORRELATIONS(count) = max(xcorr(PRESSURE(j),pressure(i),'coeff'));
           if(mod(count,10000)==0)
                disp([num2str(count*100.0/total) '%   ' num2str(total-count) ' to go. Last coeff = ' num2str(CORRELATIONS(count)) ]);
           end
       end
    end
    save(xcorrFile,'CORRELATIONS');
else
    disp(['found ' xcorrFile]);
end

end


function nodeNums = getNodeNumbers(files)
  nodeNums = zeros(1,length(files));
  for i=1:length(files)
      fname = files{i};
      nodeNums(i) = str2double(fname(5:length(fname)));
  end
end

function map = addNodesToMap(map,FILES,dir)
  for i=1:length(FILES)
     FILE = FILES{i};
     f = fullfile(dir,FILE);
     data = dlmread(f, '\t', 1, 0);
     map(FILE(5:length(FILE)))= data(:,3)';
  end
end

function e=checkForDir(d)
e = exist(d,'dir');
if(~e)
    disp(['directory ' d ' does not exist']);
end
end

function e = checkForDirs(d)
e = 1;
for i=1:size(d,2)
    if(~checkForDir(d{i}))
        e = 0;
    end
end
end

function nodes = getNodeFiles(d)
dir_res = dir([d '\NODE*']);
num_nodes = size(dir_res,1);
nodes = cell(1,num_nodes);
for n = 1:num_nodes
    nodes{n}=dir_res(n).name;
end
end

function strA = strArray(ar)
strA = cell(1,length(ar);
	counter = 0;
	for i=ar
		counter = counter+1;
		strA{counter} = num2str(i);
	end
end