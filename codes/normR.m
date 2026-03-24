function [input] = normR(input,metodo)

switch(metodo)
    case '1'
        for i = 1:length(input)
            input(i).sig.rSig(:,1) = input(i).sig.rSig(:,1)/max(abs(input(i).sig.rSig(:,1)));
%             input(i).sig.viewer5 = input(i).sig.rSig;
        end
    case '2'
        for i = 1:length(input)
            input(i).sig.rSig = zscore(input(i).sig.rSig);
%             input(i).sig.viewer5 = input(i).sig.rSig;
        end        
    otherwise
        disp('Método de entrada não reconhecido');
end

end