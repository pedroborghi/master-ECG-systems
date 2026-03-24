function [auxP, auxA] = extractPeA(input,fs)

input = detrend(input);

% input2 = abs(input);
% EN = wentropy(input2,'shannon');
% if EN >= 100 

n1 = 151/11025;
N1 = round(n1*fs);
if rem(N1,2) == 0
    N1 = N1 - 1;
end    
metodo = 'black';
out1 = func_AMD(input, N1, metodo);

% a = zscore(input);
b = zscore(out1);
% b = out1;
% [aux1, ~] = min(b);
c = b/max(b);
% c = b + abs(aux1);

% d = a.^3; % necessário?
A = 0; B = 0; ind = 0;
% [K3, ~] = max(input(:,1)); %verificar uma alternativa ao valor máximo global
for i = 2:size(c,1)    
    if (c(i,1) < c(i-1,1)) && A==0 %descida 
        if (ind ~= 0)            
            [K1, K2] = max(input(ind:i,1));
            [K3, K4] = min(input(ind:i,1));

            [K5, ~] = max(c(ind:i,1));
            if K5 >= 0.55
                B = B + 1;
                auxA1(B,1) = K1;
                auxA2(B,1) = K3;
                auxI1(B,1) = K2 + ind - 1;
                auxI2(B,1) = K4 + ind - 1;
%                 auxP(B,1) = i - ind;
            end   
        end    
        ind = i;
        A = 1;
    elseif (c(i,1) > c(i-1,1)) && A==1 %subida
        A = 0;
    end
end

v_bool(:,1) = (abs(auxA1(:,1)) > abs(auxA2(:,1)));
if sum(v_bool(:,1)) >= fix(size(v_bool,1)/2)
    auxA = auxA1;
    auxI = auxI1;
else
    auxA = auxA2;
    auxI = auxI2;
end

auxA = auxA(1:end-2,1);
auxI = auxI(1:end-2,1);
for i = 1:(size(auxI,1)-1)
    auxP(i,1) = auxI(i+1,1) - auxI(i,1);
end

t = 0:(size(c,1)-1); t = t/fs; figure; plot(t,input); hold on; grid on; plot(t,c); stem(t(auxI),auxA);

auxI = auxI/fs;
auxP = auxP/fs;
f0 = mean(auxP)^(-1);
end