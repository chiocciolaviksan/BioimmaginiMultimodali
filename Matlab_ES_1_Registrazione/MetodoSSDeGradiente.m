%% METODO SSD/GRADIENTE
% script che implementa SSD e Gradiente

errore1 = zeros(size(trasx,2),size(trasy,2),size(alf,2)); 
err1 = 0;


for r=1:size(alf,2)
    for t1=1:size(trasx,2)
        for t2=1:size(trasy,2)
            
            [img_rot1] = optimized_affine_trasformation(float_img,[alf(r) trasx(t1) trasy(t2) 1 1 0]);
            
            % Matrice di rotazione
            a = -sin(alf(r))-cos(alf(r)); 
            b = cos(alf(r))-sin(alf(r));
            
            % Derivata trasformazione
            deriv2 = [a, 1, 0; b, 0 ,1];
            v = edge(img_rot1,'sobel',[],'vertical');
            h = edge(img_rot1,'sobel',[],'horizontal');
            deriv1 = [h(:), v(:)];
            vector_img = rif_img-img_rot1; 
            vector_img =[vector_img(:),vector_img(:),vector_img(:)]; 

            % quando faccio la derivata ottengo -2 
            err1 = -2*double(vector_img).*(double(deriv1)*deriv2); 
            errore1(t1,t2,r) = sqrt(sum(sum(err1).^2));
            err1 = zeros(1,3);
        end 
    end
end

% Trova il minimo
[~, ind] = min(abs(errore1(:)));
[a1,b1,c1] = ind2sub(size(errore1), ind); 


