function [used_keyw, ranges] = usedKeyw(dataf, keyw)
    used_keyw   = strings(0);
    ranges        = zeros(0, 2);

    for k = 1:size(keyw,2)
        found = find(contains(dataf, keyw(k)));
        if found ~= -1
            ranges(end+1,1) = found;
            used_keyw(end+1) = keyw(k);
        end
    end
    
    [ranges,sort_idx] = sort(ranges,1);
    used_keyw = used_keyw(sort_idx(:,1));
    
    ranges(:,2)   = circshift(ranges(:,1)-1,-1);
    ranges(end,2) = size(dataf,2);
end