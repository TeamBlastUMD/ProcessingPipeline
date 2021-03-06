function LOCATIONS = makeLocationsFile(trial)
    LOCATIONS = containers.Map();
	disp('processing inner node locations');
    LOCATIONS = getNodesLocs(fullfile(trial,'inner'),LOCATIONS);
	disp('processing outer node locations');
    LOCATIONS = getNodesLocs(fullfile(trial,'outer'),LOCATIONS);
	disp('processing brain node locations');
    LOCATIONS = getNodesLocs(fullfile(trial,'brain'),LOCATIONS);
	disp('processing load node locations');
	LOCATIONS = getNodesLocs(fullfile(trial,'load'),LOCATIONS);
    save('locations.mat','LOCATIONS');
end

function LOCATIONS = getNodesLocs(d,LOCATIONS)
dir_n = dir(fullfile(d, 'NODE*'));
nodes = zeros(length(dir_n),3);
for n = 1:length(dir_n)
    LOCATIONS=getloc(d,dir_n(n).name,LOCATIONS);
end
end

function LOCATIONS = getloc(d,node,LOCATIONS)
   f = fopen(fullfile(d,node),'r');
   if(f)
   line = fgets(f);
   temp = strsplit(line,',');
   n = node(5:end);
   x = char(temp(1));
   x = str2double(x(2:end));
   y = char(temp(2));
   y = str2double(y(1:end-2));
   LOCATIONS(n)=struct('x',x,'y',y);
   fclose(f);
   else
       
   end
end