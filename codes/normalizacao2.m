function [m] = normalizacao2(m)

input_name = fieldnames(m);
input_name = input_name{2,1};

[~,S] = size(m,input_name);
for i = 1:S
    
    input = m.(input_name)(1,i);
    
%     input.RRI.RRI_segP = normalize(input.RRI.RRI_segP,1,'range');
%     
%     input.RRI.RRI_segWT = input.RRI.RRI_segWT/(max(abs(input.RRI.RRI_segWT),[],'all'));
%     input.RRI.RRI_segWU = input.RRI.RRI_segWU/(max(abs(input.RRI.RRI_segWU),[],'all'));
%     input.RRI.RRI_segWP = input.RRI.RRI_segWP/(max(abs(input.RRI.RRI_segWP),[],'all'));
%     
%     input.RRI.RRI_segJ(1,:) = normalize(input.RRI.RRI_segJ(1,:),2,'range');
%     input.RRI.RRI_segJ(2:4,:) = input.RRI.RRI_segJ(2:4,:)/100;
% %     input.RRI.RRI_segJ(3,:) = input.RRI.RRI_segJ(3,:)/100;
% %     input.RRI.RRI_segJ(4,:) = input.RRI.RRI_segJ(4,:)/100;
%     
%     input.RRI.RRI_segS(1,:) = normalize(input.RRI.RRI_segS(1,:),2,'range');
%     input.RRI.RRI_segS(2:4,:) = input.RRI.RRI_segS(2:4,:)/100;
% %     input.RRI.RRI_segS(3,:) = input.RRI.RRI_segS(3,:)/100;
% %     input.RRI.RRI_segS(4,:) = input.RRI.RRI_segS(4,:)/100;
% 
%     input.RRI.RRI_segE = normalize(input.RRI.RRI_segE,1,'range');

    input.INT.INT_segTF_WS = zscore(input.INT.INT_segTF_WS,0,[1,2]);
    input.INT.INT_segTF_IF = zscore(input.INT.INT_segTF_IF,0,1);
    input.INT.INT_segTF_SE = zscore(input.INT.INT_segTF_SE,0,1);
    
    m.(input_name)(1,i) = input;
    clear input;
end

end