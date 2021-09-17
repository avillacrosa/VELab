clc; close all;

addpath(genpath('src'))

% geo_file = input('> Geometry file path (if left blank, assume ./geo.dat): ', 's');
% mat_file = input('> Material file path (if left blank, assume ./mat.dat): ', 's');
% set_file = input('> Settings file path (if left blank, assume ./set.dat): ', 's');

% if isempty(geo_file)
    geo_file = 'geo.dat';
% end

% if isempty(mat_file)
    mat_file = 'mat.dat';
% end

% if isempty(set_file)
    set_file = 'set.dat';
% end

Result = run(geo_file, mat_file, set_file);
