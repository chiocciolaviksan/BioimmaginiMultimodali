%% ESERCITAZIONE 1 e 2 BIOIMMAGINI

% Va creato un programma per visualizzare le immagini A, B, C con A di
% riferimento (immaine fissa), la loro diferenza e l'istogramma congiunto
% Il seguente codice mi stampa le immagini, la differenza tra le due e la
% rototraslazione.

clear 
close all
clc

% tic --> This MATLAB function works with the toc function to measure elapsed time
% toc --> This MATLAB function reads the elapsed time since the stopwatch timer 
%         started by the call to the tic function

%% ----------------------------------------------------------------------------- %
% lettura immagine
% imread legge l'immagine e va inserito il nome .estensione tra apici

%----------- coronal_2023.tif
imgA = imread('coronal A.tif');
imgB = imread('coronal B.tif');
imgC = imread('coronal C.tif');
imgD = imread('coronal D.tif');

%----------- RM_encefalo.tif
% imgA = imread('RM_Encefalo_A.tif');
% imgB = imread('RM_Encefalo_B.tif');
% imgC = imread('RM_Encefalo_C.tif');
% imgD = imread('RM_Encefalo_D.tif');

[cong_before, ~, ~] = bihist(imgA,imgB);

% se voglio mettrere l'histogramma che sle uso questa
% cong_before = rot90(cong_before);

% visualizzo tutte e 4 le immagini a disposizione
figure('Name','4 immagini')
subplot(2,2,1)
imshow(imgA)
title('img A riferimento')
subplot(2,2,2)
imshow(imgB)
title('img B da rototraslare')
subplot(2,2,3)
imshow(imgC)
title('img C zoom-in zoom-out')
subplot(2,2,4)
imshow(imgD)
title('img D doppio fattore di scala')

% mostro cosa ottengo prima di trasformare
figure('Name','Prima')
subplot(2,2,1)
imshow(imgA)
title('img A riferimento')
subplot(2,2,2)
imshow(imgB)
title('img B da rototraslare')
subplot(2,2,3)
imshow(imgA-imgB)
title('differenza A-B')
subplot(2,2,4)
imshow(imadjust(cong_before))
title('histogramma congiunto')


%% ----------------------------------------------------------------------------- %
% PARTE IMAGE-J
% script che implementa la parte che potremmo fare su ImageJ

run imageJ.m


%% ----------------------------------------------------------------------------- %
% SISTEMA DI RIFERIMENTO

% conversione in coordinate cartesiane trovo le coordinate dei centri 
% in base al nuovo sistema di riferimento 'giusto' aka quello centrato nel 
% ventro dell'immagine - cambio le coordinate per portare l'origine al sentro degli assi
pixel = size(float_bin);

% uso la funzione floor come nella funzione di trasfomazione affine che
% ci è stata fornita dal prof
marker_imgA(:,1) = centers_rif(:,1) - floor(pixel(2)/2);
marker_imgA(:,2) = floor(pixel(1)/2) - centers_rif(:,2);
marker_imgB(:,1) = centers_float(:,1) - floor(pixel(2)/2);
marker_imgB(:,2) = floor(pixel(1)/2) - centers_float(:,2);

% potrei anche farlo così seguendo le istruzioni del prof con 298
% % x_upsx = 298;
% % y_upsx = 298;
% % 
% % marker_imgA = [centers_rif(1,1)-x_upsx y_upsx-centers_rif(1,2);
% %                centers_rif(2,1)-x_upsx y_upsx-centers_rif(2,2);
% %                centers_rif(3,1)-x_upsx y_upsx-centers_rif(3,2)];
% % 
% % marker_imgB = [centers_float(1,1)-x_upsx y_upsx-centers_float(1,2);
% %                centers_float(2,1)-x_upsx y_upsx-centers_float(2,2);
% %                centers_float(3,1)-x_upsx y_upsx-centers_float(3,2)];


%% ----------------------------------------------------------------------------- %%
%  Apertura del report sul quale segno i dati

fid = fopen('Eserc_BIMM.txt','w');
fprintf(fid,'\n DATI RILEVANTI ESERCITAZIONE \n');


%% ----------------------------------------------------------------------------- %
% a. METODO DEI CENTROIDI
% il metodo utilizza le immagini A e B ovvero considera solo una
% rototraslazione e non un fattore di scala

run MetodoCentroidi.m

