%% METODO DELLA CROSS CORRELAZIONE
% script che implementa il metodo della cross correlazione

CC = zeros(length(alfa),length(tx),length(ty),length(sx),length(sy));

for i=1:length(alfa)
    for j=1:length(tx)
        for k=1:length(ty)
            for u=1:length(sx)
                for v=1:length(sy)

                    % Applicazione della traformazione affine all'immagine da registrare
                    img_rot_CC = optimized_affine_trasformation(imgD,[alfa(i),tx(j),ty(k),sx(u),sy(v),0]);

                    % Creazione della maschera che permette di considerare
                    % solo i pixel presenti nella regione di intersezione
                    % fra le due immagini
                    maschera = crea_maschera_intersezione(alfa(i),tx(j),ty(k),sx(u),sy(v),0,dim);

                    img_rif_inters = double(imgA).*maschera;
                    img_rot_inters = double(img_rot_CC).*maschera;

                    % Calcolo dell'intesità media delle due immagini
                    mean_int_rif = mean(img_rif_inters(:),'omitnan');
                    mean_int_rot = mean(img_rot_inters(:),'omitnan');

                    % Calcolo del coefficiente CC
                    numer_CC = sum(sum((img_rif_inters-mean_int_rif).*(img_rot_inters-mean_int_rot),'omitnan'),'omitnan');
                    denom_CC = sqrt(sum(sum((img_rif_inters-mean_int_rif).^2,'omitnan'),'omitnan')*sum(sum((img_rot_inters-mean_int_rot).^2,'omitnan'),'omitnan'));
                    CC(i,j,k,u,v) = numer_CC/denom_CC;

                end
            end
        end
    end
end

% Ricerca del massimo
[~,indice] = max(CC(:));
[ind_alfa,ind_tx,ind_ty,ind_sx,ind_sy] = ind2sub(size(CC), indice);



