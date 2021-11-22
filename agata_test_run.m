data_dir = 'data/AGATA_TEST';
us_dir   = [data_dir, filesep(), 'Displacements'];
ts_dir   = [data_dir, filesep(), 'Tractions'];

usl = dir(us_dir);
tsl = dir(ts_dir);

for i = 3:size(usl, 1)
    usl(i)
end