% grafico le posizioni dei centroidi
figure('Name','Posizione dei marker e dei centroidi')
subplot(2,1,1)
plot(marker_imgA(:,1),marker_imgA(:,2),'k+',LineWidth = 3)
hold on  
plot(xCA,yCA,'r*',LineWidth = 3)
title('img A riferimento')
subplot(2,1,2)
plot(marker_imgB(:,1),marker_imgB(:,2),'k+',LineWidth = 3)
hold on 
plot(xCB,yCB,'r*',LineWidth = 3)
title('img B da Rototraslare')

% --------- grafico utile per capire -------------------- %
% grafico le posizioni dei centroidi
% figure('Name','Posizione dei marker e dei centroidi')
% plot(marker_imgA(:,1),marker_imgA(:,2),'k+',LineWidth = 3)
% hold on
% plot(marker_imgB(:,1),marker_imgB(:,2),'b+',LineWidth = 3)
% legend('markerA','markerB')
% title('Corrispondenze')

% noto che c'è un errore sistematico di 2 pixel nelle traslazioni
tx = tx-2;
ty = ty-2;

% -------------------------------------------------------------------- %
% APPLICAZIONE DEL METODO
% richiamando la funzione affine applico la trasformazione che ho trovato
% con quetso metodo
img_rot_centr = optimized_affine_trasformation(float_img,[alpha,tx,ty,1,1,0]);
[cong_centr, ~, ~] = bihist(rif_img,img_rot_centr);

% trovo quali sono i parametri 
theta = [alpha tx ty 1 1 0];
% theta = [alpha tx ty s1 s2 0];

% ----------------------------------------------------------------------------- %
fprintf(fid,'\n 1. metodo dei CENTROIDI');
fprintf(fid,'\n    alpha       tx          ty          s1         s2          0');
fprintf(fid,'\n%f\t%f\t%f\t%f\t%f\t%f\t',theta(1),theta(2),theta(3),theta(4),theta(5),theta(6));

% % viauslaizzo anche in command window
disp('Parametri metodo dei CENTROIDI')
disp('    alpha     tx        ty          s1         s2          0')
disp(theta)

% ----------------------------------------------------------------------------- %
% visualizzo i risultati
figure('Name','Dopo - METODO DEI CENTROIDI')
subplot(2,2,1)
imshow(rif_img)
title('img A riferimento')
subplot(2,2,2)
imshow(img_rot_centr)
title('img B rototraslata')
subplot(2,2,3)
imshow(rif_img-img_rot_centr)
title('differenza A-B')
subplot(2,2,4)
imshow(imadjust(cong_centr))
title('histogramma congiunto')

% ---------------- %
% PULIZIA
trash = 1;
run pulizia.m
trash = 2;

%% ----------------------------------------------------------------------------- %
% b. METODO PAR

% devo usare immagine A e C perchè è solo ruotata e non anche traslata
% però le modifico com imageJ per togliere i markers; 
imgA_norm = imread("coronal A norm.tif");
imgB_norm = imread("coronal B norm.tif");


% ------ RM_Encefalo ------------------------- %
% imgA_norm = imread("RM_Encefalo_A_PAR.tif");
% imgB_norm = imread("RM_Encefalo_B_PAR.tif");

run MetodoPAR.m

% richiamando la funzione affine applico la trasformazione che ho trovato
% con quetso metodo

img_rot_A = optimized_affine_trasformation(imgA_norm, [AlphaA, 0, 0, 1, 1, 0]);
img_rot_PAR = optimized_affine_trasformation(imgB_norm,[theta,tx,ty,Fs,Fs,0]);
[cong_PAR, ~, ~] = bihist(img_rot_A,img_rot_PAR);

% trovo quali sono i parametri 
Theta = [theta tx ty Fs Fs 0];

% ----------------------------------------------------------------------------- %
fprintf(fid,'\n\n\n 2. metodo PAR');
fprintf(fid,'\n    alpha       tx          ty          s1         s2          0');
fprintf(fid,'\n%f\t%f\t%f\t%f\t%f\t%f\t',Theta(1),Theta(2),Theta(3),Theta(4),Theta(5),Theta(6));

% viaualizz
disp('Parametri metodo PAR')
disp('    alpha     tx        ty          s1         s2          0')
disp(Theta)

