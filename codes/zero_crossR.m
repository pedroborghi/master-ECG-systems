function [input] = zero_crossR(input)

for i = 1:length(input)
    x = input(i).sig.rSig;
    N = size(x,1);
    k = 0;
    ind = [];
    
    for j = 1:N-1
        if ((x(j,1) < 0) && (x(j+1,1) >= 0))  
            k = k + 1;
            ind(k,1) = j+1;            
        end
    end    
    input(i).anotQRS.annR = ind;
%     input(i).sig.viewer11 = ind;
end
end