%%  S5 - APP3: Formatif
%   Auteur:     Karina Lebel, ing. PhD
%   Date:       12-fev-2020

%   Modifications (Date - initiales - détails):

%% Définition du système
dt = 0.01;
t  = [0:dt:10]';

A = [0  1; -100 -4];
B = [0 1]';
C = [1 0];
D = [0];

sys = ss(A,B,C,D);


%% Réponse à l'impulsion et à un échelon de 50

% Réponse à l'impulsion (version impulse)
figure
impulse(sys)
hold on

% Réponse à l'impulsion (version lsim)
% Une impulsion est simulée en envoyant des entrées nulles avec 
% des conditions initiales égales à B
u   = zeros(length(t),1);
x0  = B;                    
yI  = lsim(sys, u,t,x0);
plot(t,yI,'r--');

% Réponse à l'échelon de 50 (version step)
figure
OPT = stepDataOptions('StepAmplitude',50);
step(sys,t,OPT)
hold on

% Réponse à l'échelon (version lsim)
u  = 50*ones(size(t));
x0 = [0 0]';
y  = lsim(sys, u, t, x0); 
plot(t, y,'r--');

%% Simuler la réponse des états pour une entrée spécifique

% Entrée
u = zeros(size(t));
u(t<2)  = 100;
u(t>=2) = 20;   %Oups, il manque le plus grand ou égal dans l'énoncé mais 
                %on devine qu'on ne veut pas de trou dans l'entrée... 
% CI
x0 = [0 1]';

% Dans ce problème, on vous demande d'observer l'évolution de chacun des
% états. Pour ce faire, on doit modifier la matrice C pour faire sortir
% tous les états (2 sorties). De même, la matrice D doit être modifiée.

Cprime    = [1 0; 0 1];
Dprime    = [0 0]';
sys_prime = ss(A,B,Cprime,Dprime);

yAll  = lsim(sys_prime, u, t, x0); 

figure
plot(t,yAll)
title('Réponse des états pour entrée u')
xlabel('Temps (s)')
ylabel('Amplitude')
grid on; grid minor;
legend('x1','x2')



