%% IMAGEJ
% analisi preliminare di pulizia dell'immagine e ricerca dei marker 
% come se stessi usando imageJ 

% siccome nel mnetre ho cambiato notazione
rif_img = imgA; 
float_img = imgB;

% trovo le coordinate deimarkers: faccio tutti i passaggi che farei su
% imageJ per completezza anche se li trovava benissimo anche solo
% binarizzando e facendo trovarei i cerchi

% -------------------------------------------------------------------- %
% MASCHERA
% Creazione della maschera laplaciana con filtro laplaciano classico 
F = [-1 -1 -1; -1 8 -1; -1 -1 -1];
% F = [0 -1 0; -1 4 -1; 0 -1 0];

% -------------------------------------- %
% FILTRAGGIO
% applico la maschera che ho creato
imgA_filtr = imfilter(rif_img,F);
imgB_filtr = imfilter(float_img,F);

% -------------------------------------- %
% FILL HOLES
% una volta filtrata riempio i buchi
imgA_fill = imfill(imgA_filtr,'holes');
imgB_fill = imfill(imgB_filtr,'holes');

% --------------------------------------- %
% BINARIZZAZIONE
% binarizzazione delle due immagini: devo prima binarizzare se no 
% non mi trova i cerchi - faccio una binarizzazione 'a mano'
th = 220;
rif_bin = rif_img;
rif_bin(rif_bin >= th) = 255;
rif_bin(rif_bin < th) = 0;

float_bin = float_img;
float_bin(float_bin >= th) = 255;
float_bin(float_bin < th) = 0;

% siccome la comodità non è mai troppa esiste anche una 
% funzione matlab che binarizza da sola tutta l'immagine
imgA_bin = imbinarize(imgA_fill,0.3);
imgB_bin = imbinarize(imgB_fill,0.3);


% ---------------------------------------------------------------------- %
% GRAFICI
% plotto i riusltati ottenuti: controllo che effettivamente stia facendo 
% tutto quello che gli ho detto di fare: filtraggio con laplaciano - 
% riempimento dei buchi e binarizzazione 

figure('Name','controllo sui markers')
% filtragio con laplaciano
subplot(3,2,1)
imshow(imgA_filtr)
title('Filtraggio A')
subplot(3,2,2)
imshow(imgB_filtr)
title('Filtraggio B')

% rimepimento dei buci
subplot(3,2,3)
imshow(imgA_fill)
title('Fill Holes A')
subplot(3,2,4)
imshow(imgB_fill)
title('Fill Holes B')

% binarizzazione
subplot(3,2,5)
imshow(imgA_bin)
title('Risultato A')
subplot(3,2,6)
imshow(imgB_bin)
title('Risultato B')

% ----------------------------------------------------------------------------- %
% trovo effettivamente i cerchi - i centri sono rispetto al sistema up-sx
% Find all the circles with radius pixels in the range [a, b]. 
% con imageJ vedo che il raggio è 12
[centers_rif, radii_rif, metric_rif] = imfindcircles(rif_bin,[5 20]);
[centers_float, radii_float, metric_float] = imfindcircles(float_bin,[5 20]);

% trovo i 3 cerchi piu significativi per plottarli con l'immagine
centersStrong3_rif = centers_rif(1:3,:); 
radiiStrong3_rif = radii_rif(1:3);
metricStrong3_rif = metric_rif(1:3);
centersStrong3_float = centers_float(1:3,:); 
radiiStrong3_float = radii_float(1:3);
metricStrong3_float = metric_float(1:3);

% posizione dei markers
figure('Name','Posizione dei Markers')
subplot(2,1,1)
imshow(rif_img)
viscircles(centersStrong3_rif, radiiStrong3_rif,'EdgeColor','b');
title('Markers A')
subplot(2,1,2)
imshow(float_img)
viscircles(centersStrong3_float, radiiStrong3_float,'EdgeColor','r');
title('Markers B')

disp('centri dei markers')
disp('immagine di riferimento A')
disp(centers_rif)
disp('immagine da rototraslare B')
disp(centers_float)

%% ----------------------------------------------------------------------------- %
% PULIZIA
clear imgA_filtr imgB_filtr
clear radii_rif metric_rif
clear radii_float metric_float
clear centersStrong3_rif radiiStrong3_rif metricStrong3_rif 
clear centersStrong3_float radiiStrong3_float metricStrong3_float 
clear imgA_bin imgB_bin imgA_fill imgB_fill
clear th i j imgA_bin imgB_bin F


