function [acc] = accuracyMLP(target, output)

N = size(target,2);
% M = size(target,1);
acc = 0;

for i = 1:N
    
    [~,IDX1] = max(output(:,i));
    IDX2 = find(target(:,i) == 1);
    if IDX1 == IDX2
        acc = acc + 1;
    end
    
end

acc = (acc*100)/N;

end