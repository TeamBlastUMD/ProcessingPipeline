function LOCATIONS = makeLocationsFile(trial)
    LOCATIONS = containers.Map();
    LOCATIONS = getNodesLocs(strcat(trial,'\','inner'),LOCATIONS);
    LOCATIONS = getNodesLocs(strcat(trial,'\','outer'),LOCATIONS);
    LOCATIONS = getNodesLocs(strcat(trial,'\','brain'),LOCATIONS);
	LOCATIONS = getNodesLocs(strcat(trial,'\','load'),LOCATIONS);
    save(strcat(trial,'\','LOCATIONS'),'LOCATIONS');
end

function LOCATIONS = getNodesLocs(d,LOCATIONS)
dir_n = dir([d '\NODE*']);
nodes = zeros(length(dir_n),3);
for n = 1:length(dir_n)
    LOCATIONS=getloc(d,dir_n(n).name,LOCATIONS);
end
end

function LOCATIONS = getloc(d,node,LOCATIONS)
   f = fopen(strcat(d,'\',node),'r');
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