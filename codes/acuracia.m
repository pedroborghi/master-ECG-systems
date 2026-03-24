function [acc] = acuracia(tg, out)
S = size(out,2);
acc = 0; % Inicia a variável que armazena a acurácia
[~, out2] = min(abs(1-out)); % Retorna o índice do neurônio mais provável
[~, tg2] = min(abs(1-tg));
for i=1:S
    if (out2(1,i)==tg2(1,i))
        acc = acc + 1; % incrementa a variável se o conteúdo do vetor é igual ao índice
    end
end
acc = (acc./S)*100; % cálculo percentual da acurácia
end