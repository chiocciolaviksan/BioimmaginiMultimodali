% ELIMINAZIONE COMPONENTE OSSEA
% script che implementa l'eliminazione delle ossa della scatola cranica

clear all
close all
clc

T3D = load_untouch_nii('T13D_original_clean.nii');
immagine = T3D.img;

% visualizzo immagine originale
figure('Name','Immagine Originale')
imshow(uint8(squeeze(immagine(:,:,100))))
hold on
xline(103,'b')
yline(78,'b')
title('immagine originale')


% Sono processate solo le slice dal naso in sù (dove si trova il cervello)
totale = double(immagine(:,:,[72:end]));


%% ------------------------------------------------------------------------ %
% L'IMMAGINE di volume ha le seguenti caratteristiche
% terzo indice   --> nSlice  155
% seconod indice --> x       206
% terzo indice   --> y       156

% trovo le dimensioni dell'immagine per usarle poi per il ciclo
z = size(totale(:,:,:));
numSlice = z(3);
dim_x = z(2);
dim_y = z(1);

% --------------------------------------------------------------------- %
% capisco come calibrare l'ellisse
% trovo i semiassi con 'Mango'
% a_max = 176
% b_max = 134
a_max = (176+17)/2; % horizontal radius
b_max = (134+5)/2;  % vertical radius

a_mean0 = (147)/2;
b_mean0 = (106)/2;

a_min = (69+5)/2;
b_min = (37+10)/2;

% x0,y0 ellipse centre coordinates
% attenzione! che come al solito gli assi sono in alto a sx quindi devo
% riscalare il centro
x0 = z(2)/2; 
y0 = z(1)/2;
t = -pi:0.01:pi;
X_max = x0 + a_max*cos(t);
Y_max = y0 + b_max*sin(t);

% le slice piu piccole hanno anche una traslazione del centro dell'ellisse
% x1 = dim_x/2 + 1/6*(dim_x/2);
x1 = dim_x/2 + 5;
X_mean = x1 + a_mean0*cos(t);
Y_mean = y0 + b_mean0*sin(t);

X_min = x1 + a_min*cos(t);
Y_min = y0 + b_min*sin(t);

% visualizzo la slide 100 che è abbastanza a metà tempie
figure('Name','Calibrazione ellisse')
subplot(1,3,1)
imshow(uint8(squeeze(totale(:,:,1))))
hold on
plot(X_max,Y_max,'r','LineWidth',2)
title('slice piu ampia = 1')

subplot(1,3,2)
imshow(uint8(squeeze(totale(:,:,57))))
hold on
plot(X_mean,Y_mean,'','LineWidth',2)
title('slice media = 57')

subplot(1,3,3)
imshow(uint8(squeeze(totale(:,:,84))))
hold on
plot(X_min,Y_min,'g','LineWidth',2)
title('slice piu stretta = 84')


%% ---------------------------------------------------------------------- %
% visualizo per capire come vanno le slice
% vanno al contrario!! dal basso verso l'alto 
% la 1 è la piu ampia e la 84 è la fontanella

% % in 'totale' la slice alle tempie è la 28 ~
% figure('Name','come vanno le slice')
% subplot(2,2,1)
% imshow(uint8(squeeze(totale(:,:,1))))
% title('1')
% subplot(2,2,2)
% imshow(uint8(squeeze(totale(:,:,20))))
% title('20')
% subplot(2,2,3)
% imshow(uint8(squeeze(totale(:,:,28))))
% title('28 - altezza tempie')
% % hold on
% % plot(X,Y,'r','LineWidth',0.5)    
% subplot(2,2,4)
% imshow(uint8(squeeze(totale(:,:,84))))
% title('84')


%% --------------------------------------------------------------------- %
% guardando dall'alto 
% se è > dell'ellisse alora va nello sfondo
% se è = all'ellisse allora con contraddistinguo con bianco 255
% se è < dell'ellisse allora è interno e rimane tale e quale

class = zeros(dim_y,dim_x,numSlice);
a = zeros(1,numSlice);
b = zeros(1,numSlice);

% creo un doppione di totale così non rovino l'originale
divisa = totale;

% per 2/3 si riduce poco e poi si riduce molto piu velocemente
numSlice1 = 2/3*numSlice;
a_mean = (147+10)/2;
b_mean = (106+10)/2;

