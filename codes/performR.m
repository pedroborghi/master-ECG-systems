    function [input,output] = performR(input)
fs = input(1).sig.fs;
N = round(0.075*fs);

TP_t = 0;
FP_t = 0;
FN_t = 0;
n1_t = 0;
n2_t = 0;

for i = 1:length(input)
    ind1 = input(i).anotQRS.ann;
    ind2 = input(i).anotQRS.annR;
    n1 = size(ind1,1);
    n2 = size(ind2,1);
    
    TP = 0;
    FP = 0;
%     TN = 0;
    FN = 0;
    
    for j = 1:n1
%         if (((ind1(j,1)-N) >= 1) && ((ind1(j,1)+N) <= size()))
        aux = find((ind2 >= (ind1(j,1)-N)) & (ind2 <= (ind1(j,1)+N)));
        if isempty(aux)
            FN = FN + 1;            
        else
            TP = TP + 1;
        end            
    end
    FP = n2 - TP;
    ACC = TP/n1;
    Sen = TP/(TP+FN);
    PP = TP/(TP+FP);
    Err = (FP+FN)/n2;
    
    input(i).anotQRS.performRdetec.TP = TP;
    input(i).anotQRS.performRdetec.FP = FP;
    input(i).anotQRS.performRdetec.FN = FN;
    input(i).anotQRS.performRdetec.ACC = ACC;
    input(i).anotQRS.performRdetec.Sen = Sen;
    input(i).anotQRS.performRdetec.PP = PP;
    input(i).anotQRS.performRdetec.Err = Err;
    input(i).anotQRS.performRdetec.n1 = n1;
    input(i).anotQRS.performRdetec.n2 = n2;
    
    TP_t = TP_t + TP;
    FP_t = FP_t + FP;
    FN_t = FN_t + FN;
    n1_t = n1_t + n1;
    n2_t = n2_t + n2;   
end

ACC_t = TP_t/n1_t;
Sen_t = TP_t/(TP_t+FN_t);
PP_t = TP_t/(TP_t+FP_t);
Err_t = (FP_t+FN_t)/n2_t;

output = {'Accuracy', ACC_t; 'Sensitivity', Sen_t; 'Positive Predictivity', PP_t; 'Error Rate', Err_t};

end