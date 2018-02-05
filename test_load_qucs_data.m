% test_load_qucs_data
clc
clear
close all

filePath = '/home/gadi/.qucs/Test_S_Params_prj';
fileName = 'main.dat';

[S,Z0,f] = readQucsSparams(fullfile(filePath,fileName));

% Extract sub matrices for mirror and single measurement
S_mirror = S(1:2,1:2,:);
S_1 = S(3,3,:);

% Extract exponent
E2 = S_mirror(1,2,:);

% De-Embed
S_deembed = S_1./E2;

% Extract impedances of de-embedded load
Z_deembed = Z0*(1+S_deembed(:))./(1-S_deembed(:));

% Resistive part
R = 1./real(1./Z_deembed);
% Imaginary part
Y_C = imag(1./Z_deembed);
C = Y_C./(2*pi*f);

figure;
subplot(2,1,1);
plot(f/1e9,R);
set(gca,'ylim',[0 50]);
set(gca,'fontsize',16);
xlabel('f [GHz]','fontsize',18);
ylabel('R [\Omega]','fontsize',18);
subplot(2,1,2);
plot(f/1e9,C/1e-12);
set(gca,'ylim',[0 5]);
set(gca,'fontsize',16);
xlabel('f [GHz]','fontsize',18);
ylabel('C [pF]','fontsize',18);