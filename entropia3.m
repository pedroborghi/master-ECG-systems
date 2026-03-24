function [m] = entropia3(m)

input_name = fieldnames(m);
input_name = input_name{2,1};

input = m.(input_name)(1,1);

fs = input.sig.fs;
wm = hamming(61);
w = wm;
for i = 1:3
    w = conv(w,wm);
end
w = w/max(w);
fc = 5;
h_hp = fir1(length(w)-1,fc/(fs/2),'high',w);
% fc = 100;
% h_lp = fir1(length(w)-1,fc/(fs/2),'low',w);

[~,S] = size(m,input_name);
for i = 1:S

    input = m.(input_name)(1,i);
    
    x1 = filter(h_hp,1,input.sig.signals(:,1));
    x2 = filter(h_hp,1,input.sig.signals(:,2));
    
    [N,M] = size(input.RRI.RRI_segIDX);
    for j = 1:M
        y1 = []; y2 = [];
        for k = 1:2:N
            y1 = [y1; x1(input.RRI.RRI_segIDX(k,j):(input.RRI.RRI_segIDX(k+1,j)-1),1)];
            y2 = [y2; x2(input.RRI.RRI_segIDX(k,j):(input.RRI.RRI_segIDX(k+1,j)-1),1)];
        end
        input.RRI.RRI_segE(1,j) = wentropy(y1,'shannon');
        input.RRI.RRI_segE(2,j) = wentropy(y2,'shannon');
        input.RRI.RRI_segE(3,j) = wentropy(y1,'log energy');
        input.RRI.RRI_segE(4,j) = wentropy(y2,'log energy');
    end
    m.(input_name)(1,i) = input;
    clear input;
end  
        
end