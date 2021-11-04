clc; close all;

addpath(genpath('src'))

% data_f = input('> Data file path (default: ./input_data): ', 's');

mags = 5:5:10;
figure
hold on
for m = mags
    data_f = 'rand_tfm_lin';
    Result_lin = runVE(data_f, m);

    data_f = 'rand_tfm_nl';
    Result_nlin = runVE(data_f, m);
    mlu  = mean(norm(Result_lin.u), 'all');
    mnlu = mean(norm(Result_nlin.u), 'all');
    yyaxis left
    plot(m, Result_nlin.meanStr)
    plot(m, Result_lin.meanStr)
    yyaxis right
    plot(m, Result_nlin.meanStr-Result_lin.meanStr)
end