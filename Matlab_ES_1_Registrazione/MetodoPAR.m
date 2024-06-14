%% METODO PAR
% script che iplementa il metodo PAR

% devo usare immagine A e C perchè è solo ruotata e non anche traslata
% però le modifico com imageJ per togliere i markers; 
img_A_PAR = imread('coronal_A_PAR.tif');        % senza markers
img_B_PAR = imread('coronal_B_PAR.jpg');    
img_ref = imread("coronal APAR.tif");           % binarizzate nero su sfondo bianco
img_float = imread("coronal BPAR.tif");
% img_C_PAR = imread('coronal_C_PAR.tif');

% RM Encefalo
% img_A_PAR = imread('RM_Encefalo_A_PAR.tif');        % senza markers
% img_B_PAR = imread('RM_Encefalo_B_PAR.tif');    
% img_ref = imread("coronal APAR.tif");           % binarizzate nero su sfondo bianco
% img_float = imread("coronal BPAR.tif");

% creo la matrice B con zeri e uni: 
% 0 se non è un oggetto - sfondo/rumore
% 1 se è ogggetto 

th = 4;
B_rif = img_A_PAR;
B_rif(B_rif >= th) = 255;
B_rif(B_rif < th) = 0;

B_float = img_B_PAR;
B_float(B_float >= th) = 255;
B_float(B_float < th) = 0;


% This MATLAB function performs a flood-fill operation on background 
% pixels of the input binary image BW, starting from the points 
% specified in locations.
B_rif = imfill(B_rif);
B_float = imfill(B_float);

% ----------------------------------------------------------------------------- %
% calcolo del centroide
% The regionprops function measures properties such as area, 
% centroid, and bounding box, for each object (connected component) in an image.
sA = regionprops(img_ref,'centroid');
sB = regionprops(img_float,'centroid');

centroidsA = cat(1,sA.Centroid);
centroidsA = centroidsA(end,:); 

centroidsB = cat(1,sB.Centroid);
centroidsB = centroidsB(end,:); 

% ----------------------------------------------------------------------------- %
% calcolo del centroide a mano

% riscalo in 1 e 0
img_ref = img_ref/255;
img_float = img_float/255;

centroide_x_float = 0;
centroide_y_float = 0;
centroide_x_ref = 0;
centroide_y_ref = 0;

% calcolo effettivo del centroide
dim_ref = size(img_ref);

for i = 1:dim_ref(2)
    centroide_x_ref = centroide_x_ref+i*sum(img_ref(:,i));
    centroide_x_float = centroide_x_float+i*sum(img_float(:,i));
end

centroide_x_ref= centroide_x_ref/sum(sum(img_ref));
centroide_x_float = centroide_x_float/sum(sum(img_float));

for j = 1:dim_ref(1)
    centroide_y_ref = centroide_y_ref+j*sum(img_ref(j,:));
    centroide_y_float = centroide_y_float+j*sum(img_float(j,:));
end
centroide_y_ref= centroide_y_ref/sum(sum(img_ref));
centroide_y_float= centroide_y_float/sum(sum(img_float));

% metto insieme x e y
centr_ref = [centroide_x_ref,centroide_y_ref];
centr_float = [centroide_x_float, centroide_y_float];

% visualizzo l'oggetto con il relativo centroide trovato
figure('Name','Metodo PAR')
subplot(2,2,1)
imshow(img_A_PAR)
title('Immagine Riferimento')
subplot(2,2,2)
imshow(img_B_PAR)
title('Immagine da rototraslare')
subplot(2,2,3)
imshow(B_rif)
hold on
% centroide Matlab
plot(centroidsA(:,1),centroidsA(:,2),'b+')
hold on
% centroide a mano
plot(centroide_x_ref,centroide_y_ref, 'ro')
title('Oggetto di riferimento con centroide')
subplot(2,2,4)
imshow(B_float)
hold on
plot(centroidsB(:,1),centroidsB(:,2),'b+')
hold on
plot(centroide_x_float,centroide_y_float, 'ro')
title('Oggetto da registrare con centroide')

% dal plot deduco che il problema non sia nella posizione del centroide che
% risulta uguale usando la funzione matlab
% ----------------------------------------------------------------------------- %

% creo effettivamente la matrice B
th = 1;
B_rif = img_ref;
B_rif(B_rif >= th) = 1;
B_rif(B_rif < th) = 0;

B_float = img_float;
B_float(B_float >= th) = 1;
B_float(B_float < th) = 0;

