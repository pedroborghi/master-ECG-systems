function [input] = beatsConn(input)

u = 3; % duração máxima em segundos da diferença aceitavel entre batimentos consecutivos
for i = 1:length(input)
    fs = input(1,i).sig.fs;
    d = round(u*fs);
    N = size(input(1,i).anotQRS.annR,1);
    ref = 1;
    input(1,i).anotQRS.ref_annR = zeros(N,1);
    input(1,i).anotQRS.ref_annR(1,1) = ref;
    
    % Label ATR
    m = 1; M = size(input(1,i).anotATR.ann,1);
    m1.indice = input(1,i).anotATR.ann(m,1);
    m1.label = cell2mat(input(1,i).anotATR.comments(m,1));
    m1.label = [m1.label blanks(5-length(m1.label))];
    if M ~= 1
        m2.indice = input(1,i).anotATR.ann(m+1,1);
        m2.label = cell2mat(input(1,i).anotATR.comments(m+1,1));
        m2.label = [m2.label blanks(5-length(m2.label))];
    else
        m2.indice = input(1,i).anotQRS.annR(end,1);
        m2.label = m1.label;
    end
    
    if m1.indice > input(1,i).anotQRS.annR(1,1)
        m1.indice = input(1,i).anotQRS.annR(1,1);
    end
    switch(m1.label)
        case '(N   '
            input(1,i).anotQRS.label_annR(1,1) = 1;
        case '(AFIB'
            input(1,i).anotQRS.label_annR(1,1) = 2;        
        otherwise
            input(1,i).anotQRS.label_annR(1,1) = 0;
    end
    
    for j = 1:(N-1)
        a = input(1,i).anotQRS.annR(j,1);
        b = input(1,i).anotQRS.annR(j+1,1);        
        if((b-a) >= d)
            ref = ref + 1;
        end
        input(1,i).anotQRS.ref_annR(j+1,1) = ref;
        
        if M == 1
            input(1,i).anotQRS.label_annR(j+1,1) = input(1,i).anotQRS.label_annR(j,1);
        elseif (b >= m2.indice)
            if m2.indice ~= m1.indice
                switch(m2.label)
                    case '(N   '
                        input(1,i).anotQRS.label_annR(j+1,1) = 1;
                    case '(AFIB'
                        input(1,i).anotQRS.label_annR(j+1,1) = 2;
                    otherwise
                        input(1,i).anotQRS.label_annR(j+1,1) = 0;
                end
                if m2.indice == input(1,i).anotATR.ann(end,1)
                    m1.indice = m2.indice;
                    m1.label = m2.label;
                else
                    m1.indice = m2.indice;
                    m1.label = m2.label;
                    m = m + 1;
                    m2.indice = input(1,i).anotATR.ann(m+1,1);
                    m2.label = cell2mat(input(1,i).anotATR.comments(m+1,1));
                    m2.label = [m2.label blanks(5-length(m2.label))];
                end
            else
                input(1,i).anotQRS.label_annR(j+1,1) = input(1,i).anotQRS.label_annR(j,1);
            end            
        else
            input(1,i).anotQRS.label_annR(j+1,1) = input(1,i).anotQRS.label_annR(j,1);
        end
    end
end
end