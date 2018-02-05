% test_load_qucs_data
clc
clear
close all

filePath = './Test_PRJ';
fileName = 'main.dat';

[S,Z0,f] = readQucsSparams(fullfile(filePath,fileName));

write_snp('test_ts',S,f,'Z0',Z0);