function [m2] = segmentacao5(m,p,u)

% m2 = matfile('input3_2.mat','Writable',true);

% p = 60;
% u = 0.1;

if rem(p,2) ~= 0
    p = p + 1;
end
% p2 = round(p/2);
p2 = 10;

input_name = fieldnames(m);
input_name = input_name{2,1};

input = m.(input_name)(1,1);
fs = input.sig.fs;
pS = p*fs;
p2S = p2*fs;

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
    if i ~= 1
        input = m.(input_name)(1,i);
        fs = input.sig.fs;
    end
    
    clear x;
%     x = detrend(input.sig.signals(:,1));

    x(:,1) = input.sig.signals(:,1);
    x(:,2) = input.sig.signals(:,2);
    
    j = input.anotATR.ann(1,1);
    N = size(x,1) - (j-1);
    Ns = floor((N - (pS - p2S))/p2S);
    
    input.INT.INT_seg = zeros(pS,Ns,2);
    input.INT.INT_segL = zeros(3,Ns);
    input.INT.INT_segLD = zeros(1,Ns);   
    
    for k = 1:Ns
        
        a = j;
        b = j + pS - 1;
        j = j + p2S;
        
        input.INT.INT_seg(:,k,1) = x(a:b,1);
        input.INT.INT_seg(:,k,2) = x(a:b,2);
        
        clear labelAuxIDX;
        labelAuxIDX = [find(input.anotATR.ann <= a,1,'last'); find(input.anotATR.ann > a & input.anotATR.ann <= b)];
        
        if (size(labelAuxIDX,1) > 1)
            clear opS1 opS2 opS op opI;
            opL = zeros(3,1);
            for opI = 1:size(labelAuxIDX,1)-1

                opS1 = input.anotATR.ann(labelAuxIDX(opI,1),1);
                opS2 = input.anotATR.ann(labelAuxIDX(opI+1,1),1);                
                opS = opS2 - opS1;               
                op = input.anotATR.comments{labelAuxIDX(opI,1),1};
                
                switch(op)
                    case '(AFIB'
                        opL(3,1) = opL(3,1) + opS;
                    case '(N'
                        opL(2,1) = opL(2,1) + opS;
                    otherwise
                        opL(1,1) = opL(1,1) + opS;                      
                end
            end
            opL = opL/pS;
            if (opL(3,1) >= u)
                input.INT.INT_segL(:,k) = [0; 0; 1]; % 2 AF
                input.INT.INT_segLD(1,k) = 2; % 2                
            elseif (opL(2,1) >= (1-u)) 
                input.INT.INT_segL(:,k) = [0; 1; 0]; % 1 N
                input.INT.INT_segLD(1,k) = 1; % 1
            else
                input.INT.INT_segL(:,k) = [1; 0; 0]; % 0 outros
                input.INT.INT_segLD(1,k) = 0; % 0
            end
        else
            if k ~= 1
                input.INT.INT_segL(:,k) = input.INT.INT_segL(:,k-1);
                input.INT.INT_segLD(1,k) = input.INT.INT_segLD(1,k-1);
            else
                op = input.anotATR.comments{labelAuxIDX(1,1),1};
                switch(op)
                    case '(AFIB'
                        input.INT.INT_segL(:,k) = [0; 0; 1]; % 2
                        input.INT.INT_segLD(1,k) = 2; % 2
                    case '(N'
                        input.INT.INT_segL(:,k) = [0; 1; 0]; % 1
                        input.INT.INT_segLD(1,k) = 1; % 1
                    otherwise
                        input.INT.INT_segL(:,k) = [1; 0; 0]; % 0
                        input.INT.INT_segLD(1,k) = 0; % 0
                end
            end
        end
    end
    
    m2.(input_name)(1,i) = input;
%     afdb(1,i) = input;
    clear input;
end

end