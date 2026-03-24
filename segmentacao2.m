function [input] = segmentacao2(input,p,u)
% u = 0.1;
% p = 60;
if rem(p,2) ~= 0
    p = p + 1;
end
% p2 = round(p/2);
p2 = 10;

fs = input(1,1).sig.fs;

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

for i = 1:length(input)
    
    fs = input(1,i).sig.fs;
    N = size(input(1,i).anotQRS.annR,1);
    
%     x = detrend(input(1,i).sig.signals(:,1));
    x = filter(h_hp,1,input(1,i).sig.signals(:,1));
    
    f1 = input(1,i).anotQRS.ref_annR(end,1);
    Np = (N-1) - (f1-1); % numero de periodos
    
%     Ns = floor(Np/p); % numero de segmentos
    Ns = ((floor(Np/p) - 1) * (p/p2) + 1) + floor(rem(Np,p)/p2);
    
    input(1,i).RRI.RRI_segP = zeros(p,Ns);
    input(1,i).RRI.RRI_segA = zeros(p,Ns);
    
%     for j = 1:(N-1)
    j = 1; k = 1; cont_k = 0; ch_cont = 0;
    while((j<=(N-1)) && (k<=Ns))    
        a = input(1,i).anotQRS.annR(j,1);
        aR = input(1,i).anotQRS.ref_annR(j,1);
        aL = input(1,i).anotQRS.label_annR(j,1);
        b = input(1,i).anotQRS.annR(j+1,1);
        bR = input(1,i).anotQRS.ref_annR(j+1,1);
        bL = input(1,i).anotQRS.label_annR(j+1,1);
        
        if bR == aR

%             input(1,i).RRI.RRI_allS(j,1) = (b-a);
            input(1,i).RRI.RRI_allT(j,1) = (b-a)/fs;
            input(1,i).AMP.R_peak(j,1) = x(a,1);
            input(1,i).RRI.RRI_allL(j,1) = aL;
            
            % Extrair parametros RRI; DESENHAR ABORDAGEM
            EBC = extractBeatC(x);
%             E = length(EBC);
%             input(1,i).RRI.RRI_EBC(j,:) = EBC;
            
%             input(1,i).RRI.RRI_segWT(j,1) = EBC(1);
%             input(1,i).RRI.RRI_segWU(j,1) = EBC(2);
%             input(1,i).RRI.RRI_segWP(j,1) = EBC(3);
            
            cont_k = cont_k + 1;
%             if (ch == 1)
            ch_cont = ch_cont + 1;
            input(1,i).RRI.RRI_segIDX(ch_cont,k) = a;
            ch_cont = ch_cont + 1;
            input(1,i).RRI.RRI_segIDX(ch_cont,k) = b;
%                 ch = 2;
%             end

            input(1,i).RRI.RRI_segP(cont_k,k) = input(1,i).RRI.RRI_allT(j,1);
            input(1,i).RRI.RRI_segA(cont_k,k) = input(1,i).AMP.R_peak(j,1);
            input(1,i).RRI.RRI_segL1(cont_k,k) = input(1,i).RRI.RRI_allL(j,1);
%             input(1,i).RRI.RRI_segEBC(((cont_k - 1)*E + 1):(cont_k*E),k) = EBC';
            input(1,i).RRI.RRI_segWT(cont_k,k) = EBC(1);
            input(1,i).RRI.RRI_segWU(cont_k,k) = EBC(2);
            input(1,i).RRI.RRI_segWP(cont_k,k) = EBC(3);
%         else
%             if (ch == 2)
%                 ch_cont = ch_cont + 1;
%                 input(1,i).RRI.RRI_segIDX(ch_cont,k) = a;
%                 ch = 1;
%             end
        end
        
        if cont_k >= p
            % VERIFICAR PROPORÇÃO DA LABEL DENTRO DO SEGMENTO COMPLETO
            if((length(find((input(1,i).RRI.RRI_segL1(:,k)) == 2))) >= round(u*p))               
                input(1,i).RRI.RRI_segL(:,k) = [0;0;1];
                input(1,i).RRI.RRI_segLD(1,k) = 2;
            elseif((length(find((input(1,i).RRI.RRI_segL1(:,k)) == 0))) >= round(0.5)) % 0.5?
                input(1,i).RRI.RRI_segL(:,k) = [1;0;0];
                input(1,i).RRI.RRI_segLD(1,k) = 0;
            else
                input(1,i).RRI.RRI_segL(:,k) = [0;1;0];
                input(1,i).RRI.RRI_segLD(1,k) = 1;
            end
            
            if (((j+1) <= (N-1)) && ((k+1) <= Ns))
                k = k + 1;
                cont_k = p - p2;
                ch_cont = (2*cont_k);
                input(1,i).RRI.RRI_segIDX(1:(2*cont_k),k) = input(1,i).RRI.RRI_segIDX((2*p2+1):end,k-1);
                input(1,i).RRI.RRI_segP(1:cont_k,k) = input(1,i).RRI.RRI_segP((p2+1):end,k-1);
                input(1,i).RRI.RRI_segA(1:cont_k,k) = input(1,i).RRI.RRI_segA((p2+1):end,k-1);
                input(1,i).RRI.RRI_segL1(1:cont_k,k) = input(1,i).RRI.RRI_segL1((p2+1):end,k-1);
%                 input(1,i).RRI.RRI_segEBC(1:(cont_k*E),k) = input(1,i).RRI.RRI_segEBC((p2*E + 1):end,k-1);
                input(1,i).RRI.RRI_segWT(1:cont_k,k) = input(1,i).RRI.RRI_segWT((p2+1):end,k-1);
                input(1,i).RRI.RRI_segWU(1:cont_k,k) = input(1,i).RRI.RRI_segWU((p2+1):end,k-1);
                input(1,i).RRI.RRI_segWP(1:cont_k,k) = input(1,i).RRI.RRI_segWP((p2+1):end,k-1);
            end
        end
        j = j + 1;
    end
    
end

end