for i=1:numSlice1
    
    % ad ogni slice devo incrementare i due semiassi dell'ellisse
    a(i) = a_max - ((a_max - a_mean)/numSlice1)*(i-1);
    b(i) = b_max - ((b_max - b_mean)/numSlice1)*(i-1);
    
    for j=1:dim_x
        for k =1:dim_y
            
            x = j;
            y = k;

            % le coordinate dei punti sono nel sistema alto/sx
            % uso floor per riportarle nel sistema corretto
            % x = j - floor(dim_x/2);
            % y = floor(dim_y/2) - k;
            
            class(k,j,i) = (((x - x0)^2)/a(i)^2) + (((y - y0)^2)/b(i)^2);
           
            % non prendo 1 tondo perche è difficile da ottenere
            if (class(k,j,i) > 0.955) && (class(k,j,i) < 1.045)
                divisa(k,j,i) = 255;

            elseif class(k,j,i) > 1
                divisa(k,j,i) = 0;
            
            elseif class(k,j,i) < 1
                divisa(k,j,i) = divisa(k,j,i);
            end 
   
        end 
    end 

end 
 
% ultimo terzo 57:84
mancante = numSlice - numSlice1;
a_mean1 = (147-5)/2;
b_mean1 = (106-5)/2;

for i=numSlice1:84
    
    % ad ogni slice devo incrementare i due semiassi dell'ellisse
    a(i) = a_mean1 - ((a_mean1 - a_min)/mancante)*(i-numSlice1);
    b(i) = b_mean1 - ((b_mean1 - b_min)/mancante)*(i-numSlice1);
    
    for j=1:dim_x
        for k =1:dim_y
            
            x = j;
            y = k;
            % x = j - floor(dim_x/2);
            % y = floor(dim_y/2) - k;

            class(k,j,i) = (((x - x1)^2)/a(i)^2) + (((y - y0)^2)/b(i)^2);
           
            if (class(k,j,i) > 0.955) && (class(k,j,i) < 1.045)
                divisa(k,j,i) = 255;

            elseif class(k,j,i) > 1
                divisa(k,j,i) = 0;
            
            elseif class(k,j,i) < 1
                divisa(k,j,i) = divisa(k,j,i);
            end 
   
        end 
    end 

end


%% --------------------------------------------------------------------- %
% controllo degli ellisse
% verifico che effettivamente io stia calcolando bene i parametri degli
% ellisse per le diverse slice
clear i j
j = [1 10 20 30 40 50];
k = 1;

figure('Name','post-process')
for i=j
    
    x_slice = x0 + a(i)*cos(t);
    y_slice = y0 + b(i)*sin(t);
    
    subplot(3,3,k)
    imshow(uint8(squeeze(totale(:,:,i))))
    hold on
    plot(x_slice,y_slice,'r')
    txt = ['Slice ',num2str(i)];
    title(txt)

    k = k+1;
end 

j = [57 70 84];
for i=j
    
    x_slice = x1 + a(i)*cos(t);
    y_slice = y0 + b(i)*sin(t);
    
    subplot(3,3,k)
    imshow(uint8(squeeze(totale(:,:,i))))
    hold on
    plot(x_slice,y_slice,'r')
    txt = ['Slice ',num2str(i)];
    title(txt)

    k = k+1;
end 


%% --------------------------------------------------------------------- %
% guardo se sta classificando nel modo giusto

clear i j
j = [1 10 20 30 40 50];
k = 1;

figure('Name','classificazione')
for i=j
    
    x_slice = x0 + a(i)*cos(t);
    y_slice = y0 + b(i)*sin(t);
    
    subplot(3,3,k)
    imshow(uint8(squeeze(divisa(:,:,i))))
    % hold on
    % plot(x_slice,y_slice,'r')
    txt = ['Slice ',num2str(i)];
    title(txt)


    k = k+1;
end 

j = [57 70 84];
for i=j
    
    x_slice = x1 + a(i)*cos(t);
    y_slice = y0 + b(i)*sin(t);
    
    subplot(3,3,k)
    imshow(uint8(squeeze(divisa(:,:,i))))
    % hold on
    % plot(x_slice,y_slice,'r')
    txt = ['Slice ',num2str(i)];
    title(txt)


    k = k+1;
end 

%% ---------------------------------------------------------------------------%
% creazione dei 4 cluster: non è un qualcosa di geometrico ma sto dicendo
% che quel particolare livello di grigio, quel colore lì apparteiene alla
% materia bianca piuttosto che alla grigia etc...
k_1 = cell(256,1);      % 1 sfondo
k_2 = cell(256,1);      % 2 sostanza bianca
k_3 = cell(256,1);      % 3 sostanza grigia
k_4 = cell(256,1);      % 4 liquor
k_5 = cell(256,1);      % 5 scatola cranica

% figure('Name','Histogramma')
% histogram(divisa)

% inizializzo i parametri del ciclo
max_iter = 500;
tol_abs = 0.05;

% Inizializzazione dei centroidi: vedo i valori dall'histogramma 
% i due picchi sono uno della materia grigia e uno della bianca
% 1 200 80 37
% 1 220 139 52
centroid_1 = zeros(max_iter,1);
centroid_1(1) = 1;                  % sfondo
centroid_2 = zeros(max_iter,1);
centroid_2(1) = 220;                % sostanza bianca
centroid_3 = zeros(max_iter,1);
centroid_3(1) = 139;                % sostanza grigia
centroid_4 = zeros(max_iter,1);
centroid_4(1) = 52;                 % liquor
centroid_5 = zeros(max_iter,1);
centroid_5(1) = 255;                % scatola cranica


