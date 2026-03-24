function [m] = jitter4(m)

input_name = fieldnames(m);
input_name = input_name{2,1};

[~,S] = size(m,input_name);
for i = 1:S
    input = m.(input_name)(1,i);
    
    [N,M] = size(input.RRI.RRI_segP);
    for j = 1:M
        
        x = input.RRI.RRI_segP(:,j);
        
        j1 = 0; j2 = 0; j3 = 0; j4 = 0;
        media = mean(x);
        for k = 1:(N-1)
           
            j1 = j1 + abs(x(k+1,1) - x(k,1));
            if ((k >= 3) && (k <= (N-2)))
                j4 = j4 + abs(x(k,1) - mean(x(k-2:k+2,1)));
            end
            if (k >= 2)
                j3 = j3 + abs(x(k,1) - mean(x(k-1:k+1,1)));               
            end           
        end
        j1 = j1/(N-1);
        j2 = (j1*100)/media;
        j3 = (j3*100)/(media*(N-1));
        j4 = (j4*100)/(media*(N-1));
        
        input.RRI.RRI_segJ(:,j) = [j1; j2; j3; j4];        
    end
    m.(input_name)(1,i) = input;
    clear input;
end    
end