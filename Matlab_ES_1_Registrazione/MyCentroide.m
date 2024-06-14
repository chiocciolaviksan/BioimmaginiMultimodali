%% Funzione MyCentroide
% funzione che restituisce la posizione dei centroidi

function [XC,YC] = MyCentroide(X,Y,W)

switch nargin
        case 3
            
            W=W.^2;
            XC = sum(X.*W)/sum(W);
            YC = sum(Y.*W)/sum(W);

        case 2
            % se non gli passo il valore del peso W
            % di default mette 1
            W = ones(length(X(:,1)),1);
            XC = sum(X.*W)/sum(W);
            YC = sum(Y.*W)/sum(W);

     otherwise
            W = ones(length(X(:,1)),1);
            XC = sum(X.*W)/sum(W);
            YC = 0;
            
 end

end 






