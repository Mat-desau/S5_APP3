%%  S5 - APP3: Formatif
%   Auteur:     Karina Lebel, ing. PhD
%   Date:       12-fev-2020

%   Modifications (Date - initiales - d�tails):

%%  Chargement des donn�es : DonneesIdentifMasseRessortAmorti.mat
%   3 variables seront disponibles soit:
%   Vecteur temps, t: 5001x1
%   Vecteur entr�e,Fext: 5001x1
%   Vecteur sortie,x: 5001x1
    close all; clear all
    load DonneesIdentifMasseRessortAmorti

    figure
    subplot(2,1,1)
    plot(t,Fext,'b','linewidth',1.5); grid on; grid minor
    title('Entr�e du syst�me')
    subplot(2,1,2)
    plot(t,x,'r','linewidth',1.5)
    title('R�ponse du syst�me masse-ressort')
    xlabel('Temps (s)')
    grid on; grid minor
    
%% (a) Mod�lisation d'un syst�me...

%  �quation forme g�n�rale: Kwn2/(s2 + 2*zeta*wn s + wn2)
%  Trouvons les valeurs de m, b et k dans l'�quation d'origine qui 
%  permettront de reproduire le comportement du syst�me (graphique)

%  Ici on pourrait d�duire plusieurs param�tres � partir de la simple
%  observation du graphique:
%  (i)  Pour une entr�e de 50N, on stabilise � 0.5... Donc K = 0.01
%  (ii) D�passement max = (0.7633-0.5)/0.5 * 100 = 52.66% => Avec formule
%       de Mp, on trouve que zeta = 0.2
%  (iii)Temps du premier pic = 0.322 = pi/(wn*sqrt(1-zeta2)) => wn =
%       9.9577
%  (iv) On peut r�-�crire l'�quation standard sous la forme de l'�quation 
%       originale: (1/(Kwn2))s2 Y + 2zeta/Kwn sY + (1/K)Y = Fext
%  (v)  Donc m = (1/Kwn2) = 1.0085; b = 4.0170; k = 100
%
    K1    = 0.01;
    zeta1 = 0.2;
    wn1   = 9.9577; 
    Gest1 = tf([K1*wn1*wn1],[1 2*zeta1*wn1 wn1*wn1])
    figure
    [y1,t1] = lsim(Gest1, Fext, t);

    plot(t,x)
    hold on
    plot(t1,y1)
    title('R�ponse mes vs est par graphique')

%   M�thode des moindres carr�s
    % ATTENTION, ICI, LE VECTEUR X inclu entr�e et sorties... x =
    % sorties...
    % Tout d'abord on identifie les vecteurs X tels que: 
    % X1 = u (entr�e) -> Ici, Fext
    % X2 = dy/dt (dsortie) -> ici, la sortie est x (ouf)
    % X3 = d2y/dt2 (on arr�te ici car ordre 2)
    % X  = [X1 X2 X3]
    
    X1 = Fext;
    
    dt = t(2:end) - t(1:end-1); %Plus g�n�ral que t(2)-t(1)... valide peu importe si le dt est cst!
    X2 = diff(x) ./ dt;
    X3 = diff(X2)   ./ (t(3:end)-t(2:end-1));
    
    X  = [X1(1:end-2) X2(1:end-1) X3];  %On enl�ve 2 points � X1 car en calculant X2, 
                                        %on perd l'info du dernier point
                                        %et en calculant X3, celui de
                                        %l'avant-dernier...
                                       
    
    % Identifions maintenant le vecteur de sortie Y
    Y  = x(1:end-2);
    
    
    % On calcule les matrices de corr�lation:
    R  = X' * X; 
    P  = X' * Y;
    
    % Il ne reste qu'� appliquer l'�quation A = R^-1 * P pour trouver les
    % coefficients:
    A = inv(R) * P;
    
    
    % Dans notre cas particulier, lorsque l'on a converti la fonction en
    % forme standard, on trouve que G(s) = (1/m) / (s2 + b/m s + k/m) et 
    % dans la m�thode du moindres carr�s: x = (1/k)Fext - (b/k)s - m/k s2 donc:
    % A(1) vaut 1/k,
    % A(2) vaut -b/k et
    % A(3) vaut -m/k
    k = 1/A(1);
    b = -k*A(2);
    m = -k*A(3);
    
    display(['k = ',num2str(k)])
    display(['b = ',num2str(b)])
    display(['m = ',num2str(m)])

    Gest = tf([1/m],[1 b/m k/m])
    figure
    [y2,t2] = lsim(Gest1,Fext, t);
    
    plot(t,x)
    hold on
    plot(t2,y2)
    title('R�ponse mes vs est par moindres carr�s')

    
    errGraph = y1 - x;
    errMoindresCarres = y2 - x;
    
    figure
    plot(t,errGraph)
    hold on
    plot(t,errMoindresCarres)
    title('Erreur Graph et Moindres carr�s')
    