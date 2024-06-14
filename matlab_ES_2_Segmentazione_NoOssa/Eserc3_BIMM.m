%% ESERCITAZIONE 3 
% Esercitazione riguardante la segmentazione

clear all
close all
clc

% L'IMMAGINE di volume ha le seguenti caratteristiche
% piano trasversale: terzo indice, fino a 256 (185)
% piano frontale:    secondo indice, fino a 240
% piano sagittale:   primo indice, fino a 176


%% ---------------------------------------------------------------------------%
% FASE INIZIALE
% se proprio vogliamo usare i file zippatio e li vogliamo unzippare uso
% questo comando, altrimenti uso gia i file non zippati
% ! gunzip S01_T1_atlas_space_brain.nii.gz
% ! gunzip S01_T1_atlas_space.nii.gz

T1 = load_untouch_nii('S01_T1_atlas_space_brain.nii');
matrice = T1.img;

% plot utile per la visualizzazione iniziale
% disegnamo solo una slice
% imtool(matrice(:,:,56))
figure('Name','Visualizzazione Iniziale')
imshow(uint8(squeeze(matrice(:,:,56))))

% % guardo l'istogramma dei livelli di grigio
% figure('Name','Histogramma')
% histogram(matrice)



%% ---------------------------------------------------------------------------%
% creazione dei 4 cluster: non è un qualcosa di geometrico ma sto dicendo
% che quel particolare livello di grigio, quel colore lì apparteiene alla
% materia bianca piuttosto che alla grigia etc...
k_1 = cell(256,1);      % 1 sfondo
k_2 = cell(256,1);      % 2 sostanza bianca
k_3 = cell(256,1);      % 3 sostanza grigia
k_4 = cell(256,1);      % 4 liquor

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
centroid_3(1) = 135;                % sostanza grigia
centroid_4 = zeros(max_iter,1);
centroid_4(1) = 52;                 % liquor


% ---------------------------------------------------------------------------%
% inizializzazione degli elementi per il calcolo dei nuovi centroidi
% sommatorie dei livelli di grigio -> le pongo inizialmente a zero
Sgray1 = 0; 
Sgray2 = 0; 
Sgray3 = 0; 
Sgray4 = 0;

N1 = 0; N2 = 0; N3 = 0; N4 = 0;


%% ---------------------------------------------------------------------------%
% fase effettiva di calcolo
dim = size(matrice(:,:,1));

for j=1:max_iter

    for i=1:dim
        
        % scandisco slice per slice
        % Estrapolazione dell'immagine 2D aka la slice i-esima
        img = matrice(:,:,i);

        % Calcolo delle distanze di ogni singolo voxel dai centroidi dei cluster
        dist_1 = abs(img-centroid_1(j));
        dist_2 = abs(img-centroid_2(j));
        dist_3 = abs(img-centroid_3(j));
        dist_4 = abs(img-centroid_4(j));

        % Ricerca dei voxel con distanza minima da uno dei centroidi
        % per assegnare quel voxel al cluster di quel centroide
        dist_min = min(min(min(dist_1,dist_2),dist_3),dist_4);

        % dist = [dist_1 dist_2 dist_3 dist_4];     % equivalente
        % dist_min = min(dist);

        k_1{i} = find(dist_1==dist_min);
        k_2{i} = find(dist_2==dist_min);
        k_3{i} = find(dist_3==dist_min);
        k_4{i} = find(dist_4==dist_min);

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
        

    end

    j=j+1;

    % Calcolo dei nuovi centroidi dei cluster (media)
    centroid_1(j) = Sgray1/N1;
    centroid_2(j) = Sgray2/N2;
    centroid_3(j) = Sgray3/N3;
    centroid_4(j) = Sgray4/N4;

    % rimetto i parametri a zero per il prossimo giro del ciclo
    Sgray1 = 0; 
    Sgray2 = 0; 
    Sgray3 = 0; 
    Sgray4 = 0;

    N1 = 0; N2 = 0; N3 = 0; N4 = 0;


    % Se tutte le differenze fra i centroidi appena calcolati e i centroidi
    % precedenti sono inferiori alla soglia tol_abs allora l'algoritmo viene interrotto

    if abs(centroid_1(j)-centroid_1(j-1))<=tol_abs && abs(centroid_2(j)-centroid_2(j-1))<=tol_abs && ...
       abs(centroid_3(j)-centroid_3(j-1))<=tol_abs && abs(centroid_4(j)-centroid_4(j-1))<=tol_abs
        break;
    end

    
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
liquor= [];
cluster_all = [];

black = zeros(dim);

for i=flip(1:185)

    img1 = zeros(dim);
    img2 = zeros(dim);
    img3 = zeros(dim);
    img4 = zeros(dim);

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

    imgtot = img1+img2+img3+img4;
    cluster_all = cat(4,imgtot,cluster_all);

end

tutto = sfondo+bianca+grigia+liquor;


%% ---------------------------------------------------------------------------%
% Visualizzazione dei risultati

% visualiziamo una slice precisa
slice = 56;

figure('Name','Originale')
subplot(1,2,1)
imshow(uint8(squeeze(matrice(:,:,slice))))
title('Slice originaria')
subplot(1,2,2)
imshow(uint8(squeeze(cluster_all(:,:,:,slice))))
title('Slice segmentata')

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


%% -------------------------------------------------------------------------- %
% FASE FINALE di salvataggio
 
% predispongo un nuovo campo che sarà il nifti - me la mette in un formato
% utile in modo poi da applicare l'ultimo comando di salvataggio
% nii = make_nii(matrice);

% organizzo la matrice in modo che se la apro in un qualunque
% visualizzatore posso avere tutti i voxel nel punto giusto. Parto da una
% T1 e lavoro con una T1 allora sfrutto il suo header
% nii.hdr = T1.hdr;

% salvo u file con estensione .nii - in input vuole due elementi
% - la variabile struttura che ho creato e alla quale ho associato l'header
% - il nome che voglio dare al nuovo file .nii
% save_nii(nii,'nuovo_file_nifti.nii');


nii = make_nii(sfondo);
nii.hdr = T1.hdr;
save_nii(nii,'cluster_sfondo.nii');

nii = make_nii(bianca);
nii.hdr = T1.hdr;
save_nii(nii,'cluster_bianca.nii');

nii = make_nii(grigia);
nii.hdr = T1.hdr;
save_nii(nii,'cluster_grigia.nii');

nii = make_nii(liquor);
nii.hdr = T1.hdr;
save_nii(nii,'cluster_liquor.nii');

nii = make_nii(tutto);
nii.hdr = T1.hdr;
save_nii(nii,'cluster_all.nii');


%% -------------------------------------------------------------------------- %
% PULIZIA
% clear centroid_1 centroid_2 centroid_3 centroid_4
% clear dim i j dist_min
% clear dist_1 dist_2 dist_3 dist_4
% clear N1 N2 N3 N4 k_1 k_2 k_3 k_4
% clear Sgray1 Sgray2 Sgray3 Sgray4
% clear m1 m2 m3 m4



