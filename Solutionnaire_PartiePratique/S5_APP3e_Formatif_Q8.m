%%  S5 - APP3: Formatif
%   Auteur:     Karina Lebel, ing. PhD
%   Date:       12-fev-2020

%   Modifications (Date - initiales - détails):

%%  Chargement des données : DonneesIdentifMasseRessortAmorti.mat
%   3 variables seront disponibles soit:
%   Vecteur temps, t: 5001x1
%   Vecteur entrée,Fext: 5001x1
%   Vecteur sortie,x: 5001x1
    close all; clear all
    load DonneesIdentifMasseRessortAmorti

    figure
    subplot(2,1,1)
    plot(t,Fext,'b','linewidth',1.5); grid on; grid minor
    title('Entrée du système')
    subplot(2,1,2)
    plot(t,x,'r','linewidth',1.5)
    title('Réponse du système masse-ressort')
    xlabel('Temps (s)')
    grid on; grid minor
    
%% (a) Modélisation d'un système...

%  Équation forme générale: Kwn2/(s2 + 2*zeta*wn s + wn2)
%  Trouvons les valeurs de m, b et k dans l'équation d'origine qui 
%  permettront de reproduire le comportement du système (graphique)

%  Ici on pourrait déduire plusieurs paramètres à partir de la simple
%  observation du graphique:
%  (i)  Pour une entrée de 50N, on stabilise à 0.5... Donc K = 0.01
%  (ii) Dépassement max = (0.7633-0.5)/0.5 * 100 = 52.66% => Avec formule
%       de Mp, on trouve que zeta = 0.2
%  (iii)Temps du premier pic = 0.322 = pi/(wn*sqrt(1-zeta2)) => wn =
%       9.9577
%  (iv) On peut ré-écrire l'équation standard sous la forme de l'équation 
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
    title('Réponse mes vs est par graphique')

%   Méthode des moindres carrés
    % ATTENTION, ICI, LE VECTEUR X inclu entrée et sorties... x =
    % sorties...
    % Tout d'abord on identifie les vecteurs X tels que: 
    % X1 = u (entrée) -> Ici, Fext
    % X2 = dy/dt (dsortie) -> ici, la sortie est x (ouf)
    % X3 = d2y/dt2 (on arrête ici car ordre 2)
    % X  = [X1 X2 X3]
    
    X1 = Fext;
    
    dt = t(2:end) - t(1:end-1); %Plus général que t(2)-t(1)... valide peu importe si le dt est cst!
    X2 = diff(x) ./ dt;
    X3 = diff(X2)   ./ (t(3:end)-t(2:end-1));
    
    X  = [X1(1:end-2) X2(1:end-1) X3];  %On enlève 2 points à X1 car en calculant X2, 
                                        %on perd l'info du dernier point
                                        %et en calculant X3, celui de
                                        %l'avant-dernier...
                                       
    
    % Identifions maintenant le vecteur de sortie Y
    Y  = x(1:end-2);
    
    
    % On calcule les matrices de corrélation:
    R  = X' * X; 
    P  = X' * Y;
    
    % Il ne reste qu'à appliquer l'équation A = R^-1 * P pour trouver les
    % coefficients:
    A = inv(R) * P;
    
    
    % Dans notre cas particulier, lorsque l'on a converti la fonction en
    % forme standard, on trouve que G(s) = (1/m) / (s2 + b/m s + k/m) et 
    % dans la méthode du moindres carrés: x = (1/k)Fext - (b/k)s - m/k s2 donc:
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
    title('Réponse mes vs est par moindres carrés')

    
    errGraph = y1 - x;
    errMoindresCarres = y2 - x;
    
    figure
    plot(t,errGraph)
    hold on
    plot(t,errMoindresCarres)
    title('Erreur Graph et Moindres carrés')
    