% ---------------------------------------------------------------------------%
% inizializzazione degli elementi per il calcolo dei nuovi centroidi
% sommatorie dei livelli di grigio -> le pongo inizialmente a zero
Sgray1 = 0; 
Sgray2 = 0; 
Sgray3 = 0; 
Sgray4 = 0;
Sgray5 = 0;

N1 = 0; N2 = 0; N3 = 0; N4 = 0; N5 = 0;


%% ---------------------------------------------------------------------------%
% fase effettiva di calcolo
dim = size(divisa(:,:,1));

for j=1:max_iter

    for i=1:84
        
        % scandisco slice per slice
        % Estrapolazione dell'immagine 2D della slice i-esima
        img = divisa(:,:,i);

        % Calcolo delle distanze di ogni singolo voxel dai centroidi dei cluster
        dist_1 = abs(img-centroid_1(j));
        dist_2 = abs(img-centroid_2(j));
        dist_3 = abs(img-centroid_3(j));
        dist_4 = abs(img-centroid_4(j));
        dist_5 = abs(img-centroid_5(j));

        % Ricerca dei voxel con distanza minima da uno dei centroidi
        % per assegnare quel voxel al cluster di quel centroide
        % dist_min = min(min(min(dist_1,dist_2),dist_3),dist_4);
        dist_min = min(min(min(min(dist_1,dist_2),dist_3),dist_4),dist_5);

        k_1{i} = find(dist_1==dist_min);
        k_2{i} = find(dist_2==dist_min);
        k_3{i} = find(dist_3==dist_min);
        k_4{i} = find(dist_4==dist_min);
        k_5{i} = find(dist_5==dist_min);


        % Calcolo delle somme parziali dei livelli di grigio dei voxel 
        % suddivise per cluster, utilizzate alla fine del ciclo for per 
        % poter calcolare i nuovi centroidi
        
        % K_{i} trova l'indice, ora trovo il valore del livello di grigio
        % associato a quell'indice che ha distanza minima dai diversi centroidi 
       
        m1 = img(k_1{i});
        Sgray1 = Sgray1 + sum(m1);
        N1 = N1 + length(m1);

        m2 = img(k_2{i});
        Sgray2 = Sgray2 + sum(m2);
        N2 = N2 + length(m2);

        m3 = img(k_3{i});
        Sgray3 = Sgray3 + sum(m3);
        N3 = N3 + length(m3);

        m4 = img(k_4{i});
        Sgray4 = Sgray4 + sum(m4);
        N4 = N4 + length(m4);

        m5 = img(k_5{i});
        Sgray5 = Sgray5 + sum(m5);
        N5 = N5 + length(m5);
        

    end

    j=j+1;

    % Calcolo dei nuovi centroidi dei cluster
    centroid_1(j) = Sgray1/N1;
    centroid_2(j) = Sgray2/N2;
    centroid_3(j) = Sgray3/N3;
    centroid_4(j) = Sgray4/N4;
    centroid_5(j) = Sgray5/N5;

    % rimetto i parametri a zero per il prossimo giro del ciclo
    Sgray1 = 0; 
    Sgray2 = 0; 
    Sgray3 = 0; 
    Sgray4 = 0;
    Sgray5 = 0;

    N1 = 0; N2 = 0; N3 = 0; N4 = 0; N5 = 0;


    % Se tutte le differenze fra i centroidi appena calcolati e i centroidi
    % precedenti sono inferiori alla soglia tol_abs allora l'algoritmo viene interrotto

    if abs(centroid_1(j)-centroid_1(j-1))<=tol_abs && abs(centroid_2(j)-centroid_2(j-1))<=tol_abs && ...
       abs(centroid_3(j)-centroid_3(j-1))<=tol_abs && abs(centroid_4(j)-centroid_4(j-1))<=tol_abs && ...
       abs(centroid_5(j)-centroid_5(j-1))<=tol_abs
        break;
    end
    
    % if abs(centroid_1(j)-centroid_1(j-1))<=tol_abs && abs(centroid_2(j)-centroid_2(j-1))<=tol_abs && ...
    %    abs(centroid_3(j)-centroid_3(j-1))<=tol_abs && abs(centroid_4(j)-centroid_4(j-1))<=tol_abs     
    %     break;
    % end

    
end 



%% ---------------------------------------------------------------------------%
% Fase di assemblaggio dei cluster

