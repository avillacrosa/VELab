function Fa = externalF(type, tx)
    wi  = [1 1];
    wxi = [-1 1]/sqrt(3);

    Fa = zeros(size(tx));
    
    % TODO : Generalize this...
    for a = 1:4
        % Segments of da (square = 4)
        % TODO : J MISSING HERE ?!
        % TODO : load interpolation ?
        for j = 1:2
            
            [N, ~] = fshape(type, [wxi(j), -1]);
            Fa(a,:) = Fa(a,:) + N(a)*wi(j)*tx(1,:);
            
            [N, ~] = fshape(type, [+1, wxi(j)]);
            Fa(a,:) = Fa(a,:) + N(a)*wi(j)*tx(2,:);
            
            [N, ~] = fshape(type, [wxi(j), +1]);
            Fa(a,:) = Fa(a,:) - N(a)*wi(j)*tx(3,:);
            
            [N, ~] = fshape(type, [-1, wxi(j)]);
            Fa(a,:) = Fa(a,:) - N(a)*wi(j)*tx(4,:);
        end
    end     
    Fa = Fa/2;
end