%% Intro
% Pedro Henrique Borghi de Melo

% Funções Jitter
% Descrição...

function [input] = jitter(input)

for i = 1:size(input,2) % percorre o numero de individuos
    n = size(input(i).RRI.RRI30,2);
    m = size(input(i).RRI.RRI30,1);
    for j = 1:n % percorre o numero de intevalos 30 seg de cada ind.
        aux1 = 0; aux2 = 0; aux3 = 0;
        for k = 1:(m-1)
            aux1 = aux1 + abs(input(i).RRI.RRI30(k,j) - input(i).RRI.RRI30(k+1,j));
            if k >= 2
                aux2 = aux2 + abs(input(i).RRI.RRI30(k,j) - mean(input(i).RRI.RRI30(k-1:k+1,j)));
            end
            if (k>=3) && (k<=(m-2))
                aux3 = aux3 + abs(input(i).RRI.RRI30(k,j) - mean(input(i).RRI.RRI30(k-2:k+2,j)));
            end
        end
        
        input(i).jitter.jitterA30(1,j) = aux1/(m-1); % Jitter Absoluto
        
        media = mean(input(i).RRI.RRI30(:,j));        
        input(i).jitter.jitterL30(1,j) = (input(i).jitter.jitterA30(1,j) * 100)/media; % Jitter Local
        input(i).jitter.jitterRAP30(1,j) = (aux2*100)/(media*(m-2)); % Jitter RAP
        input(i).jitter.jitterPPQ530(1,j) = (aux3*100)/(media*(m-4)); % Jitter PPQ5        
    end
end
end