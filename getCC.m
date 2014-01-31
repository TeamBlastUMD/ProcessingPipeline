function cc = getCC(BRAIN_NODES,INNER_NODES,OUTER_NODES,CORRELATIONS,brain_node,external_node)
	if(~ismember(brain_node,BRAIN_NODES))
		disp('brain node not a brain node');
		return;
	end
	brain_index = find(BRAIN_NODES==brain_node);
	if(ismember(external_node,INNER_NODES))
		external_index = find(INNER_NODES==external_node);
	else 
		if(ismember(external_node,OUTER_NODES))
			external_index = find(OUTER_NODES==external_node);
		else
			disp('external node not an inner or outer node');
			return;
		end
	end
	total = length(INNER_NODES)+length(OUTER_NODES);
	cc = CORRELATIONS((brain_index-1)*total+external_index);
end