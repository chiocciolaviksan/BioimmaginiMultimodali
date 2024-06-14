%% METODO DELLA FORZA BRUTA
% script che implementa il metodo della forza bruta

err = zeros(size(trasx,2),size(trasy,2),size(alf,2));
errore = 0;

% ciclo annidato con 3 variabili:
% -k = angolo
% t1 = traslazione in x
% t2 = traslazione in y
for  k=1:size(alf,2) 
    for t1=1:size(trasx,2)
        for t2=1:size(trasy,2)

            % richiamo la funzione della trasformazione affine
            [img_rot] = optimized_affine_trasformation(float_img,[alf(k) trasx(t1) trasy(t2)...
                1 1 0]);

            % l'errore è il funzionale che sto valutando quindi la somma al
            % quadrato delle differenze - provo le trasformazioni affini
            % con i 3 parametri - calcolo l'errore e alla fine dei cicli ho
            % una matrice di errorri in R3
            err(t1,t2,k)= sum(sum((rif_img-img_rot ).^2));   
        end
    end
end

% calcolo dove sta il minimo dell'errore e trovo i 3 indici che mi dicano
% quali erano il t1 t2 e k migliori - mette i 'vettori' che compongono la matrice 
% degli errori uno in fila all'altro - calcolo il minimo e poi mi permette di 
% ritrovare a b c - indice di qunando ritorno ad avere la matrice - questo
% perche matlab riesce a calcolare il min di una matrice 2D ma non 3x3
[~,ind] = min(err(:));
[a,b,c] = ind2sub(size(err), ind);




