%% METODO DELLA MUTUA INFORMAZIONE
% script che implementa ilmetodo della mutua informazione

MI = zeros(length(alfa),length(tx),length(ty),length(sx),length(sy));

for i=1:length(alfa)
    for j=1:length(tx)
        for k=1:length(ty)
            for u=1:length(sx)
                for v=1:length(sy)

                    % Applicazione della traformazione affine all'immagine da registrare
                    img_rot_MI = optimized_affine_trasformation(imgD,[alfa(i),tx(j),ty(k),sx(u),sy(v),0]);

                    % Creazione della maschera che permette di considerare
                    % solo i pixel presenti nella regione di intersezione
                    % fra le due immagini
                    maschera = crea_maschera_intersezione(alfa(i),tx(j),ty(k),sx(u),sy(v),0,dim);

                    img_rif_inters = double(imgA).*maschera;
                    img_rot_inters = double(img_rot_MI).*maschera;

                    img_rif_inters(isnan(img_rif_inters)) = 0;
                    img_rot_inters(isnan(img_rot_inters)) = 0;
        

                    % Calcolo della probabilità con istogramma congiunto delle due immagini
                    [p_cong,p_marg_rif,p_marg_rot] = bihist(img_rif_inters,img_rot_inters);

                    % Calcolo delle entropie
                    E_rif = sum(p_marg_rif.*log2(p_marg_rif),'omitnan');
                    E_rot = sum(p_marg_rot.*log2(p_marg_rot),'omitnan');
                    E_cong = sum(p_cong(:).*log2(p_cong(:)),'omitnan');

                    % Calcolo della MI
                    MI(i,j,k,u,v) = (E_rif+E_rot)/E_cong;   % normalizzata
                    % IM(i,j,k,u,v) = (E_rif+E_rot)-E_cong; % teorica

                end
            end
        end
    end
end

% Ricerca del massimo
[~,indice] = max(MI(:));
[ind_alfaMI,ind_txMI,ind_tyMI,ind_sxMI,ind_syMI] = ind2sub(size(MI), indice);


