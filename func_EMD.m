% Função energia média deslizante
% Pedro Henrique Borghi de Melo

% metod:
% rect -> retangular
% hann -> hanning
% hamm -> hamming
% black -> blackman

function [out] = func_EMD(in, N, metod)
L_in = size(in,1);
% out = in;

switch(metod)
    case 'rect'
        W = ones(1,N);
        for i = 1:fix((N-1)/2)
            out(i,1) = mean(W(1,fix((N-1)/2)-(i-1)+1:end)' .* (in(1:fix((N-1)/2)+i,1).^2));
        end
        for i = (fix((N-1)/2)+1:(L_in - fix((N-1)/2)))
            out(i,1) = mean(W' .* (in(i-fix((N-1)/2):i+fix((N-1)/2)).^2));
        end
        for i = (L_in - fix((N-1)/2) + 1):L_in
            out(i,1) = mean(W(1:(N-(i-(L_in -(N-1)/2))))' .* (in(i-fix((N-1)/2):L_in).^2));
        end
        
    case 'hann'
        W(1,:) = 0.5 + 0.5*cos(2*pi*(fix(-N/2):fix(N/2))/(N-1));
        for i = 1:fix((N-1)/2)
            out(i,1) = mean(W(1,fix((N-1)/2)-(i-1)+1:end)' .* (in(1:fix((N-1)/2)+i,1).^2));
        end
        for i = (fix((N-1)/2)+1:(L_in - fix((N-1)/2)))
            out(i,1) = mean(W' .* (in(i-fix((N-1)/2):i+fix((N-1)/2)).^2));
        end
        for i = (L_in - fix((N-1)/2) + 1):L_in
            out(i,1) = mean(W(1:(N-(i-(L_in -(N-1)/2))))' .* (in(i-fix((N-1)/2):L_in).^2));
        end
        
    case 'hamm'
        W(1,:) = 0.54 + 0.46*cos(2*pi*(fix(-N/2):fix(N/2))/(N-1));
        
        for i = 1:fix((N-1)/2)
            out(i,1) = mean(W(1,fix((N-1)/2)-(i-1)+1:end)' .* (in(1:fix((N-1)/2)+i,1).^2));
        end
        for i = (fix((N-1)/2)+1:(L_in - fix((N-1)/2)))
            out(i,1) = mean(W' .* (in(i-fix((N-1)/2):i+fix((N-1)/2)).^2));
        end
        for i = (L_in - fix((N-1)/2) + 1):L_in
            out(i,1) = mean(W(1:(N-(i-(L_in -(N-1)/2))))' .* (in(i-fix((N-1)/2):L_in).^2));
        end
        
    case 'black'
        W(1,:) = 0.42 + 0.5*cos(2*pi*(fix(-N/2):fix(N/2))/(N-1)) ...
            + 0.08*cos(4*pi*(fix(-N/2):fix(N/2))/(N-1));
        for i = 1:fix((N-1)/2)
            out(i,1) = mean(W(1,fix((N-1)/2)-(i-1)+1:end)' .* (in(1:fix((N-1)/2)+i,1).^2));
        end
        for i = (fix((N-1)/2)+1:(L_in - fix((N-1)/2)))
            out(i,1) = mean(W' .* (in(i-fix((N-1)/2):i+fix((N-1)/2)).^2));
        end
        for i = (L_in - fix((N-1)/2) + 1):L_in
            out(i,1) = mean(W(1:(N-(i-(L_in -(N-1)/2))))' .* (in(i-fix((N-1)/2):L_in).^2));
        end
        
    otherwise
end
end