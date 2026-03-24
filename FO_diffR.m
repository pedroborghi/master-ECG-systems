function [input] = FO_diffR(input,metodo)

switch(metodo)
    case '1'        
        for i = 1:length(input)
            input(i).sig.rSig = diff(input(i).sig.rSig(:,1));
%             input(i).sig.viewer4 = input(i).sig.rSig;
        end
        
    case '2'
        
    otherwise
        disp('Método de entrada não reconhecido');
        
end