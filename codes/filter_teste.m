% Filter Test

close all;
clear all;
clc;

load('signal1.mat');
L0 = length(y);

Mm = 100; % ordem da janela de Hamming (deve ser par)
Lm = Mm + 1; % número de coeficientes
wm = hamming(Lm); % criação da janela de hamming

p = 4; % número de convoluções para Hamming Self-Convolution Window (HSCW)
w = wm; % inicialização da HSCW
for i = 1:(p-1)
    w = conv(w,wm);
end
L1 = length(w); % número de coeficientes da HSCW
M1 = L1 - 1; % ordem HSCW
wm = wm/max(wm); % normalização da janela de hamming
w = w/max(w); % normalização da HSCW
%         figure; subplot(2,1,1); plot((0:(L-1))/(L-1),w); hold on; plot((0:(length(w2)-1))/(length(w2)-1),w2); hold off;
%         lb1 = ['Hamming M = ' num2str(M)];
%         lb2 = ['HSCW m = ' num2str(m)];
%         title('Janelas - Amostras'); legend(lb1, lb2);

% Resposta em Magnitude das janelas
%         W = fft(w,1024); W = W/max(W);
%         W2 = fft(w2,1024); W2 = W2/max(W2);
%         subplot(2,1,2); plot(0:1/(length(W)/2):1,20*log10(abs(W(1:((length(W)/2)+1))))); hold on; plot(0:1/(length(W2)/2):1,20*log10(abs(W2(1:((length(W2)/2)+1))))); hold off;
%         lb1 = ['Hamming M = ' num2str(M)];
%         lb2 = ['HSCW m = ' num2str(m)];
%         title('Janelas - Magnitude'); legend(lb1, lb2);

% Criação dos Filtros
fs = 250;
n = nextpow2(L0+L1-1); 
fc_lp = 15; % frequência de corte filtro passa baixas
h1 = fir1(M1,fc_lp/(fs/2),'low',w); % resposta ao impulso do filtro passa baixas
H1 = fft(h1,2^n); % resposta em frequência do filtro passa baixas
% H_lp = H_lp/max(H_lp); % normalização
figure; subplot 211; plot(20*log10(abs(H1))); grid on; subplot 212; plot(angle(H1)); grid on;

fc_hp = 5; % frequência de corte filtro passa altas
h3 = fir1(M1,fc_hp/(fs/2),'high',w); % resposta ao impulso do filtro passa altas
H3 = fft(h3,2^n); % resposta em frequência do filtro passa altas
% H_hp = H_hp/max(H_hp); % normalização
figure; subplot 211; plot(20*log10(abs(H3))); grid on; subplot 212; plot(angle(H3)); grid on;

% Filtros para correção de fase
theta1 = angle(H1); % determinação da fase do filtro passa baixas
theta2 = -theta1; % inverso da fase
r = 1;  % amplitude
H2 = r*cos(theta2) + 1i*r*sin(theta2); % determinação da resposta em frequência ideal para correção
figure; subplot 211; plot(20*log10(abs(H2))); ylim([-10 10]); grid on; subplot 212; plot(angle(H2)); grid on;
% h2 = ifft(H2,L1); % resposta ao impulso do filtro corretor de fase
H12 = abs(H1);
figure; subplot 221; plot(20*log10(abs(H1).*abs(H2))); grid on; subplot 223; plot(angle(H1)+angle(H2)); grid on; ylim([-pi pi]);
        subplot 222; plot(20*log10(abs(H12))); grid on; subplot 224; plot(angle(H12)); grid on; ylim([-pi pi]);
% h12 = ifft(H12,L1);

theta3 = angle(H3);
theta4 = -theta3;
r = 1;
H4 = r*cos(theta4) + 1i*r*sin(theta4);
figure; subplot 211; plot(20*log10(abs(H4))); ylim([-10 10]); grid on; subplot 212; plot(angle(H4)); grid on;
H34 = abs(H3);
figure; subplot 221; plot(20*log10(abs(H3).*abs(H4))); grid on; subplot 223; plot(angle(H3)+angle(H4)); grid on; ylim([-pi pi]);
        subplot 222; plot(20*log10(abs(H34))); grid on; subplot 224; plot(angle(H34)); grid on; ylim([-pi pi]);

% Filtragem do sinal de entrada

% ABORDAGEM 01 - LP FILTER + PHASE CORRETOR 1 + HP FILTER + PHASE CORRETOR 2
% SISTEMA 1 = FILTRO PASSA BAIXAS
% a1 = filter(h1,1,y);  % filtragem passa baixas
% A1 = fft(a1); % espectro do sinal após filtragem
% SISTEMA 2 - FILTRO CORRETOR DE FASE 1
% A2 = H2' .* A1; % realização da filtragem
% a2 = ifft(A2,length(y)); % sinal filtrado no tempo
% SISTEMA 3 - FILTRO PASSA ALTAS
% a3 = filter(h_hp,1,a2);
% SISTEMA 4 - FILTRO CORRETOR DE FASE 2

% ABORDAGEM 02 - MULTIPLICAÇÃO NA FREQUÊNCIA
Y = fft(y,2^n);
if size(Y,2) > 1
    Y = Y';
end
if size(H12,2) > 1
    H12 = H12';
end
if size(H34,2) > 1
    H34 = H34';
end
A2 = Y .* H12;
a2 = ifft(A2,2^n);
A4 = A2 .* H34;
a4 = ifft(A4,2^n);

% Apresentação dos sinais
a = 10001;
b = 20000;
n2 = nextpow2(b-a+1);
y_aux = y(a:b,1);
a2_aux = a2(a:b,1);
a4_aux = a4(a:b,1);
figure; plot(a:b,y_aux); hold on; grid on; plot(a:b,a2_aux);
% figure; plot(a:b,y(a:b,1)); hold on; grid on; plot(a:b,a2(a+M2_pad:b+M2_pad,1));
% figure; plot(a:b,y_aux); hold on; grid on; plot(a:b,real(a2_aux));
% figure; subplot 211; plot(angle(A1(1:(30*n/(fs/2)),1))); subplot 212; plot(angle(A2(1:(30*n/(fs/2)),1)));
Y_aux = fft(y_aux,2^n2);
A2_aux = fft(a2_aux,2^n2);
A4_aux = fft(a4_aux,2^n2);
figure; subplot 221; plot(20*log10(abs(Y_aux(1:end/2,1)))); grid on; subplot 223; plot(angle(Y_aux(1:end/2,1))); grid on; ylim([-pi pi]);
        subplot 222; plot(20*log10(abs(A2_aux(1:end/2,1)))); grid on; subplot 224; plot(angle(A2_aux(1:end/2,1))); grid on; ylim([-pi pi]);
% figure; plot(angle(Y_aux) - angle(A2_aux)); grid on;
figure; plot(a:b,y_aux); hold on; grid on; plot(a:b,a4_aux);
figure; subplot 221; plot(20*log10(abs(Y_aux(1:end/2,1)))); grid on; subplot 223; plot(angle(Y_aux(1:end/2,1))); grid on; ylim([-pi pi]);
        subplot 222; plot(20*log10(abs(A4_aux(1:end/2,1)))); grid on; subplot 224; plot(angle(A4_aux(1:end/2,1))); grid on; ylim([-pi pi]);