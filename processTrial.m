function processTrial(working_dir, trial_name)
start_path=pwd();
cObject = onCleanup(@()cd(start_path));
if(~checkForDir(working_dir))
    return;
end
cd(working_dir);
trial_dir=[trial_name '_processed'];
if(~exist(trial_dir,'dir'))
    disp(['directory ' trial_dir ' does not exist in ' working_dir]);
    return;
end
cd(trial_dir);
BRAIN_DIR='brain';
OUTER_DIR='outer';
INNER_DIR='inner';
src_dirs={BRAIN_DIR,OUTER_DIR,INNER_DIR};
IN_DIR='in';
OUT_DIR='out';
dst_dirs={IN_DIR,OUT_DIR};
if(~checkForDirs(src_dirs))
    return;
end
for i=1:size(dst_dirs,2)
    if(~exist(dst_dirs{i},'dir'))
        mkdir(dst_dirs{i});
    end
end
% Finished Checking/Making Filesytem - ready to correlate
BRAIN_FILES=getNodeFiles(BRAIN_DIR);
INNER_FILES=getNodeFiles(INNER_DIR);
OUTER_FILES=getNodeFiles(OUTER_DIR);
total=length(INNER_FILES)+length(OUTER_FILES);
counter=0;
% Find last completed correlation
i_low=1;
i_high=length(INNER_FILES);
i_mid=1;
j_mid=1;
j_low=1;
j_high=length(BRAIN_FILES);    
while(i_low<=i_high)
    i_mid = idivide(int32(i_high+i_low),2,'floor');
    if(alreadyDone(IN_DIR,INNER_FILES{i_mid},BRAIN_FILES{j_low})&& ...
            ~alreadyDone(IN_DIR,INNER_FILES{i_mid},BRAIN_FILES{j_high}))
        % Somewhere on this external node
        counter = counter+i_mid;
        disp([num2str(double(counter)/total*100) '%']);
        break
    else
        if(alreadyDone(IN_DIR,INNER_FILES{i_mid},BRAIN_FILES{j_low}))
           % After this external node
           i_low=i_mid+1;
        else
           % Before this external node
           i_high=i_mid-1;
        end
    end
    
end
while(j_low<=j_high)
    j_mid =  idivide(int32(j_high+j_low),2,'floor');
    if(alreadyDone(IN_DIR,INNER_FILES{i_mid},BRAIN_FILES{j_mid}))
        if(j_mid==length(BRAIN_FILES) || ~alreadyDone(IN_DIR,INNER_FILES{i_mid},BRAIN_FILES{j_mid+1}))
            break;
        else
            j_low=j_mid+1;
        end
    else
        j_high=j_mid-1;
    end
end
if(~alreadyDone(IN_DIR,INNER_FILES{i_mid},BRAIN_FILES{j_mid}))
    for i=i_mid:length(INNER_FILES)
        for j=j_mid:length(BRAIN_FILES)
            infl=fullfile(pwd(),INNER_DIR,INNER_FILES{i});
            brainf=fullfile(pwd(),BRAIN_DIR,BRAIN_FILES{j});
            [outputf,n1,n2]=getOutName(INNER_FILES{i},BRAIN_FILES{j});
            outputfullf=fullfile(pwd(),IN_DIR,outputf);
            correlate(infl,brainf, outputfullf, n1, n2);
        end
        counter = counter+1;
        disp([num2str(double(counter)/total*100) '%']);
    end
else
    counter = counter + i_mid;
    disp([num2str(double(counter)/total*100) '%']);
end

%OUTER FILES

i_low=1;
i_high=length(OUTER_FILES);
i_mid=1;
j_mid=1;
j_low=1;
j_high=length(BRAIN_FILES);    
while(i_low<=i_high)
    i_mid = idivide(int32(i_high+i_low),2,'floor');
    if(alreadyDone(OUT_DIR,OUTER_FILES{i_mid},BRAIN_FILES{j_low})&& ...
            ~alreadyDone(OUT_DIR,OUTER_FILES{i_mid},BRAIN_FILES{j_high}))
        % Somewhere on this external node
        counter = counter+i_mid;
        disp([num2str(double(counter)/total*100) '%']);
    else
        if(alreadyDone(OUT_DIR,OUTER_FILES{i_mid},BRAIN_FILES{j_low}))
           % After this external node
           i_low=i_mid+1;
        else
           % Before this external node
           i_high=i_mid-1;
        end
    end
    
end
while(j_low<=j_high)
    j_mid =  idivide(int32(j_high+j_low),2,'floor');
    if(alreadyDone(OUT_DIR,OUTER_FILES{i_mid},BRAIN_FILES{j_mid}))
        if(j_mid==length(BRAIN_FILES) || ~alreadyDone(OUT_DIR,OUTER_FILES{i_mid},BRAIN_FILES{j_mid+1}))
            break;
        else
            j_low=j_mid+1;
        end
    else
        j_high=j_mid-1;
    end
end
if(~alreadyDone(OUT_DIR,OUTER_FILES{i_mid},BRAIN_FILES{j_mid}))
    for i=i_mid:length(OUTER_FILES)
        for j=j_mid:length(BRAIN_FILES)
            infl=fullfile(pwd(),OUTER_DIR,OUTER_FILES{i});
            brainf=fullfile(pwd(),BRAIN_DIR,BRAIN_FILES{j});
            [outputf,n1,n2]=getOutName(OUTER_FILES{i},BRAIN_FILES{j});
            outputfullf=fullfile(pwd(),OUT_DIR,outputf);
            correlate(infl,brainf, outputfullf, n1, n2);
        end
        counter = counter+1;
        disp([num2str(double(counter)/total*100) '%']);
    end
else
    counter = counter + i_mid;
    disp([num2str(double(counter)/total*100) '%']);
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

function [outname, node1,node2] = getOutName(extFile, brnFile)
n1=extFile(5:length(extFile));
n2=brnFile(5:length(brnFile));
outname=[n1 '_' n2];
node1=n1;
node2=n2;
end

function r = alreadyDone(d, externn,brainn)
n1=externn(5:length(externn));
n2=brainn(5:length(brainn));
f = fullfile(pwd(),d,[n1 '_' n2]);
r=exist(f,'file');
end