%% METODO DELLA RIU
% script che implementa il metodo RIU

RIU = zeros(length(alfa),length(tx),length(ty),length(sx),length(sy));

for i=1:length(alfa)
    for j=1:length(tx)
        for k=1:length(ty)
            for u=1:length(sx)
                for v=1:length(sy)

                % Applicazione della traformazione affine all'immagine da registrare
                img_rot_RIU = optimized_affine_trasformation(imgD,[alfa(i),tx(j),ty(k),sx(u),sy(v),0]);

                % Creazione della maschera che permette di considerare
                % solo i pixel presenti nella regione di intersezione
                % fra le due immagini
                maschera = crea_maschera_intersezione(alfa(i),tx(j),ty(k),sx(u),sy(u),0,dim);

                img_rif_inters = double(imgA).*maschera;
                img_rot_inters = double(img_rot_RIU).*maschera;

                % Calcolo dell'immagine rapporto
                ratio_img = img_rot_inters(:)./img_rif_inters(:);

                % Calcolo della media immagine rapporto
                mean_ratio_img = mean(ratio_img,'omitnan');

                % Calcolo della deviazione standard immagine rapporto
                sd_ratio_img = std(ratio_img,'omitnan');

                % Calcolo del coefficiente RIU
                RIU(i,j,k,u,v) = sd_ratio_img/mean_ratio_img;
                
                end

            end
        end
    end
end

% sRicerca del minimo
[~,indice] = min(RIU(:));
[ind_alfa,ind_tx,ind_ty,ind_sx,ind_sy] = ind2sub(size(RIU),indice);




