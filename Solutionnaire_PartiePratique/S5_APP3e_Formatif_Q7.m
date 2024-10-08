%%  S5 - APP3e - Formatif pratique
%   Auteur:     Karina Lebel, ing. PhD
%   Date:       12-fev-2020

%   Modifications (Date - initiales - d�tails):

%% Question 7: R�duction au(x) p�le(s) dominant(s)

    %syst�me
    num = [1.5 28.5 202.8 652.2 740.4];
    den = [1 23 210 950 2044 1632];

    G = tf(num,den);

    %Trace la carte des p�les et des z�ros (mais non le lieu des racines
    %que vous verrez � l'APP4!)
    pzmap(num,den)

%% (a) Trouver la FT r�duite (p�les dominants)
    [R,P,K] = residue(num,den);
    
    Poids = abs(R)./abs(real(P))
    
    %Les p�les � -3 et � -2 ont un poids �quivalent et plus important. Je
    %conserve donc ceux-ci.
    [numR, denR] = residue(R(4:end),P(4:end),K);
    Gr_temp = tf(numR, denR)
    
    %Toutefois, le retrait de modes entraine un changement dans le gain
    %statique (souvent) qui doit �tre compens� pour obtenir la m�me r�ponse
    %en r�gime permanent    
    GainOriginal = dcgain(G);
    GainReduit   = dcgain(Gr_temp);
    Kamp         = GainOriginal / GainReduit;
    
    %Fonction de transfert r�duite (et corrig�e pour le gain)
    Gr = Kamp * Gr_temp;
    
%% (b) R�ponse � l'�chelon
    t       = [0:0.01:10]';
    [yO,t]  = step(G,t);
    [yR,t]  = step(Gr,t);
    
    figure
    plot(t,yO)
    hold on
    plot(t,yR)
    grid on; grid minor
    title('R�ponse � l''�chelon')
    xlabel('Temps(s)')
    ylabel('Amplitude')
    legend('Syst�me original','Syst�me r�duit')
    
    figure
    plot(t,yO-yR)
    grid on; grid minor
    title('Erreur sur la r�ponse � l''�chelon engendr�e par la r�duction')
    xlabel('Temps(s)')
    ylabel('Amplitude')
    
%% (c) Facteur d'amortissement... 

% De par la r�ponse � l'�chelon, on se doute que le syst�me est
% sur-amorti... (zeta>1)
% Bien qu'on ait un z�ro au num�rateur, on peut faire la m�me logique...
    [numR, denR] = tfdata(Gr,'v');
    denR_norm    = denR / denR(1);  %assure que le d�nominateur est normalis�
    wn           = sqrt(denR_norm(3));
    zeta         = denR_norm(2)/(2*wn);
    display(['La valeur de zeta est:',num2str(zeta)])

