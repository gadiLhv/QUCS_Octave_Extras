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

% Convert S matrix to ABCD matrix
M_mirror = convS2ABCD(S_mirror,Z0);

% Cosine of the double phase
cosh_2gl = M_mirror(1,1,:);
% Sine of the double phase. Need to choose the Riemann plane carefully
sinh_2gl_1 = sqrt(cosh_2gl.^2-1);
sinh_2gl_2 = sinh_2gl_1.*exp(1i*pi);

% Decide which solution is viable with attenuation demand
exp_2gl_1 = cosh_2gl - sinh_2gl_1;
exp_2gl_2 = cosh_2gl - sinh_2gl_2;

figure('position',[124    281   1297    420]);
plot([f(:) f(:)]/1e9,abs([exp_2gl_1(:) exp_2gl_2(:)]),'linewidth',3);
%set(gca,'ylim',[30 50]);
set(gca,'fontsize',16);
xlabel('f [GHz]','fontsize',18);
ylabel('|e^{-\gamma l}|','fontsize',18);
hdl = legend('Solution 1','Solution 2');
set(hdl,'location','east');

% Choose correct solution with attenuation condition
sinh_2gl = (abs(exp_2gl_1) < 1).*sinh_2gl_1 + (abs(exp_2gl_2) < 1).*sinh_2gl_2;

% Characteristic impedance. Use real in case of any residual numeric error
Zc = real(-M_mirror(1,2,:)./sinh_2gl);

figure;
plot(f(:)/1e9,Zc(:));
set(gca,'ylim',[30 50]);
set(gca,'fontsize',16);
xlabel('f [GHz]','fontsize',18);
ylabel('Z_c [\Omega]','fontsize',18);

% Mean result, to receive a stable scalar
Zc = mean(Zc(:));
fprintf(1,'Characteristic impedance of T-line: %.2f [Ohm]\n',Zc);

% Now all that is left is disect the phase\loss into two, same as before
exp_gl = sqrt(cosh_2gl + sinh_2gl);
cosh_gl = 0.5*(exp_gl + 1./exp_gl);
sinh_gl = 0.5*(exp_gl - 1./exp_gl);

% Build de-embedding matrix
D = 2*cosh_gl - (Zc/Z0 + Z0/Zc)*sinh_gl;
S_l_11 = -(Zc/Z0 - Z0/Zc)*sinh_gl./D;
S_l_12 = 2./D;

S_l = [[S_l_11 S_l_12] ; [S_l_12 S_l_11]];

%% Extract exponents

% De-embed reflection coefficient
S_deembed = (S_1 - S_l(1,1,:))./(S_l(2,2,:).*(S_1 - S_l(1,1,:)) + S_l(1,2,:).*(S_l(2,1,:)));

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