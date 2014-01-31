 function brainNodeHeatMap(BRAIN_NODES,INNER_NODES,OUTER_NODES,LOAD_NODES,LOCATIONS,CORRELATIONS,node)
	node_str = num2str(node);
	if(~ismember(node,BRAIN_NODES))
		disp([node_str ' is not a brain node']);
		return;
	end
	X = zeros(1,length(INNER_NODES)+length(OUTER_NODES));
	Y = X;
	S = 5;
	C = X;
	count = 0;
	for i = 1: length(INNER_NODES)
		count = count+1;
		n_loc = LOCATIONS(num2str(INNER_NODES(i)));
		X(count) = n_loc.x;
		Y(count) = n_loc.y;
		C(count) = getCC(BRAIN_NODES,INNER_NODES,OUTER_NODES,CORRELATIONS,node,INNER_NODES(i));
	end
	for i = 1: length(OUTER_NODES)
		count = count+1;
		n_loc = LOCATIONS(num2str(OUTER_NODES(i)));
		X(count) = n_loc.x;
		Y(count) = n_loc.y;
		C(count) = getCC(BRAIN_NODES,INNER_NODES,OUTER_NODES,CORRELATIONS,node,OUTER_NODES(i));
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