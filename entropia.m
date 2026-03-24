%% Intro
% Pedro Henrique Borghi de Melo

% Funções de cálculo de entropia
% Descrição...

function [x] = entropia(input,x)

S = size(x,2);
fs = 250;

for i = 1:S
    N = size(input(i).RRI.RRI30,2);
    for j = 1:N
        x(i).entropias.pentr(:,j,1) = pentropy(input(i).RRI.RRI30(:,j,1),fs);
        x(i).entropias.pentr(:,j,2) = pentropy(input(i).RRI.RRI30(:,j,2),fs);
        x(i).entropias.shannon(:,j,1) = wentropy(input(i).RRI.RRI30(:,j,1),'shannon');
        x(i).entropias.shannon(:,j,2) = wentropy(input(i).RRI.RRI30(:,j,2),'shannon');
        x(i).entropias.logen(:,j,1) = wentropy(input(i).RRI.RRI30(:,j,1),'log energy');
        x(i).entropias.logen(:,j,2) = wentropy(input(i).RRI.RRI30(:,j,2),'log energy');
        x(i).instFreq.instFreq(:,j,1) = instfreq(input(i).RRI.RRI30(:,j,1),fs);
        x(i).instFreq.instFreq(:,j,2) = instfreq(input(i).RRI.RRI30(:,j,2),fs);
    end
end
end