function n_loc = makeLocationsFile(trial)
    n_loc = containers.Map();
    n_loc = getNodesLocs(strcat(trial,'\','inner'),n_loc);
    n_loc = getNodesLocs(strcat(trial,'\','outer'),n_loc);
    n_loc = getNodesLocs(strcat(trial,'\','brain'),n_loc);
    save(strcat(trial,'\','n_loc'),'n_loc');
end

function n_loc = getNodesLocs(d,n_loc)
dir_n = dir([d '\NODE*']);
nodes = zeros(length(dir_n),3);
for n = 1:length(dir_n)
    n_loc=getloc(d,dir_n(n).name,n_loc);
end
end

function n_loc = getloc(d,node,n_loc)
   f = fopen(strcat(d,'\',node),'r');
   if(f)
   line = fgets(f);
   temp = strsplit(line,',');
   n = node(5:end);
   x = char(temp(1));
   x = str2double(x(2:end));
   y = char(temp(2));
   y = str2double(y(1:end-2));
   n_loc(n)=struct('x',x,'y',y);
   fclose(f);
   else
       
   end
end