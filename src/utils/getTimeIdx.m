% Get index of real time from observation time
function idx = getTimeIdx(Geo, tobs)
	idx = find(Geo.time == tobs);
end