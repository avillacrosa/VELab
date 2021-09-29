%--------------------------------------------------------------------------
% Check if all the fields in the structure default_struct are also in
% read_struct. If not, create a new field on read_struct with the value on
% default_struct
%--------------------------------------------------------------------------
function read_struct = addDefault(read_struct, default_struct)

    fields = fieldnames(default_struct);
    for f = 1:numel(fields)
        f_name = fields{f};
        if ~isfield(read_struct, f_name)
             read_struct.(f_name) = default_struct.(f_name);
        end
    end
    
end