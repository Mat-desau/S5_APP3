%%  S5 - APP3: Formatif
%   Auteur:     Karina Lebel, ing. PhD
%   Date:       12-fev-2020

%   Modifications (Date - initiales - d�tails):

%% D�finition du syst�me
dt = 0.01;
t  = [0:dt:10]';

A = [0  1; -100 -4];
B = [0 1]';
C = [1 0];
D = [0];

sys = ss(A,B,C,D);


%% R�ponse � l'impulsion et � un �chelon de 50

% R�ponse � l'impulsion (version impulse)
figure
impulse(sys)
hold on

% R�ponse � l'impulsion (version lsim)
% Une impulsion est simul�e en envoyant des entr�es nulles avec 
% des conditions initiales �gales � B
u   = zeros(length(t),1);
x0  = B;                    
yI  = lsim(sys, u,t,x0);
plot(t,yI,'r--');

% R�ponse � l'�chelon de 50 (version step)
figure
OPT = stepDataOptions('StepAmplitude',50);
step(sys,t,OPT)
hold on

% R�ponse � l'�chelon (version lsim)
u  = 50*ones(size(t));
x0 = [0 0]';
y  = lsim(sys, u, t, x0); 
plot(t, y,'r--');

%% Simuler la r�ponse des �tats pour une entr�e sp�cifique

% Entr�e
u = zeros(size(t));
u(t<2)  = 100;
u(t>=2) = 20;   %Oups, il manque le plus grand ou �gal dans l'�nonc� mais 
                %on devine qu'on ne veut pas de trou dans l'entr�e... 
% CI
x0 = [0 1]';

% Dans ce probl�me, on vous demande d'observer l'�volution de chacun des
% �tats. Pour ce faire, on doit modifier la matrice C pour faire sortir
% tous les �tats (2 sorties). De m�me, la matrice D doit �tre modifi�e.

Cprime    = [1 0; 0 1];
Dprime    = [0 0]';
sys_prime = ss(A,B,Cprime,Dprime);

yAll  = lsim(sys_prime, u, t, x0); 

figure
plot(t,yAll)
title('R�ponse des �tats pour entr�e u')
xlabel('Temps (s)')
ylabel('Amplitude')
grid on; grid minor;
legend('x1','x2')