% ----------------------------------------------------------------------------- %
% visualizzo i risultati
figure('Name','Dopo - METODO PAR')
subplot(2,2,1)
imshow(img_rot_A)
title('img A riferimento')
subplot(2,2,2)
imshow(img_rot_PAR)
title('img B ruotata')
subplot(2,2,3)
imshow(img_rot_A-img_rot_PAR)
title('differenza A-B')
subplot(2,2,4)
imshow(imadjust(cong_PAR))
title('histogramma congiunto')

% ---------------- %
% PULIZIA
run pulizia.m
trash = 3;

%% ----------------------------------------------------------------------------- %
% c. METODI DEI MARKERS

run MetodoMarkers.m

% richiamando la funzione affine applico la trasformazione che ho trovato
% con quetso metodo
img_rot_markers = optimized_affine_trasformation(imgB,[alpha,tx,ty,1,1,0]);
[cong_markers, ~, ~] = bihist(rif_img,img_rot_markers);

% trovo quali sono i parametri 
theta = [alpha tx ty 1 1 0];

% ----------------------------------------------------------------------------- %
fprintf(fid,'\n\n\n 3. metodo dei MARKERS');
fprintf(fid,'\n    alpha       tx          ty          s1         s2          0');
fprintf(fid,'\n%f\t%f\t%f\t%f\t%f\t%f\t',theta(1),theta(2),theta(3),theta(4),theta(5),theta(6));

% visualizzo anche in command window
disp('Parametri metodo MARKERS')
disp('    alpha     tx        ty          s1         s2          0')
disp(theta)

% ----------------------------------------------------------------------------- %
% visualizzo i risultati
figure('Name','Dopo - METODO DEI MARKERS')
subplot(2,2,1)
imshow(rif_img)
title('img A riferimento')
subplot(2,2,2)
imshow(img_rot_markers)
title('img B rototraslata')
subplot(2,2,3)
imshow(rif_img-img_rot_markers)
title('differenza A-B')
subplot(2,2,4)
imshow(imadjust(cong_markers))
title('histogramma congiunto')

% ---------------- %
% PULIZIA
run pulizia.m
trash = 4;


%% ----------------------------------------------------------------------------- %
% d. METODO DELLA FORZA BRUTA
%    lo implemento aggiumgebdo la derivata

% creazione dei vettori di rotazione e traslazione
% rotaz idealmente da -180 a +180; traslaz idealmente da -lunghezza a +lunghezza
% ma per evitare che il programma giri per giorni senza dare un risultato allora 
% cerco un limite inferiore e superiore alla rotazione e alla traslazione
% guardanfo l'immageine 'a occhio' per ciclare su un numero di cicli non esagerato 

dim = size(float_img); 
step = 1;
weight = 1;

