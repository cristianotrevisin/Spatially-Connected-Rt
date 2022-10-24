clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS
par.mean_GD = 5.20; 
par.std_GD = 1.72; 
par.k = 21; 
par.delay = 0; 
par.init = 6; 
par.Np = 30000;

par.cv_x_0=0.05;
par.low_cv_x=0.05;

par.flag_r_ok=false;   % if true uses rt in input
par.flag_x_ok=true; % if true uses the csi in input

par.upbnd_p = 0.9;
par.lowbnd_p=0;
par.NItermax=2;
par.alpha_min = 0;
par.tau = 0.9;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load Data
load synthetic_rt.mat
R = R(1:3,:);

% Generate mobility
ResPop = [300000; 450000; 400000];
C = [0.85 0.05 0.1; 0.08 0.72 0.2; 0.13 0.12 0.75]; C = C';
x=1-diag(C); % percentage of moving pop
Q=(C-diag(diag(C)))*diag(1./x); % extradiagonal fluxes



% Perturbate mobility
N = size(Q,1);
t = 0:364;
tf = t + [0; 50; 150];
T = t(end)+1; 
sea = (1-0.8*sin(4*pi*tf/T));
csi = zeros(N,365);

for i = 1:365
    csi(:,i)=x.*sea(:,i); % perturbed p
end

% Generate cases
F = zeros(N,365);
F(:,1:6) = 100;
F = generate_cases(F,par,Q,ResPop,R,csi,6); F=round(F(:,1:365)); 

vect = 0.05:0.05:0.8;
diff = zeros(3,length(vect));
for iter = 1:length(vect)
    par.cv_r_0=vect(iter);
    par.low_cv_r=vect(iter);
    [Rt_out,csi_out,dia,model_out] = pf(F,par,Q,ResPop,R,csi);
    diff(:,iter) = sqrt(sum((R-Rt_out.Q50).^2,2,'omitnan'));
end

figure()
bar(vect,diff')

figure()
bar(vect,sum(diff,1))

