%% MASCHERA
% funzione che trova omega intersezione delle due immagini

function [maschera] = crea_maschera_intersezione(alpha,tx,ty,sx,sy,sxy,dim)

    maschera = double(optimized_affine_trasformation(uint8(ones(dim)),[alpha,tx,ty,sx,sy,0]));
    
    % i pixel fuori dalla maschera creata hanno valore NaN
    maschera(maschera==0) = NaN;
end




