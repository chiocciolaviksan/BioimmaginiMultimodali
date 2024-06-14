%% METODO DEI MARKERS
% script che implementa il metodo dei markers

% trovo le corrispondenze fra i markers - le trovo andando ad asseganare al
% marker 1 dell'immagine A il marker che gli è piu vicino (minimizzazione della distanza) 
% nell'immagine B, poi predno il marker 2 della A e trovo il corrispondete 2 della B... etc

for i=1:height(marker_imgA)
    for j=1:height(marker_imgB)
        
        % trovo le distanze
        dist(j) = sqrt((marker_imgA(i,1)-marker_imgB(j,1))^2 +...
            (marker_imgA(i,2)-marker_imgB(j,2))^2);

    end
    % minimizzo la distanza
    [~,indice_dist_min(i)] = min(dist);
end

% Matrice delle corrispondenze 
corr = [marker_imgA(1,:),marker_imgB(indice_dist_min(1),:); 
        marker_imgA(2,:),marker_imgB(indice_dist_min(2),:); 
        marker_imgA(3,:),marker_imgB(indice_dist_min(3),:)];

% al posto di lavorare con la matrice mi ricavo u,v x,y così
% è piu facile visualizzare il prodotto matriciale
u = corr(:,1);      % x del marker nel riferimento
v = corr(:,2);      % y del marker nel riferimento
x = corr(:,3);
y = corr(:,4);

% definisco la matrice X: THETA*X = B
x11 = sum(x.^2 + y.^2);       % x11=x22
x13 = sum(x);                 % x13=x24=×31=×42
x14 = sum(y);                 % x14=-x23=-x32=x41

X = [x11 0 x13 x14; 
     0 x11 -x14 x13; 
     x13 -x14 3 0; 
     x14 x13 0 3];          % 3 = sum[i=1:3](1)

% vettore B
B(1) = sum(u.*x + v.*y);
B(2) = sum(x.*v - y.*u);
B(3) = sum(u);
B(4) = sum(v);

B = B';

% trovo i parametri THETA
THETA = X\B;

% il theta è così definito [a= (s*cos (alpha)), b=(g*gin (alpha)), tx, ty)
% allora ricavo alpha e s che poi verranno passati per la trasformazione
alpha = -atan(THETA(2)/THETA(1));
% s = THETA(1)/cos(alpha);
tx = THETA(3);
ty = -THETA(4);


