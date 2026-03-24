%% Intro
% Pedro Henrique Borghi de Melo

% Funções de cálculo de entropia2
% Descrição...

function [x] = entropia2(input,x)

S = size(x,2);
fs = 250;

for i = 1:S
    b_mean(1,i) = mean(x(1,i).RRI.length(1,:));
end
a_mean = round(mean(b_mean(1,:)));
clear b_min;

for i = 1:S
    N = size(x(i).RRI.length,2);
    for j = 1:N
        if j < N
            k1 = x(i).RRI.length(2,j);
        else
            k1 = x(i).RRI.length(2,j) - abs(x(1,i).RRI.length(1,end) - a_mean);
        end
        a1 = input(i).sig.signals(k1:k1+a_mean,1);
        a2 = input(i).sig.signals(k1:k1+a_mean,2);
        x(i).entropias.pentr(:,j,1) = pentropy(a1,fs);
        x(i).entropias.pentr(:,j,2) = pentropy(a2,fs);
        x(i).entropias.shannon(:,j,1) = wentropy(a1,'shannon');
        x(i).entropias.shannon(:,j,2) = wentropy(a2,'shannon');
        x(i).entropias.logen(:,j,1) = wentropy(a1,'log energy');
        x(i).entropias.logen(:,j,2) = wentropy(a2,'log energy');
        x(i).instFreq.instFreq(:,j,1) = instfreq(a1,fs);
        x(i).instFreq.instFreq(:,j,2) = instfreq(a2,fs);
    end
end
end