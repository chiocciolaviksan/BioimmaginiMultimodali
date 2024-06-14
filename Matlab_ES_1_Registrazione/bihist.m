%% bhist - calcolo dell'istogramma
% funzione che mi crea le probabilità marginali e congiunte di x e y

function [p_cong p_marg1 p_marg2] = bihist(img1,img2)


    % mi devo ricordare che in matlab gli indici partono da 1
    % riempio la matrice h dell'hist congiunto con tutti gli zeri fino a 256
    % normalmente avrei 0-255 ma se parto da 1 ho 1-256
    lvl_gray = 256;
    
    % img1=imread(img1);
    % img2=imread(img2);
    dim= size(img2);
    h=zeros(lvl_gray,lvl_gray);
    
    % applico il ciclo sulle due dimensioni dell'immagine 
    % quindi lungo x e lung y
    for i=1:dim(1)
        for j=1:dim(2)
            c = img1(i,j)+1;
            r = img2(i,j)+1;
            h(r,c) = h(r,c)+1;
    
            % riempio l'accumulatore h(r,c) andando ad incrementarlo ogni volta
            % che trovo determinati valori di livelli di grigio nelle posizioni
            % corrispondenti i,j delle du immagini
        end
    end
    
    % nella posizione dell'origine dell'histogramma congliunto vado a mettere
    % un valore nullo altrimenti avrei un valore troppo alto rispetto agli
    % altri e avrei un'immagine dell'histogramma nera, aka non vedrei tutto il
    % resto
    h(1,1) = 0;
    
    % imshow(imadjust(h));
    
    % normalizzo la matrice h in ciascun valore rispetto a tutti i valori che
    % ho considerato in h --> le marginali corrispondono agli histogrammi della
    % singola immagine
    p_cong = h./sum(sum(h));
    p_marg1 = sum(p_cong,1);
    p_marg2 = sum(p_cong,2);

end





