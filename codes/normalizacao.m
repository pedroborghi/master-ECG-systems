%% Intro
% Pedro Henrique Borghi de Melo

% Funções normalização
% Descrição...

function [input] = normalizacao(input, sel)

switch sel
    case 1 % z-score normalization
        for i = 1:size(input,2)
            input(i).RRI.RRI = zscore(input(i).RRI.RRI);
            input(i).RRI.RRI30 = zscore(input(i).RRI.RRI30);
%             output(i).RRI.RRI50 = zscore(input(i).RRI.RRI50);
%             output(i).RRI.RRI100 = zscore(input(i).RRI.RRI100);
            
%             input(i).AMP.AMP30(:,:,1) = zscore(input(i).AMP.AMP30(:,:,1));
%             input(i).AMP.AMP30(:,:,2) = zscore(input(i).AMP.AMP30(:,:,2));
            input(i).jitter.jitterA30(1,:) = zscore(input(i).jitter.jitterA30(1,:));
            input(i).jitter.jitterL30(1,:) = zscore(input(i).jitter.jitterL30(1,:));
            input(i).jitter.jitterRAP30(1,:) = zscore(input(i).jitter.jitterRAP30(1,:));
            input(i).jitter.jitterPPQ530(1,:) = zscore(input(i).jitter.jitterPPQ530(1,:));
            input(i).shimmer.shdb(1,:,1) = zscore(input(i).shimmer.shdb(1,:,1));
            input(i).shimmer.shdb(1,:,2) = zscore(input(i).shimmer.shdb(1,:,2));
            input(i).shimmer.shim(1,:,1) = zscore(input(i).shimmer.shim(1,:,1));
            input(i).shimmer.shim(1,:,2) = zscore(input(i).shimmer.shim(1,:,2));
            input(i).shimmer.apq3(1,:,1) = zscore(input(i).shimmer.apq3(1,:,1));
            input(i).shimmer.apq3(1,:,2) = zscore(input(i).shimmer.apq3(1,:,2));
            input(i).shimmer.apq5(1,:,1) = zscore(input(i).shimmer.apq5(1,:,1));
            input(i).shimmer.apq5(1,:,2) = zscore(input(i).shimmer.apq5(1,:,2));
            
            input(i).entropias.pentr(:,:,1) = zscore(input(i).entropias.pentr(:,:,1),0,'all');
            input(i).entropias.pentr(:,:,2) = zscore(input(i).entropias.pentr(:,:,2),0,'all');
            input(i).entropias.shannon(1,:,1) = zscore(input(i).entropias.shannon(1,:,1));
            input(i).entropias.shannon(1,:,2) = zscore(input(i).entropias.shannon(1,:,2));
            input(i).entropias.logen(1,:,1) = zscore(input(i).entropias.logen(1,:,1));
            input(i).entropias.logen(1,:,2) = zscore(input(i).entropias.logen(1,:,2));
            input(i).instFreq.instFreq(:,:,1) = zscore(input(i).instFreq.instFreq(:,:,1),0,'all');
            input(i).instFreq.instFreq(:,:,2) = zscore(input(i).instFreq.instFreq(:,:,2),0,'all');
        end
    case 2 % teorema de tales
    otherwise
end

end