% simulando (aka facendolo girare per un quarto d'ora) trovo i valori di alpha, tx e ty
% allora impongo un range opportuno attorno a questi valori
alf = linspace(deg2rad(-13),deg2rad(-12),2); 
trasx = linspace(7,8,2);
trasy = linspace(-13,-12,2);

% -------- RM_Encefalo ------------------------ %
% alf = 5*pi/180:step*pi/180:10*pi/180;   % 8°            
% trasx = 5:1:10;                         % 8
% trasy = 10:1:15;                        % 14

run MetodoForzaBruta.m

% passo alla trasformazione geometrica finale che è quella che mi da
% l'immagine ruotata attraverso la chiamata a questa funzione
% [1 1 0] = non ho fattori di scala il parametro che fa riferimento ai
% fattori di scala - aka elementi che stanno quindi fuori dalla diagobale
% sono uguali all'unità
[img_rot_SSD] = optimized_affine_trasformation(imgB,[alf(c(1)) trasx(a(1)) trasy(b(1)) 1 1 0]);
[cong_after, ~, ~] = bihist(rif_img,img_rot_SSD);

% trovo quali sono i parametri theta cosi posso verificare su imageJ
theta = [alf(c(1)) trasx(a(1)) trasy(b(1)) 1 1 0];

% ----------------------------------------------------------------------------- %
fprintf(fid,'\n\n\n 4. metodo metodo della FORZA BRUTA');
fprintf(fid,'\n    alpha       tx          ty          s1         s2          0');
fprintf(fid,'\n%f\t%f\t%f\t%f\t%f\t%f\t',theta(1),theta(2),theta(3),theta(4),theta(5),theta(6));

% visualizzo anche in command window
disp('Parametri del metodo FORZA BRUTA')
disp('    alpha     tx        ty          s1         s2          0')
disp(theta)


% ----------------------------------------------------------------------------- %
% visualizzo il risultato della trasformazione che ho ottenuto
figure('Name','Dopo - METODO FORZA BRUTA')
subplot(2,2,1)
imshow(rif_img)
title('img A riferimento')
subplot(2,2,2)
imshow(img_rot_SSD)
title('img B rototraslata')
subplot(2,2,3)
imshow(rif_img-img_rot_SSD)
title('differenza A-B')
subplot(2,2,4)
imshow(imadjust(cong_after))
title('histogramma congiunto')

% ---------------- %
% PULIZIA
run pulizia.m
trash = 5;

%% ----------------------------------------------------------------------------- %
% d.1 METODO DEL GRADIENTE - SSD
%     in sintesi sto migliorando la forza bruta introducendo la derivata 

run MetodoSSDeGradiente.m

[img_rot1] = optimized_affine_trasformation(imgB,[alf(c1(1)) trasx(a1(1)) trasy(b1(1)) 1 1 0]);
[cong1, ~, ~] = bihist(rif_img,img_rot1);

% visualizzo il risultato della trasformazione che ho ottenuto
figure('Name','Dopo - METODO CON DERIVATA')
subplot(2,2,1)
imshow(rif_img)
title('img A riferimento')
subplot(2,2,2)
imshow(img_rot1)
title('img B rototraslata')
subplot(2,2,3)
imshow(rif_img-img_rot1)
title('differenza A-B')
subplot(2,2,4)
imshow(imadjust(cong1))
title('histogramma congiunto')

% trovo quali sono i parametri theta cosi posso verificare su imageJ
theta = [alf(c1(1)) trasx(a1(1)) trasy(b1(1)) 1 1 0];

% ----------------------------------------------------------------------------- %
fprintf(fid,'\n\n\n 5. metodo metodo del GRADIENTE');
fprintf(fid,'\n    alpha       tx          ty          s1         s2          0');
fprintf(fid,'\n%f\t%f\t%f\t%f\t%f\t%f\t',theta(1),theta(2),theta(3),theta(4),theta(5),theta(6));

% visualizzo anche in command window
disp('Parametri metodo GRADIENTE')
disp('    alpha     tx        ty          s1         s2          0')
disp(theta)

% ---------------- %
% PULIZIA
run pulizia.m
trash = 6;


%% ----------------------------------------------------------------------------- %
% e. METODO DELLA CROSS-CORRELAZIONE 
% utilizza l'immagine A e D ovvero rototraslata e con fattore di scala

% scelta dell'immagine e relativi range nel caso non volessi usare coronal
% run SelezionaImmagine.m 

% ----------------------------------------------------------------------------- %
%----------- coronal_2023.tif
% clear imgA imgD
imgA = imread('coronal_A_2023.tif');
imgD = imread('coronal_D_2023.tif');

dim = size(imgA);

% Founded trasformation with:
% traslation x,y : 7.9889, -10.8111 pixels 
% a rotation of -12°  
% and a scale(x,y) factor of 1.075, 1.075.
% time estimated for these ranges 1.468795 seconds.
        
                    
alfa = linspace(deg2rad(-13),deg2rad(-12),2); 
tx = linspace(7,8,2);
ty = linspace(-12,-10,2);
%ty = linspace(-10.811,-10.8,2);
sx = linspace(1.075,1.08,2);
sy = linspace(1.075,1.08,2);


% ----------------------------------------------------------------------------- %

run MetodoCC.m

img_rot_CC = optimized_affine_trasformation(imgD,[alfa(ind_alfa),tx(ind_tx),ty(ind_ty),sx(ind_sx),sy(ind_sy),0]);
[cong_CC, ~, ~] = bihist(imgA,img_rot_CC);

% visualizzo il risultato della trasformazione che ho ottenuto
figure('Name','Dopo - METODO della CROSSCORRELAZIONE')
subplot(2,2,1)
imshow(imgA)
title('img A riferimento')
subplot(2,2,2)
imshow(img_rot_CC)
title('img D rototraslata e con fattotre di scala')
subplot(2,2,3)
imshow(imgA-img_rot_CC)
title('differenza A-D')
subplot(2,2,4)
imshow(imadjust(cong_CC))
title('histogramma congiunto')

% trovo quali sono i parametri theta cosi posso verificare su imageJ
theta = [alfa(ind_alfa),tx(ind_tx),ty(ind_ty),sx(ind_sx),sy(ind_sy),0];

% ----------------------------------------------------------------------------- %
fprintf(fid,'\n\n\n 6. metodo metodo della CROSS CORRELZIONE');
fprintf(fid,'\n    alpha       tx          ty          s1         s2          0');
fprintf(fid,'\n%f\t%f\t%f\t%f\t%f\t%f\t',theta(1),theta(2),theta(3),theta(4),theta(5),theta(6));

% visualizzo anche in command window
disp('Parametri metodo della CROSS CORRELZIONE')
disp('    alpha     tx        ty          s1         s2          0')
disp(theta)

% ---------------- %
% PULIZIA
run pulizia.m
trash = 7;


%% ----------------------------------------------------------------------------- %
% f. METODO DELLA MUTUA INFORMAZIONE
% utilizza l'immagine A e D ovvero rototraslata e con fattore di scala

run MetodoMI.m

img_rot_MI = optimized_affine_trasformation(imgD,[alfa(ind_alfaMI),tx(ind_txMI),ty(ind_tyMI),sx(ind_sxMI),sy(ind_syMI),0]);
[cong_MI, ~, ~] = bihist(imgA,img_rot_MI);

% viasualizzo i risultati che ho ottenuto
figure('Name','Dopo - METODO della MUTUA INFORMAZIONE')
subplot(2,2,1)
imshow(imgA)
title('img A riferimento')
subplot(2,2,2)
imshow(img_rot_MI)
title('img D rototraslata e con fattore di scala')
subplot(2,2,3)
imshow(imgA-img_rot_MI)
title('differenza A-D')
subplot(2,2,4)
imshow(imadjust(cong_MI))
title('histogramma congiunto')

% trovo quali sono i parametri theta cosi posso verificare su imageJ
theta = [alfa(ind_alfaMI),tx(ind_txMI),ty(ind_tyMI),sx(ind_sxMI),sy(ind_syMI),0];

% ----------------------------------------------------------------------------- %
fprintf(fid,'\n\n\n 7. metodo metodo della MUTUA INFORMAZIONE');
fprintf(fid,'\n    alpha       tx          ty          s1         s2          0');
fprintf(fid,'\n%f\t%f\t%f\t%f\t%f\t%f\t',theta(1),theta(2),theta(3),theta(4),theta(5),theta(6));

% visualizzo anche in command window
disp('Parametri theta metodo della MUTUA INFORMAZIONE')
disp('    alpha     tx        ty          s1         s2          0')
disp(theta)

% ---------------- %
% PULIZIA
run pulizia.m
trash = 8;

%% ----------------------------------------------------------------------------- %
% 3b. METODO RIU
% utilizza l'immagine A e D ovvero rototraslata e con fattore di scala

run MetodoRIU.m

img_rot_RIU = optimized_affine_trasformation(imgD,[alfa(ind_alfa),tx(ind_tx),ty(ind_ty),sx(ind_sx),sy(ind_sy),0]);
[cong_RIU, ~, ~] = bihist(imgA,img_rot_RIU);

% viasualizzo i risultati che ho ottenuto
figure('Name','Dopo - METODO della RIU')
subplot(2,2,1)
imshow(imgA)
title('img A riferimento')
subplot(2,2,2)
imshow(img_rot_RIU)
title('img D rototraslata e con fattore di scala')
subplot(2,2,3)
imshow(imgA-img_rot_RIU)
title('differenza A-D')
subplot(2,2,4)
imshow(imadjust(cong_RIU))
title('histogramma congiunto')

% trovo quali sono i parametri theta cosi posso verificare su imageJ
theta = [alfa(ind_alfa),tx(ind_tx),ty(ind_ty),sx(ind_sx),sy(ind_sy),0];

% ----------------------------------------------------------------------------- %
fprintf(fid,'\n\n\n 8. metodo metodo della RIU');
fprintf(fid,'\n    alpha       tx          ty          s1         s2          0');
fprintf(fid,'\n%f\t%f\t%f\t%f\t%f\t%f\t',theta(1),theta(2),theta(3),theta(4),theta(5),theta(6));

% visualizzo anche in command window
disp('Parametri theta metodo della RIU')
disp('    alpha     tx        ty          s1         s2          0')
disp(theta)

% ---------------- %
% PULIZIA
run pulizia.m


%% ----------------------------------------------------------------------------- %%
% chiudo il file sul quale sto scruvendo i dati

fprintf(fid,'\n\n\n\n\n');
fclose(fid);


