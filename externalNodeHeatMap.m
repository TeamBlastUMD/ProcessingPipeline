 function externalNodeHeatMap(BRAIN_NODES,INNER_NODES,OUTER_NODES,LOAD_NODES,LOCATIONS,CORRELATIONS,node)
	node_str = num2str(node);
	if(~ismember(node,INNER_NODES))
		if(~ismember(node,OUTER_NODES))
			disp([node_str ' is not an external node']);
			return;
		end
	end
	X = zeros(1,length(BRAIN_NODES));
	Y = X;
	S = 5;
	C = X;
	total = length(INNER_NODES)+length(OUTER_NODES);
	for i = 1: length(BRAIN_NODES)
		n_loc = LOCATIONS(num2str(BRAIN_NODES(i)));
		X(i) = n_loc.x;
		Y(i) = n_loc.y;
		C(i) = getCC(BRAIN_NODES,INNER_NODES,OUTER_NODES,CORRELATIONS,BRAIN_NODES(i),node);
	end
	hold on
	% draw helmet
	theta = 0:.01:pi;
	y = .152*exp(1j*theta);
	fill(real(y),imag(y),'blue','EdgeColor','blue');
	y = .133*exp(1j*theta);
	fill(real(y),imag(y),'white','EdgeColor','white');
	%draw skull
	radius = .095;
	rectangle('Position',[- radius, - radius, radius*2, radius*2],'Curvature',[1,1],'FaceColor','black');
	radius = .085;
	rectangle('Position',[- radius, - radius, radius*2, radius*2],'Curvature',[1,1],'FaceColor','white');
	caxis([0 1]);
	scatter(X,Y,S,C,'fill');
	b_loc = LOCATIONS(node_str);
	scatter(b_loc.x,b_loc.y,20,'black','fill');
	b_loc = LOCATIONS(num2str(LOAD_NODES(1)));
	scatter(b_loc.x,b_loc.y,100,'black','*');
	hold off
 end