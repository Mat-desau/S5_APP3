%%  S5 - APP3e - Formatif pratique
%   Auteur:     Karina Lebel, ing. PhD
%   Date:       12-fev-2020

%   Modifications (Date - initiales - détails):

%% Question 7: Réduction au(x) pôle(s) dominant(s)

    %système
    num = [1.5 28.5 202.8 652.2 740.4];
    den = [1 23 210 950 2044 1632];

    G = tf(num,den);

    %Trace la carte des pôles et des zéros (mais non le lieu des racines
    %que vous verrez à l'APP4!)
    pzmap(num,den)

%% (a) Trouver la FT réduite (pôles dominants)
    [R,P,K] = residue(num,den);
    
    Poids = abs(R)./abs(real(P))
    
    %Les pôles à -3 et à -2 ont un poids équivalent et plus important. Je
    %conserve donc ceux-ci.
    [numR, denR] = residue(R(4:end),P(4:end),K);
    Gr_temp = tf(numR, denR)
    
    %Toutefois, le retrait de modes entraine un changement dans le gain
    %statique (souvent) qui doit être compensé pour obtenir la même réponse
    %en régime permanent    
    GainOriginal = dcgain(G);
    GainReduit   = dcgain(Gr_temp);
    Kamp         = GainOriginal / GainReduit;
    
    %Fonction de transfert réduite (et corrigée pour le gain)
    Gr = Kamp * Gr_temp;
    
%% (b) Réponse à l'échelon
    t       = [0:0.01:10]';
    [yO,t]  = step(G,t);
    [yR,t]  = step(Gr,t);
    
    figure
    plot(t,yO)
    hold on
    plot(t,yR)
    grid on; grid minor
    title('Réponse à l''échelon')
    xlabel('Temps(s)')
    ylabel('Amplitude')
    legend('Système original','Système réduit')
    
    figure
    plot(t,yO-yR)
    grid on; grid minor
    title('Erreur sur la réponse à l''échelon engendrée par la réduction')
    xlabel('Temps(s)')
    ylabel('Amplitude')
    
%% (c) Facteur d'amortissement... 

% De par la réponse à l'échelon, on se doute que le système est
% sur-amorti... (zeta>1)
% Bien qu'on ait un zéro au numérateur, on peut faire la même logique...
    [numR, denR] = tfdata(Gr,'v');
    denR_norm    = denR / denR(1);  %assure que le dénominateur est normalisé
    wn           = sqrt(denR_norm(3));
    zeta         = denR_norm(2)/(2*wn);
    display(['La valeur de zeta est:',num2str(zeta)])

