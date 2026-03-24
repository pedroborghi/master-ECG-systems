function [m] = TF_features(m,vFeatures)

input_name = fieldnames(m);
input_name = input_name{2,1};

N = size(vFeatures,1);

[~,S] = size(m,input_name);
% [~,S] = size(afdb);
for i = 1:S
    input = m.(input_name)(1,i);
%     input = afdb(1,i);
    fs = input.sig.fs;
    [A,B,C] = size(input.INT.INT_seg);
    for j = 1:N
        
        switch(vFeatures{j,1})
            case 'waveletScatt'
                sf = waveletScattering('SignalLength',A,'SamplingFrequency',fs,'InvarianceScale',0.5,'QualityFactors',[8 1]);
%                 round(A/(fs*2))
%                 for k = 1:B
                    for h = 1:C
                        vScat = featureMatrix(sf,input.INT.INT_seg(:,:,h),'Transform','none','Normalization','none');
                        input.INT.INT_segTF_WS(:,:,:,h) = vScat;
                    end
%                 end
            case 'instFreq'
%                 for k = 1:B
                    for h = 1:C
                        vInstFreq = instfreq(input.INT.INT_seg(:,:,h),fs);
                        input.INT.INT_segTF_IF(:,:,h) = vInstFreq;
                    end
%                 end
            case 'specEntropy'
                for k = 1:B
                    for h = 1:C
                        vSpecEnt = pentropy(input.INT.INT_seg(:,k,h),fs);
                        input.INT.INT_segTF_SE(:,k,h) = vSpecEnt;
                    end
                end
            otherwise                
        end            
        
    end
    m.(input_name)(1,i) = input;
%     afdb(1,i) = input;
    clear input;
end

end