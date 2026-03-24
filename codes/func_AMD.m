% Função amplitude média deslizante
% Pedro Henrique Borghi de Melo

% metod:
% rect -> retangular
% hann -> hanning
% hamm -> hamming
% black -> blackman

function [out] = func_AMD(in, N, metod)
L_in = size(in,1);
% out = in;

switch(metod)
    case 'rect'
        W = ones(N,1);
        for i = 1:((N-1)/2)
            out(i,1) = mean(W(((N-1)/2)-(i-1)+1:end,1) .* (in(1:((N-1)/2)+i,1)));
        end
        for i = (((N-1)/2)+1):(L_in - ((N-1)/2))
            out(i,1) = mean(W .* in(i-((N-1)/2):i+((N-1)/2)));
        end
        for i = (L_in - ((N-1)/2) + 1):L_in
            out(i,1) = mean(W(1:(N-(i-(L_in -(N-1)/2)))) .* in(i-((N-1)/2):L_in));
        end
        
    case 'hann'
        W(:,1) = 0.5 + 0.5*cos(2*pi*(fix(-N/2):fix(N/2))/(N-1));
        for i = 1:((N-1)/2)
            out(i,1) = mean(W(((N-1)/2)-(i-1)+1:end,1) .* (in(1:((N-1)/2)+i,1)));
        end
        for i = (((N-1)/2)+1):(L_in - ((N-1)/2))
            out(i,1) = mean(W .* in(i-((N-1)/2):i+((N-1)/2)));
        end
        for i = (L_in - ((N-1)/2) + 1):L_in
            out(i,1) = mean(W(1:(N-(i-(L_in -(N-1)/2)))) .* in(i-((N-1)/2):L_in));
        end
        
    case 'hamm'
        W(:,1) = 0.54 + 0.46*cos(2*pi*(fix(-N/2):fix(N/2))/(N-1));
        for i = 1:((N-1)/2)
            out(i,1) = mean(W(((N-1)/2)-(i-1)+1:end,1) .* (in(1:((N-1)/2)+i,1)));
        end
        for i = (((N-1)/2)+1):(L_in - ((N-1)/2))
            out(i,1) = mean(W .* in(i-((N-1)/2):i+((N-1)/2)));
        end
        for i = (L_in - ((N-1)/2) + 1):L_in
            out(i,1) = mean(W(1:(N-(i-(L_in -(N-1)/2)))) .* in(i-((N-1)/2):L_in));
        end
        
    case 'black'
        W(:,1) = 0.42 + 0.5*cos(2*pi*(fix(-N/2):fix(N/2))/(N-1)) ...
            + 0.08*cos(4*pi*(fix(-N/2):fix(N/2))/(N-1));
        for i = 1:((N-1)/2)
            out(i,1) = mean(W(((N-1)/2)-(i-1)+1:end,1) .* (in(1:((N-1)/2)+i,1)));
        end
        for i = (((N-1)/2)+1):(L_in - ((N-1)/2))
            out(i,1) = mean(W .* in(i-((N-1)/2):i+((N-1)/2)));
        end
        for i = (L_in - ((N-1)/2) + 1):L_in
            out(i,1) = mean(W(1:(N-(i-(L_in -(N-1)/2)))) .* in(i-((N-1)/2):L_in));
        end
    otherwise
end
end