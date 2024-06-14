%% METODO DEI CENTROIDI
% script che implementa il metodo dei centroidi

s = 1;
w = [1 1 1]';

% devo passare alla funzione le posizioni dei markers
xA = marker_imgA(:,1);
yA = marker_imgA(:,2);
xB = marker_imgB(:,1);
yB = marker_imgB(:,2);

xi = [xA yA];
yi = [xB yB];

% posizione dei centroidi
% abbiamo creato una funzione che ci da la posizione dei centroidi
% non gli passo il peso perche se non passo nulla automaticamente mette 1
[xCA, yCA] = MyCentroide(xA,yA);
[xCB, yCB] = MyCentroide(xB,yB);

X_bar = [xCA yCA];
Y_bar = [xCB yCB];

% distanze
% calcolo le distanze dei markers dai rispettivi centroidi 
xi_bar = xi -X_bar;
yi_bar = yi -Y_bar;

% calcolo la matrice di covarianza Z
% Z = cov(xi_bar,yi_bar);
Z = xi_bar'*yi_bar;

% scomposizione ai valori singolari
[U,L,V] = svd(Z);

% calcolo la matrice di rotazione
K = [1 0 ; 0 det(V*U)];
R = V*K*U';


% fattore di scala
Sopra = xi_bar'*yi_bar;
Sotto = xi_bar'*xi_bar;

S = Sopra/Sotto;
s1 = S(1,1);
s2 = S(2,2);
% S = 1;


% vettore delle traslazioni
t = Y_bar' - R*X_bar';
tx = -t(1);
ty = t(2);


% angolo di rotazione
% calcolo l'angolo di rotazione con la tangente e non con arcoseno perche
% cpsi ellimino il problema del segno (-) davanti
alpha = atan(R(2,1)/R(1,1));




