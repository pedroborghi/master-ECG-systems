function [input] = ZP_filtR(input)
fs = input(1).sig.fs;
M = round((55*fs)/360);
if rem(M,2) == 0
    M = M+1;
end
% M2 = (M-1)/2;

for i = 1:length(input)
    x = input(i).sig.rSig;    
    N = size(x,1);
    y = zeros(N,1);
    for k = 1:2        
        if k == 1
            y = movmean(x,M);
        else
            x = flip(y);
            y = movmean(x,M);
            y = flip(y);
        end
        
%         for j = 1:M2
%             y(j,1) = mean(x(1:j,1));
%         end        
%         for j = (M2+1):(N-M2)
%             y(j,1) = mean(x((j-M2):(j+M2),1));
%         end        
%         for j = (N-M2+1):N
%             y(j,1) = mean(x(j:N,1));
%         end   
    end
    input(i).sig.rSig = y;
%     input(i).sig.viewer7 = input(i).sig.rSig;
end

end