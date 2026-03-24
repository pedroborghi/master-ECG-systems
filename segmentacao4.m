function [m_aux,m] = segmentacao4(m_aux,m,p,u)
% u = 0.1;
% p = 60;
if rem(p,2) ~= 0
    p = p + 1;
end
% p2 = round(p/2);
p2 = 10;

input_name = fieldnames(m_aux);
input_name = input_name{2,1};

input = m_aux.(input_name)(1,1);
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

[~,S] = size(m_aux,input_name);
for i = 1:S
    
    if i ~= 1
        input = m_aux.(input_name)(1,i);
        fs = input.sig.fs;
    end
    
%     x = detrend(input.sig.signals(:,1));
    x = filter(h_hp,1,input.sig.signals(:,1));
    
    N = size(input.anotQRS.annR,1);
    f1 = input.anotQRS.ref_annR(end,1);
    Np = (N-1) - (f1-1); % numero de periodos
    
%     Ns = ((floor(Np/p) - 1) * (p/p2) + 1) + floor(rem(Np,p)/p2);
    Ns = floor((Np - (p - p2))/p2);
    
    input.RRI.RRI_segP = zeros(p,Ns);
    input.RRI.RRI_segA = zeros(p,Ns);
    
%     for j = 1:(N-1)
    j = 1; cont_k = 0; 
    auxL = zeros(p,1);
    
    for k = 1:Ns        
        while(cont_k < p)
            a = input.anotQRS.annR(j,1);
            aR = input.anotQRS.ref_annR(j,1);
            aL = input.anotQRS.label_annR(j,1);
            b = input.anotQRS.annR(j+1,1);
            bR = input.anotQRS.ref_annR(j+1,1);
            bL = input.anotQRS.label_annR(j+1,1);
            
            if bR == aR
                cont_k = cont_k + 1;
                input.RRI.RRI_segIDX(((cont_k-1)*2)+1,k) = a;
                input.RRI.RRI_segIDX(((cont_k)*2),k) = b;
                
                input.RRI.RRI_segP(cont_k,k) = (b-a)/fs;
                input.RRI.RRI_segA(cont_k,k) = x(a,1);
                auxL(cont_k,1) = aL;
                
                EBC = extractBeatC(x(a:b,1));
                input.RRI.RRI_segWT(cont_k,k) = EBC(1);
                input.RRI.RRI_segWU(cont_k,k) = EBC(2);
                input.RRI.RRI_segWP(cont_k,k) = EBC(3);
            end
            
            j = j + 1;
            
        end
        
        if cont_k == p
            % VERIFICAR PROPORÇÃO DA LABEL DENTRO DO SEGMENTO COMPLETO
            if( (length(find(auxL == 2))) >= round(u*p) )
                input.RRI.RRI_segL(:,k) = [0;0;1];
                input.RRI.RRI_segLD(1,k) = 2;
            elseif( (length(find(auxL == 0))) >= round(0.5) ) % 0.5?
                input.RRI.RRI_segL(:,k) = [1;0;0];
                input.RRI.RRI_segLD(1,k) = 0;
            else
                input.RRI.RRI_segL(:,k) = [0;1;0];
                input.RRI.RRI_segLD(1,k) = 1;
            end
            
            if (k < Ns)
                cont_k = p - p2;
                
                input.RRI.RRI_segIDX(1:(2*cont_k),k+1) = input.RRI.RRI_segIDX((2*p2+1):2*p,k);
                input.RRI.RRI_segP(1:cont_k,k+1) = input.RRI.RRI_segP((p2+1):p,k);
                input.RRI.RRI_segA(1:cont_k,k+1) = input.RRI.RRI_segA((p2+1):p,k);
                auxL = [auxL((p2+1):p,1); zeros(p2,1)];
                
                input.RRI.RRI_segWT(1:cont_k,k+1) = input.RRI.RRI_segWT((p2+1):p,k);
                input.RRI.RRI_segWU(1:cont_k,k+1) = input.RRI.RRI_segWU((p2+1):p,k);
                input.RRI.RRI_segWP(1:cont_k,k+1) = input.RRI.RRI_segWP((p2+1):p,k);
            end
        end            
    end
    
    m.(input_name)(1,i) = input;
    clear input;
end

end