% Assemblaggio delle immagini dei vari cluster utilizzando gli indici dei
% voxel trovati mediante l'algoritmo (aka il ciclo di prima) 
% lo faccio perche i cluster sono dei cell array che non potrei plottare 
% quindi li rendo vettori
sfondo = [];
bianca = [];
grigia = [];
liquor = [];
cranio = [];
cluster_all = [];

black = zeros(dim);

for i=flip(1:185)

    img1 = zeros(dim);
    img2 = zeros(dim);
    img3 = zeros(dim);
    img4 = zeros(dim);
    img5 = zeros(dim);

    % C = cat(dim,A,B) concatenates B to the end 
    % of A along dimension dim when A and B have compatible sizes 
    % 3 significa che è concatenata lungo la terza dimensione
 
    img1(k_1{i}) = 255;
    sfondo = cat(3,img1,sfondo);
    img1 = cat(3,img1,img1,black);

    img2(k_2{i}) = 212;
    bianca = cat(3,img2,bianca);
    img2 = cat(3,img2,black,black);

    img3(k_3{i}) = 170;
    grigia = cat(3,img3,grigia);
    img3 = cat(3,black,img3,black);

    img4(k_4{i}) = 128;
    liquor = cat(3,img4,liquor);
    img4 = cat(3,black,black,img4);

    img5(k_5{i}) = 50;
    cranio = cat(3,img5,cranio);
    img5 = cat(3,black,black,img5);

    imgtot = img1+img2+img3+img4;
    cluster_all = cat(4,imgtot,cluster_all);

end

% tutto = sfondo+bianca+grigia+liquor;
tutto = sfondo+bianca+grigia+liquor+cranio;


%% ---------------------------------------------------------------------------%
% Visualizzazione dei risultati

% visualiziamo una slice precisa
slice = 40;
x_slice = x0 + a(slice)*cos(t);
y_slice = y0 + b(slice)*sin(t);

figure('Name','Visualizzazione Grafica')
subplot(1,3,1)
imshow(uint8(squeeze(totale(:,:,slice))))
title('Slice Originaria')
subplot(1,3,2)
imshow(uint8(squeeze(divisa(:,:,slice))))
title('Isolamento Scatola Cranica')
subplot(1,3,3)
imshow(uint8(squeeze(cluster_all(:,:,:,slice))))
hold on
plot(x_slice,y_slice,'m','LineWidth',2)
title('Slice Segmentata')




% segmentazione
figure('Name','Segmentazione')
subplot(2,2,1)
imshow(uint8(squeeze(sfondo(:,:,slice))),'Colormap',[0 0 0; 1 1 0])
title('Cluster: Sfondo')

subplot(2,2,2)
imshow(uint8(squeeze(bianca(:,:,slice))),'Colormap',[0 0 0; 1 0 0])
title('Cluster: Sostanza Bianca')

subplot(2,2,3)
imshow(uint8(squeeze(grigia(:,:,slice))),'Colormap',[0 0 0; 0 1 0])
title('Cluster: Sostanza Grigia')

subplot(2,2,4)
imshow(uint8(squeeze(liquor(:,:,slice))),'Colormap',[0 0 0; 0 0 1])
title('Cluster: Liquor')

% subplot(2,3,5)
% imshow(uint8(squeeze(not(cranio(:,:,slice)))),'Colormap',[0 0 0; 1 1 1])
% title('Cluster: Scatola Cranica')


%% -------------------------------------------------------------------------- %
% FASE FINALE di salvataggio
 
% % prdispongo un nuovo campo che sarà il nifti - me la mette in un formato
% % utile in modo poi da applicare l'ultimo comando di salvataggio
% nii = make_nii(matrice);
% 
% % organizzo la matrice in modo che se la apro in un qualunque
% % visualizzatore posso avere tutti i voxel nel punto giusto. Parto da una
% % T1 e lavoro con una T1 allora sfrutto il suo header
% nii.hdr = T1.hdr;
% 
% % salvo u file con estensione .nii - in input vuole due elementi
% % - la variabile struttura che ho creato e alla quale ho associato l'header
% % - il nome che voglio dare al nuovo file .nii
% save_nii(nii,'nuovo_file_nifti.nii');


nii = make_nii(sfondo);
nii.hdr = T3D.hdr;
save_nii(nii,'cluster_sfondo.nii');

nii = make_nii(bianca);
nii.hdr = T3D.hdr;
save_nii(nii,'cluster_bianca.nii');

nii = make_nii(grigia);
nii.hdr = T3D.hdr;
save_nii(nii,'cluster_grigia.nii');

nii = make_nii(liquor);
nii.hdr = T3D.hdr;
save_nii(nii,'cluster_liquor.nii');

% nii = make_nii(cranio);
% nii.hdr = T3D.hdr;
% save_nii(nii,'cluster_cranio.nii');

nii = make_nii(tutto);
nii.hdr = T3D.hdr;
save_nii(nii,'cluster_all.nii');









