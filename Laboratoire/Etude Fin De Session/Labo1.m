clc 
clear all
close all
warning off

%% E1
load("DonneesIdentifSyst1erOrdre_1.mat");

dt = t(2)-t(1);

Y = y(1:end-1);
X1 = u;
X2 = diff(y)/dt;

X = [X1(1:end-1), X2];

A = pinv(X)*Y;

K = A(1);
Tau = -A(2);

%% E2
clc 
close all
clear all

num1 = [2 6.4];
den1 = [1 8];

num2 = [25];
den2 = [1 14.8 61.7 47 25];

num3 = [3];
den3 = [1 3];

TF1 = tf(num1, den1);
TF2 = tf(num2, den2);
TF3 = tf(num3, den3);

TF_Total = TF1 * TF2 * TF3;
[num, den] = tfdata(TF_Total, 'v');

[r, p, k] = residue(num, den);

poids = abs(r)./(abs(real(p)));

TF1 = tf([r(5)], [1 -p(5)]);
TF2 = tf([r(6)], [1 -p(6)]);

TF_Total_residu = TF1 + TF2;

F1 = dcgain(TF_Total);
F2 = dcgain(TF_Total_residu);

Gain = F1/F2;

% figure
% hold on
% step(TF_Total, "red")
% step(Gain * TF_Total_residu, "blue")
% legend(["Total", "Residues"])

%% E3
clc
close all
clear all

t = [0:0.01:25]';
u = zeros(size(t));
u((t >= 0) &(t < 2)) = 2;
u((t >= 2)) = 0.5;

TF = tf([1 2], [1 1 0.25]);

% lsim(TF,u,t)

%% E4
clc
close all
clear all

num = [1 3 4];
den = [1 4 6 44 80];

TF = tf(num, den);

figure
pzmap(TF)

figure
impulse(TF)

%% E5 
clc
clear all
close all

A = [-2 -2.5 -0.5;
      1    0    0;
      0    1    0];

B = [1;
     0;
     0];

C = [0 1.5 1];

D = [0];

sys = ss(A, B, C, D);

X0 = [1 0 2]';

% figure
% step(TF)

t = [0:0.01:30]';
u = zeros(size(t));
u((t >= 0) & (t <= 2)) = 2;
u((t > 2)) = 0.5;

figure
hold on
grid on
[y,tOut,x,pOut] = lsim(sys,u,t, X0);
plot(tOut, x)
xlim([0, 30])



