%% SELEZIONE DELL'IMMAGINE e del relativo range

% %%----------- RM_Encefalo.tif
imgA = imread('RM_Encefalo_A.tif');
imgD = imread('RM_Encefalo_D.tif');

% I VALORI VERI DELLA TRASFORMAZIONE SONO +8.11(X) +14.31(Y) E +8° SCALA X = SCALA Y = 1.064
% time estimated for these ranges 4.178345 seconds.
alfa = linspace(deg2rad(7),deg2rad(9),3); 
tx = linspace(8.109,8.11,2);
ty = linspace(14.3,14.4,2);
sx = linspace(1.05,1.064,2);
sy = linspace(1.05,1.064,2);

%%----------- coronal.tif
% imgA = imread('coronal_A.tif');
% imgB = imread('coronal_D.tif');

% % Founded trasformation with traslation x,y : 14.2753, -6.5 pixels, a rotation of -8° , and a scale(x,y) factor of 1.125,1.125.
% % time estimated for these ranges 8.889971 seconds.
% alfa = linspace(deg2rad(-9),deg2rad(-7),3); 
% tx = linspace(14.26,14.28,3);
% ty = linspace(-6.5,-6.4,2);
% sx = linspace(1.125,1.126,2);
% sy = linspace(1.125,1.126,2);

%----------- coronal_2023.tif
% imgA = imread('coronal_A_2023.tif');
% imgD = imread('coronal_D_2023.tif');

% Founded trasformation with:
% traslation x,y : 7.9889, -10.8111 pixels 
% a rotation of -12°  
% and a scale(x,y) factor of 1.075, 1.075.
% time estimated for these ranges 1.468795 seconds.

% alfa = linspace(deg2rad(-13),deg2rad(-12),2); 
% tx = linspace(7,8,2);
% ty = linspace(-10.811,-10.8,2);
% sx = linspace(1.075,1.08,2);
% sy = linspace(1.075,1.08,2);


%%----------- rm caviglia.tif (A  e B a 24 bit)
% imgA = imread('rm_caviglia_A.tif');
% imgA = uint8((double(rif_img(:,:,1))+double(rif_img(:,:,2))+double(rif_img(:,:,3)))./(3));
% imgD = imread('rm_caviglia_D.tif');

% % Founded trasformation with traslation x,y : 27.81, 10.47 pixels, a rotation of 12° , and a scale(x,y) factor of 1.073,1.073.
% % % time estimated for these ranges 2.756350 seconds.
% alfa = linspace(deg2rad(11),deg2rad(13),3); 
% tx = linspace(27.80,27.81,2);
% ty = linspace(10.45,10.47,3);
% sx = linspace(1.072,1.073,2);
% sy = linspace(1.072,1.073,2);



