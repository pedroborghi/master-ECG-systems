function [input] = HT_MAR(input)
fs = input(1).sig.fs;
L = round((900*fs)/360);
if rem(L,2) == 0
    L = L + 1;
end
L2 = (L-1)/2;

for i = 1:length(input)
%     xr = input(i).sig.rSig(:,1);
    xi = imag(hilbert(input(i).sig.rSig(:,1)));
    N = size(xi,1);
    y = zeros(N,1);
%     input(i).sig.viewer8 = xi;


%     for j = 1:L2
%         y(j,1) = mean(xi(1:j,1));
%     end
%     for j = (L2+1):(N-L2)
%         y(j,1) = mean(xi((j-L2):(j+L2),1));
%     end
%     for j = (N-L2+1):N
%         y(j,1) = mean(xi(j:N,1));
%     end

    y = movmean(xi,L);
%     input(i).sig.viewer9 = y;
    
    input(i).sig.rSig = xi - y;
%     input(i).sig.viewer10 = input(i).sig.rSig;
end
end