% inserisco k e l per ridurre la notazione
k = size(B_float,1);
l = size(B_float,2);
k1 = size(B_rif,1);
l1 = size(B_rif,2);

% clear centroidsA centroidsB
% centroidsA = [centroide_x_ref,centroide_y_ref];
% centroidsB = [centroide_x_float, centroide_y_float];


% creo la matrice di Inerzia
% Ixx = SUM(y-yg)^2*B --> essendo rispetto a x devo considerare y
% Iyy = SUM(x-xg)^2*B --> essendo rispetto a y devo considerare x
% Ixy = Iyx = SUM(x-xg)(y-yg)*B

% % immagine A
IxxA = sum(sum((repmat((1:k1)', 1, l1) - centroidsA(2)).^2 .* double(B_rif)));  
IyyA = sum(sum((repmat(1:l, k1, 1) - centroidsA(1)).^2 .* double(B_rif)));    
IxyA = sum(sum((repmat((1:k1)', 1, l1) - centroidsA(2)) .* (repmat(1:l1, k1, 1) ...
      - centroidsA(1)) .* double(B_rif)));                                    
IA = [IxxA -IxyA;-IxyA IyyA];

% immagine B
IxxB = sum(sum((repmat((1:k)', 1, l) - centroidsB(2)).^2 .* double(B_float)));  
IyyB = sum(sum((repmat(1:l, k, 1) - centroidsB(1)).^2 .* double(B_float)));    
IxyB = sum(sum((repmat((1:k)', 1, l) - centroidsB(2)) .* (repmat(1:l, k, 1) ...
      - centroidsB(1)) .* double(B_float)));                                    
IB = [IxxB -IxyB;-IxyB IyyB];

% costruisco la matrice di inerzia ciclando al posto che con sum 
% IA = zeros(2);
% IB = zeros(2);
% 
% for i = 1:k
%     for j = 1:l
% 
%         IA(1,1) = IA(1,1) + (i-centroidsA(2)).^2*double(B_rif(i,j));
%         IA(2,2) = IA(2,2) + (j-centroidsA(1)).^2*double(B_rif(i,j));
%         IA(1,2) = IA(1,2) + (j-centroidsA(1))*(i-centroidsA(2))*double(B_rif(i,j));
% 
%         IB(1,1) = IB(1,1) + (i-centroidsB(2)).^2*double(B_float(1,j));
%         IB(2,2) = IB(2,2) + (j-centroidsB(1)).^2*double(B_float(1,j));
%         IB(1,2) = IB(1,2) + (j-centroidsB(1))*(i-centroidsB(2))*double(B_float(1,j));
%     end
% end
% 
% IA(1,2) = -IA(1,2);
% IA(2,1) = IA(1,2) ;
% IB(1,2) = -IB(1,2);
% IB(2,1) = IB(1,2);

% scomposizione in valori singolari della matrice I
% [EA,LA,~] = svd(IA);
% [EB,LB,~] = svd(IB);

% alposto della scomposizione ai valori singolari è meglio prendere
% direttamente gli autovettori della matrice, attenzione che matlab scambia
% i vettori
[VA, DA] = eig(IA);
lambdaA = diag(DA);
[VB, DB] = eig(IB);
lambdaB = diag(DB);

% calcolo la matrice di rotazione E
EA(:,1) = VA(:,2)/norm(VA(:,2));
EA(:,2) = VA(:,1)/norm(VA(:,1));
EB(:,1) = VB(:,2)/norm(VB(:,2));
EB(:,2) = VB(:,1)/norm(VB(:,1));

% trovo l'angolo theta tramite la matrice di rotazione
% Alpha = atan2(2*Ixy,Iyy-Ixx)/2;
AlphaA = acos(EA(1,1));
AlphaB = acos(EB(1,1));

Alpha = (AlphaA-AlphaB);
theta = AlphaA+Alpha;


% la traslazione in x e y la calcolo come traslazione dei due centroidi
centroide_yA = -centroidsA(2)+floor(dim_ref(1)/2);
centroide_xA = centroidsA(1)-floor(dim_ref(2)/2);
centroide_yB = -centroidsB(2)+floor(dim_ref(1)/2);
centroide_xB = centroidsB(1)-floor(dim_ref(2)/2);

traslazioni = centroidsA-centroidsB;
tx = traslazioni(1);
ty = - traslazioni(2);

% tx = centroide_xA-centroide_xB;
% ty = -(centroide_yA-centroide_yB);

tx = tx;
ty = ty;

%% fattore di scala
Fs = 1;
%Fs = round(sqrt(sum(sum(img_ref))/sum(sum(img_float))),2);










