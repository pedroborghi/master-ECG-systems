function [output] = extractBeatC(input)

% Waves:T    U    P
pP = [0.15 0.45 0.70;...
      0.50 0.65 0.92];
L = size(input,1);
pS = round(pP*L);

output = zeros(1,3);
% realizar interpolação?
r = 2;
input = interp(input,r);
pS = ((pS - 1)*r) + 1;

for i = 1:3
    output(1,i) = wentropy(input(pS(1,i):pS(2,i),1),'shannon');
end

% output(1,1) = wentropy(input,'shannon');
% output(1,2) = wentropy(input,'shannon');
% output(1,3) = wentropy(input,'shannon');

end