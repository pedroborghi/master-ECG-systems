function [input] = BP_filtR(input,metodo)
fs = input(1).sig.fs;
% d = 1; % derivação

switch(metodo)
    case '1' % Filtragem FIR BP janelado por HSCW
        Mm = 60; % ordem da janela de Hamming (e dos filtros; deve ser par)
        Lm = Mm + 1;
        wm = hamming(Lm);
        
        p = 4; % ordem da Hamming Self-Convolution Window (HSCW)
        w = wm;
        for i = 1:(p-1)
            w = conv(w,wm);
        end
        M = length(w);
        ordem = M - 1;
%         wm = wm/max(wm);
        w = w/max(w);
%         figure; subplot(2,1,1); plot((0:(L-1))/(L-1),w); hold on; plot((0:(length(w2)-1))/(length(w2)-1),w2); hold off;
%         lb1 = ['Hamming M = ' num2str(M)];
%         lb2 = ['HSCW m = ' num2str(m)];
%         title('Janelas - Amostras'); legend(lb1, lb2);
        
%         W = fft(w,1024); W = W/max(W);
%         W2 = fft(w2,1024); W2 = W2/max(W2);
%         subplot(2,1,2); plot(0:1/(length(W)/2):1,20*log10(abs(W(1:((length(W)/2)+1))))); hold on; plot(0:1/(length(W2)/2):1,20*log10(abs(W2(1:((length(W2)/2)+1))))); hold off;
%         lb1 = ['Hamming M = ' num2str(M)];
%         lb2 = ['HSCW m = ' num2str(m)];
%         title('Janelas - Magnitude'); legend(lb1, lb2);
        
        q = nextpow2(M);
        N = 2^(q+3);
        L = N - M + 1;
        fc_lp = 15;
        h1 = fir1(ordem,fc_lp/(fs/2),'low',w);
        H1 = fft(h1,N);
        H2 = abs(H1);
        if size(H2,2) > 1
            H2 = H2';
        end
        fc_hp = 5;
        h3 = fir1(ordem,fc_hp/(fs/2),'high',w);
        H3 = fft(h3,N);
        H4 = abs(H3);
        if size(H4,2) > 1
            H4 = H4';
        end
        H = H2 .* H4;        

        for i = 1:length(input)
            if i ~= 14
                x = input(i).sig.signals(:,1); %original
            else
                x = input(i).sig.signals(:,2);
            end
            input(i).sig.viewer1 = x;
            L0 = size(x,1);            
            
            if rem(L0,L) == 0
                n = L0/L;
            else
                n = floor(L0/L) + 1;
            end
            y = zeros((n-1)*L + N,1);
            for j = 1:n
                if j == 1
                    a = (j-1)*L + 1;
                    b = j*L;
                    xi = [x(a:b,1); zeros((M-1),1)];
                    Xi = fft(xi,N);
                    Yi = H .* Xi;
                    yi = ifft(Yi,N);
                    y(1:N,1) = yi;
                elseif j == n
                    a = (j-1)*L+1;
                    xi = [x(a:end,1); zeros((M-1),1)];
                    xi = [xi; zeros((N - size(xi,1)),1)];
                    Xi = fft(xi,N);
                    Yi = H .* Xi;
                    yi = ifft(Yi,N);
                    c = (j-1)*L + 1;
                    d = (j-1)*L + N;
                    y(c:d,1) = y(c:d,1) + yi;
                else
                a = (j-1)*L + 1;
                b = j*L;
                xi = [x(a:b,1); zeros((M-1),1)];
                Xi = fft(xi,N);
                Yi = H .* Xi;
                yi = ifft(Yi,N);
                c = (j-1)*L + 1;
                d = (j-1)*L + N;
                y(c:d,1) = y(c:d,1) + yi;
                end               
            end
            input(i).sig.rSig = y(1:L0,1);
%             input(i).sig.viewer2 = input(i).sig.rSig;
            input(i).sig.rSig = movmean(input(i).sig.rSig,3);
            input(i).sig.viewer3 = input(i).sig.rSig;

%             input(i).sig.rSig = filter(h1,1,[zeros(M2_pad,1); input(i).sig.signals(:,d)]);
%             input(i).sig.rSig = input(i).sig.rSig(M2_pad+1:end,1);
%             input(i).sig.viewer2 = input(i).sig.rSig;
%             input(i).sig.rSig = filter(h3,1,[zeros(M2_pad,1); input(i).sig.rSig]);
%             input(i).sig.rSig = input(i).sig.rSig(M2_pad+1:end,1);
%             input(i).sig.viewer3 = input(i).sig.rSig;
        end        
        
    case '2'
        
    case '3'
        
    case '4'
        
    otherwise  
        disp('Método de entrada não reconhecido');
end

end