function input = fix_NaN(input)

for i = 1:length(input)
    k = 0;
    vec = isnan(input(i).sig.signals(:,1));
    for j = 1:size(vec,1)
        if vec(j,1) == 1
            input(i).sig.signals(j,1) = 0;
            k = k + 1;
        end
    end
end

end