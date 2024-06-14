%% TRASFORMAZIONE AFFINE

function [img_rot] = optimized_affine_trasformation(float_img,p)
% affine trasformation of 2D image with 6 dof( 1rotation, 2traslation,
% 3scaling/shear)

if nargin==0
    % se non gli do in imput dei parametri lui si piglia quelli di default
    
    % default image    
    float_img= imread('coronal_B.tif');
    float_img= float_img(:,:,1);

    % default_parameters
    alf = -30*pi/180;
    t = [0;0];
    s = [1 0;
        0 1];
else
    
% ad es. posso gia vedere che p(1) sara negativo perche la devo riutare in
% senso antiorario - siccome y a in basso deveo traslare in alto e saranno
% negative anche loro perche sto tornando indietro verso l'alto
alf = p(1);
t = [p(2);p(3)];                 % traslazione in x e y
s = [p(4), p(6); p(6),  p(5)];   % shear p(6) aka elementi fuori diag
                                 % p(4) e p(5) sono invece sulla diagonale
end

% inizializzazione parametri
dim = size(float_img); 
img_rot = uint8(zeros(dim(1),dim(2)));
rotation_matrix = [cos(alf)  -sin(alf); sin(alf) cos(alf)];                                                

% creazione sisteme di coordinate traslato nell'origine
% in sintes è come nello script dove aggiungo 298 per spostare l'origine
% degli assi
x = -floor(dim(2)/2):1:floor(dim(2)/2);
y = -floor(dim(1)/2):1:floor(dim(1)/2);

% sistema di coordinate originale
i = 1:dim(1);
j = 1:dim(2);

% vettori coodrinate(tutte le combinazionei x,y del piano)
% uno dei due si riferisce all'immagine origonale e l'altra a quella ruotata
[x,y] = meshgrid(x,y);
[j,i] = meshgrid(j,i);
x=x(:); y=y(:);
i=i(:); j=j(:);

% trasfomazione inversa dell'immagine
cord = (s*rotation_matrix)\[x';y'];
tr = (s*rotation_matrix)\t;

% cambio di sistema di rifermento nel sistema img
i_t= round(cord(2,:)-tr(2))+floor(dim(1)/2)+1 ;
j_t= round(cord(1,:)-tr(1))+floor(dim(2)/2)+1;

% controllo ed eliminazione valori esterni dal piano img
% quando applico la roto-traslazione xk ci sono dei pti che finiscono fuori
% dal quadrato dell'immagine
i_t1 = i_t;j_t1 = j_t;
m = [i_t1',j_t1',i,j];
m(i_t<=0|i_t>dim(1)|j_t<=0|j_t>dim(2),:)=[];
%j_t1(i_t<=0|i_t>dim(1)|j_t<=0|j_t>dim(2))=[];
%i(i_t<=0|i_t>dim(1)|j_t<=0|j_t>dim(2))=[];
%j(i_t<=0|i_t>dim(1)|j_t<=0|j_t>dim(2))=[];

% trasposiozione indice 
ind_t = sub2ind(dim,m(:,1),m(:,2));
ind = sub2ind(dim,m(:,3),m(:,4));

% scandisco tutta l'immagine trasformato e attraverso la trasformazione
% inversa posso recuperare i pixel precedenti alla trasformazione
% nell'immagine orginale
img_rot(ind) = float_img(ind_t);

% faccio i calcoli in float e poi li rendo interi dopo

