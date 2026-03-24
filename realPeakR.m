function [input] = realPeakR(input, metodo)
fs = input(1).sig.fs;
th_acp = 0.1;
N = round((25*fs)/360); % janela de busca do máximo

switch(metodo)
    case '1'
        for i = 1:length(input)
            A = 0; B = 0;
            ind = input(i).anotQRS.annR;
            ind_max = zeros(size(ind,1),1);
            ind_min = zeros(size(ind,1),1);
            m = 0; n = 0;
            for j = 1:size(ind,1)
                if (((ind(j,1)+N) <= size(input(i).sig.signals,1)) && ((ind(j,1)-N) >= 1))
%                     x = input(i).sig.signals((ind(j,1)-N):(ind(j,1)+N),1);
                    x = input(i).sig.viewer3((ind(j,1)-N):(ind(j,1)+N),1);
                    
                    [aux_amp_max,aux_ind_max] = max(x);
                    a = (ind(j,1) - N) + (aux_ind_max - 1);
                    [aux_amp_min,aux_ind_min] = min(x);
                    b = (ind(j,1) - N) + (aux_ind_min - 1);
                elseif ((ind(j,1)-N) < 1)
%                     x = input(i).sig.signals(1:(ind(j,1)+N),1);
                    x = input(i).sig.viewer3(1:(ind(j,1)+N),1);
                    
                    [aux_amp_max,aux_ind_max] = max(x);
                    a = aux_ind_max;
                    [aux_amp_min,aux_ind_min] = min(x);
                    b = aux_ind_min;
                else
%                     x = input(i).sig.signals((ind(j,1)-N):end,1);
                    x = input(i).sig.viewer3((ind(j,1)-N):end,1);
                    
                    [aux_amp_max,aux_ind_max] = max(x);
                    a = (ind(j,1) - N) + (aux_ind_max - 1);
                    [aux_amp_min,aux_ind_min] = min(x);
                    b = (ind(j,1) - N) + (aux_ind_min - 1);
                end                
                
                if j > 1
                    if ((a - ind_max(m,1))/fs) > th_acp
                        m = m + 1;
                        ind_max(m,1) = a;
                    end
                    if ((b - ind_min(n,1))/fs) > th_acp
                        n = n + 1;
                        ind_min(n,1) = b;
                    end
                else
                    m = m + 1; n = n + 1;
                    ind_max(m,1) = a;
                    ind_min(n,1) = b;
                end
                
%                 if (abs(input(i).sig.signals(ind_max(j,1)-1,1))) >= (abs(input(i).sig.signals(ind_min(j,1)-1,1)))
%                 if (abs(input(i).sig.viewer3(ind_max(j,1)-1,1))) >= (abs(input(i).sig.viewer3(ind_min(j,1)-1,1)))
                if (abs(aux_amp_max)) >= (abs(aux_amp_min))
                    A = A + 1;
                else
                    B = B + 1;
                end
%                 ind(j,1) = (ind(j,1) - N) + (aux_ind_max - 1);
            end            
            if A >= B                
                ind = ind_max(1:m,1);
            else
                ind = ind_min(1:n,1);
            end
            input(i).anotQRS.annR = ind;
%             input(i).sig.viewer12 = ind;
        end        
    case '2'
        % interpolação
        r = 4; n = 4;
        for i = 1:length(input)
            ind = input(i).anotQRS.annR;
            for j = 1:size(ind,1)
                x = input(i).sig.signals((ind(j,1)-N):(ind(j,1)+N),1);
                x = interp(x,r,n);
                [~,aux_ind1] = max(abs(x));
                ind(j,1) = (((ind(j,1) - N - 1) * r) + 1) + (aux_ind1 - 1);
            end
            input(i).anotQRS.annR = ind;
            % contruir uma referencia para a nova frequencia de amostragem
            % ou passar para o tempo
        end 
    otherwise
        disp('Método de entrada não reconhecido');
end
end