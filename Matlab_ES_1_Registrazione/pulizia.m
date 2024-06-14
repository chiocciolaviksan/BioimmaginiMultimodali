%% PULIZIA
% sript che ripulisce le variabili del workspace

if (trash==1) % CENTROIDI
   
    clear K L R s S U V w Z
    clear s1 s2 Sotto Sopra
    clear alpha tx ty t theta 
    clear X_bar Y_bar xA xB yA yB yCA yCB xCA xCB
    clear xi xi_bar yi yi_bar
    clear cong_centr img_rot_centr

end 

if (trash==2) % PAR

    clear IxxA IyyA IxyA IxxB IyyB IxyB
    clear k l L I sA sB th k k1 l l1 
    clear EA EB DA DB IA IB VA VB
    clear lambdaA lambdaB THETA
    clear theta Theta Alpha AlphaA AlphaB Fs img_rot_PAR
    clear centroide_x_float centroide_x_ref centroide_y_float centroide_y_ref
    clear dim_ref ing_ref img_float 
    clear cong_PAR centroidsA centroidsB
    clear B_rif B_float centr_rif centr_float
    clear centroide_xA centroide_xB centroide_yA centroide_yB
    clear i tx ty j traslazioni
    
end

if (trash==3) % MARKERS

    clear x11 x13 x14
    clear x y u v corr
    clear dist indice_dist_min
    clear theta alpha tx ty THETA B
    clear cong_markers cong_before
    clear centers_float centers_rif
end 

if (trash==4) % FORZA BRUTA
    
    clear a b c cong_after
    clear err errore
    clear ind j k theta
end 

if (trash==5) % GRADIENTE/SSD

    clear a b deriv2 err1 errore1 
    clear a1 b1 c1 ind r t1 t2
    clear h v deriv2 deriv1 vector_img 
    clear cong1 
end 

if (trash==6) % CORSS-CORRELAZIONE

    clear maschera mean_int_rif mean_int_rot
    clear cong_CC CC denom_CC numer_CC img_rif_inter img_rot_inter
    clear s j k i u v
    clear theta CC img_rif_inters img_rot_CC
    clear ind_alfa ind_sx ind_sy ind_tx ind_ty indice
end

if (trash==7) % MUTUA INFORMAZIONE

    clear maschera mean_int_rif mean_int_rot
    clear E_rif E_rot E_cong MI img_rif_inters img_rot_inters
    clear j k i p_cong p_marg_rif p_marg_rot
    clear theta cong_MI inf_alfa ind_s ind_sx ind_sy
    clear ind_tx ind_ty indice j k 

end 

if (trash==8) % RIU

    clear cong_RIU dim pixel step theta
    clear mean_ratio_img ratio_img X j k i
    clear RIU sd_ratio_img trasx trasy u v x weight
    clear ind_alfa ind_s ind_tx ind_ty indice 
end 

