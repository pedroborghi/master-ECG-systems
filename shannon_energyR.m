function [input] = shannon_energyR(input)
u = 0.001;

for i = 1:length(input)
    d2(:,1) = input(i).sig.rSig(:,1) .^ 2;
    for j = 1:size(input(i).sig.rSig,1)
        if d2(j,1) == 0
            d2(j,1) = (rand(1)*u - (u/2))^2;
%             input(i).sig.rSig(j,1) = 0;
        end
        input(i).sig.rSig(j,1) = (- d2(j,1) * log10(d2(j,1)));
    end
%     input(i).sig.viewer6 = input(i).sig.rSig;
    clear d2;
end

end
       
    