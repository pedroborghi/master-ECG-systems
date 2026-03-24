%% Intro
% Pedro Henrique Borghi de Melo

% Funções Shimmer
% Cálculo de Shimmer para um sinal ECG de 2 derivações

function [input] = shimmer(input)

% th = -1E-10;

for i = 1:size(input,2) 
    n = size(input(i).AMP.AMP30,2);
    m = size(input(i).AMP.AMP30,1);
    for j = 1:n
        aux1 = zeros(4,1);
        aux2 = zeros(2,1);
        aux3 = zeros(2,1);
        for k = 1:(m-1)
            g(1) = input(i).AMP.AMP30(k+1,j,1);
            g(2) = input(i).AMP.AMP30(k,j,1);
            g(3) = input(i).AMP.AMP30(k+1,j,2);
            g(4) = input(i).AMP.AMP30(k,j,2);
            for L = 1:4
                if g(L) == 0
                    while(g(L)==0)
                        g(L) = rand(1)*0.0010 - 0.0005;
                    end
                end
            end
            h1 = abs(20*log10(abs(g(1)/g(2))));
            h2 = abs(20*log10(abs(g(3)/g(4))));
            
%             if h1 == Inf
%                 h1 = th;
%             end
%             if h2 == Inf
%                 h2 = th;
%             end

            aux1(1,1) = aux1(1,1) + h1;
            aux1(2,1) = aux1(2,1) + h2;            
            aux1(3,1) = aux1(3,1) + abs(input(i).AMP.AMP30(k+1,j,1) - input(i).AMP.AMP30(k,j,1));
            aux1(4,1) = aux1(4,1) + abs(input(i).AMP.AMP30(k+1,j,2) - input(i).AMP.AMP30(k,j,2));
            
            if (k >= 2)
                aux2(1,1) = aux2(1,1) + abs(input(i).AMP.AMP30(k,j,1) - mean(input(i).AMP.AMP30(k-1:k+1,j,1)));
                aux2(2,1) = aux2(2,1) + abs(input(i).AMP.AMP30(k,j,2) - mean(input(i).AMP.AMP30(k-1:k+1,j,2)));
            end
            if (k >= 3) && (k<=(m-2))
                aux3(1,1) = aux3(1,1) + abs(input(i).AMP.AMP30(k,j,1) - mean(input(i).AMP.AMP30(k-2:k+2,j,1)));
                aux3(2,1) = aux3(2,1) + abs(input(i).AMP.AMP30(k,j,2) - mean(input(i).AMP.AMP30(k-2:k+2,j,2)));
            end
        end
        
        aux_media = input(i).AMP.AMP30(:,j,1); media(1,1) = mean(aux_media);
        aux_media = input(i).AMP.AMP30(:,j,2); media(2,1) = mean(aux_media);
%         clear aux_media;
        
        input(i).shimmer.shdb(1,j,1) = aux1(1,1)/(m-1); % Shimmer Absoluto
        input(i).shimmer.shdb(1,j,2) = aux1(2,1)/(m-1);        
        
        input(i).shimmer.shim(1,j,1) = (aux1(3,1)*100)/(media(1,1)*(m-1)); % Shimmer Local
        input(i).shimmer.shim(1,j,2) = (aux1(4,1)*100)/(media(2,1)*(m-1)); 
%         clear aux1;
       
        input(i).shimmer.apq3(1,j,1) = (aux2(1,1)*100)/(media(1,1)*(m-2)); % Shimmer APQ3
        input(i).shimmer.apq3(1,j,2) = (aux2(2,1)*100)/(media(2,1)*(m-2));
%         clear aux2;
             
        input(i).shimmer.apq5(1,j,1) = (aux3(1,1)*100)/(media(1,1)*(m-4)); % Shimmer APQ5
        input(i).shimmer.apq5(1,j,2) = (aux3(2,1)*100)/(media(2,1)*(m-4));
%         clear aux3;
    end    
end
end