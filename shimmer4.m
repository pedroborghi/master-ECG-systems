function [m] = shimmer4(m)
u = 0.001;

input_name = fieldnames(m);
input_name = input_name{2,1};

[~,S] = size(m,input_name);
for i = 1:S
    input = m.(input_name)(1,i);
    
    [N,M] = size(input.RRI.RRI_segA);
    for j = 1:M
        
        x = input.RRI.RRI_segA(:,j);
        
        s1 = 0; s2 = 0; s3 = 0; s4 = 0;
        media = mean(x);
        if (x(1,1) == 0)
            x(1,1) = rand(1)*u + (u/2);
        end
        for k = 1:(N-1)
            
            if(x(k+1,1) == 0)
                x(k+1,1) = rand(1)*u + (u/2);
            end
            s1 = s1 + abs(20*log10(abs(x(k+1,1)/x(k,1))));
            
            s2 = s2 + abs(x(k+1,1) - x(k,1));
            if ((k >= 3) && (k <= (N-2)))
                s4 = s4 + abs(x(k,1) - mean(x(k-2:k+2,1)));
            end
            if (k >= 2)
                s3 = s3 + abs(x(k,1) - mean(x(k-1:k+1,1)));               
            end           
        end
        s1 = s1/(N-1);
        s2 = (s2*100)/(media*(N-1));
        s3 = (s3*100)/(media*(N-1));
        s4 = (s4*100)/(media*(N-1));
        
        input.RRI.RRI_segS(:,j) = [s1; s2; s3; s4];
    end 
    m.(input_name)(1,i) = input;
    clear input;
end    
end