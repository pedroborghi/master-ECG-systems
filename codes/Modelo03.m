% Pedro Henrique Borghi de Melo

% Modelo 03 - Algoritmo para o mestrado

% Main

% %% --- PART 2 - R-peak detection + beats connectivity
% disp('Part 2 - Beginning');
% clear all;
% close all;
% % clc;
% % Carregar sinal de entrada
% tic; disp('Carregamento do sinal...');
% load('input.mat'); toc;
% 
% %--- R-PEAK DETECTION
% % Band-Pass Filtering
% tic; disp('BF Filtering...');
% [afdb] = BP_filtR(afdb,'1'); toc;
% % First-Order Forward Differencing
% tic; disp('Differencing...');
% [afdb] = FO_diffR(afdb,'1'); toc;
% % Normalization
% tic; disp('Normalization...');
% [afdb] = normR(afdb,'1'); toc;
% % Shannon Energy
% tic; disp('Shannon Energy...');
% [afdb] = shannon_energyR(afdb); toc;
% % Zero-Phase Filtering
% tic; disp('Zero-Phase Filtering...');
% [afdb] = ZP_filtR(afdb); toc;
% % Hilbert Transform + Moving Average
% tic; disp('Hilbert Transform + Moving Average...');
% [afdb] = HT_MAR(afdb); toc;
% % Positive Zero Crossing Point
% tic; disp('Positive Zero Crossing Point...');
% [afdb] = zero_crossR(afdb); toc;
% % Real Peak Detection
% tic; disp('Real Peak Detection...');
% [afdb] = realPeakR(afdb,'1'); toc;
% % Evaluation
% tic; disp('Evaluation...');
% [afdb, output] = performR(afdb); 
% output
% toc;
% % Referencing Beats Connectivity
% tic; disp('Beats Connection...');
% [afdb] = beatsConn(afdb); toc;
% % Save Progress
% tic; disp('Saving Progress...');
% % load('input2.mat');
% save('input2.mat','afdb','-v7.3'); toc;
% % clear all;

% %% --- PART 3 - Segmentation + feature extraction + normalization
% disp('Part 3 - Beginning');
% close all;
% clear all;
% % clc;
% % Load Matfile
% tic; disp('Loading "input2.mat" file...');
% m_aux = matfile('input2.mat','Writable',false); toc;
% tic; disp('Loading "input3.mat" file...');
% m = matfile('input3.mat','Writable',true); toc;

% % Segmentation
% tic; disp('Segmentation...');
% % [m.afdb] = segmentacao3(m.afdb,60,0.1); toc;
% [~,~] = segmentacao4(m_aux,m,60,0.1); toc;

% % Jitter
% tic; disp('Jitter...');
% [~] = jitter4(m); toc;

% % Shimmer
% tic; disp('Shimmer...');
% [~] = shimmer4(m); toc;

% % Entropies
% tic; disp('Shannon and Log Energy Entropy...');
% [~] = entropia3(m); toc;

% % Segmentation 2
% tic; disp('Segmentation 2...');
% [m2] = segmentacao5(m,60,0.1); toc;

% % Time-Frequency Features
% clear all;
% tic; disp('Time Frequency Features...');
% m = matfile('input3_2.mat','Writable',true); % temporário
% [~] = TF_features(m,{'waveletScatt';'instFreq';'specEntropy'}); toc;

% % Normalize
% tic; disp('Normalizing data...');
% [~] = normalizacao2(m); toc;

% % Save Progress
% tic; disp('Saving Progress...');
% % load('input3.mat');
% save('input3_2.mat','afdb','-v7.3'); toc;


% % --- PART 4 - Organize data + ML progress
% disp('Part 4 - Beginning');
% % close all;
% clear all;

% Organize
tic; disp('Organizing...');
% m = matfile('input3.mat');
m = matfile('input3_2.mat'); % temporário
[~] = seiri_suru(m); toc; % temp

% % Save data organized
% tic; disp('Saving Organized data...');
% save('ML_input_file2.mat','ML_input_file','-v7.3'); toc; %n utilizar pois já está sendo salvo auto

% Machine Learning
close all;
clear all;
tic; disp('Running Machine Learning...');
load('ML_input_file2.mat');
m_out = matfile('ML_reports.mat','Writable',true);


%% MLP

% for i = 1:size(ML_input_file,2)
%     INPUT(1,i).dataMLP = ML_input_file(1,i).dataMLP;
%     INPUT(1,i).labelMLP = ML_input_file(1,i).labelMLP;
% end
% clear ML_input_file;
% 
% out_ML_MLP(:,1) = {'RRI'; 'Label Prop(u)'; 'Features'; 'Version'; 'pcTrain'; 'NET'; 'accTrain'; 'accTest'; 'bestAccTest'}; 
% 
% vec_features = {'RRI';'waveEnt-T';'waveEnt-U';'waveEnt-P';'Jitter1';'Jitter2-4';'Shimmer1';'Shimmer2-4';'EntropyS';'EntropyLE';'WaveletScat'};
% vec_N = [60 1 1 1 1 3 1 3 2 2];
% 
% pcTrain = 0.85;
% alg_Train = 'trainrp';
% train_ratio = 0.85;
% val_ratio = 0.15;
% test_ratio = 0;
% 
% c2 = 2; % fase 2
% 
% switch(c2)
%     case 2
%         c1 = 1;
%         
%         auxMLP = m_out.MLP;
%         bestNet_aux = cell2mat(auxMLP(8:9,2:end));
%         [max_amp,max_idx] = maxk(bestNet_aux(2,:),5);
%         for i = 1:5
%             [max_amp(1,i),aux] = max(bestNet_aux(1,(max_idx(1,i) - 2):max_idx(1,i)));
%             max_idx(1,i) = max_idx(1,i) - 3 + aux;
%         end
%         max_idx = max_idx + 1;
%         bestNet = auxMLP(:,max_idx);
%         clear auxMLP;
%         
%         for N = (size(vec_features,1)-2):-1:1
%             for M = 1:size(INPUT,2)
%                 INPUT(1,M).dataMLP = INPUT(1,M).dataMLP(1:sum(vec_N(1,1:N)),:);
%             end
%             
%             for a = 1:size(bestNet,2)
%                 clear N_HL;
%                 clear trans_Fcn;
%                 for b = 1:size(bestNet{6,a}.layers,1)
%                     if b < size(bestNet{6,a}.layers,1)
%                         N_HL(1,b) = bestNet{6,a}.layers{b,1}.size;
%                     end
%                     trans_Fcn{1,b} = bestNet{6,a}.layers{b,1}.transferFcn;
%                 end
%                 
%                 F = zeros(3,1);
%                 for f = 1:3
%                     [output] = machine_learning(INPUT,'MLP',pcTrain,N_HL,trans_Fcn,alg_Train,[train_ratio, val_ratio, test_ratio]);
%                     c1 = c1 + 1;
%                     out_ML_MLP(:,c1) = { 60; 0.10; vec_features(1:N,1); f; pcTrain; output{1,1}; output{2,1}; output{3,1}; 0 };
%                     F(f,1) = output{end,1};
%                     if f == 3
%                         out_ML_MLP{end,c1} = max(F);
%                         F = zeros(3,1);
%                     end
%                 end
%                 m_out.MLP2 = out_ML_MLP;
%             end
%         end
%     case 1        
%         out_ML_MLP = m_out.MLP;
%         c1 = size(out_ML_MLP,2);
%         for N = (size(vec_features,1)-1)
%             
%             for M = 1:size(INPUT,2)
%                 INPUT(1,M).dataMLP = INPUT(1,M).dataMLP(1:sum(vec_N(1,1:N)),:);
%             end
%             
%             vec_HL = 15:10:205;
%             vec_TF = {'logsig', 'tansig'};
%             for a = 3
%                 N_HL = zeros(1,a);
%                 for b = 1:length(vec_HL)
%                     for c = 1:a
%                         N_HL(1,c) = vec_HL(1,b);
%                     end
%                     for d = 1:length(vec_TF)
%                         clear trans_Fcn;
%                         for e = 1:a+1
%                             trans_Fcn{1,e} = vec_TF{1,d};
%                         end
%                         F = zeros(3,1);
%                         for f = 1:3
%                             [output] = machine_learning(INPUT,'MLP',pcTrain,N_HL,trans_Fcn,alg_Train,[train_ratio, val_ratio, test_ratio]);
%                             c1 = c1 + 1;
%                             out_ML_MLP(:,c1) = { 60; 0.10; vec_features(1:N,1); f; pcTrain; output{1,1}; output{2,1}; output{3,1}; 0 };
%                             F(f,1) = output{end,1};
%                             if f == 3
%                                 out_ML_MLP{end,c1} = max(F);
%                                 F = zeros(3,1);
%                             end
%                         end
%                         m_out.MLP = out_ML_MLP;
%                     end
%                 end
%             end
%         end
%     otherwise
% end
% toc;

% [out_ML_MLP] = machine_learning(ML_input_file,'MLP',0.85,[165 165 165],{'tansig', 'tansig', 'tansig', 'tansig'},'trainrp',[0.85 0.15 0]);

%% LSTM

% for i = 1:size(ML_input_file,2) % temp
%     INPUT(1,i).dataDEEP2 = ML_input_file(1,i).dataDEEP2;
%     INPUT(1,i).labelDEEP2 = ML_input_file(1,i).labelDEEP2;
% end
% clear ML_input_file;

out_ML_LSTM(:,1) = {'Window'; 'Label Prop(u)'; 'Features'; 'Version'; 'pcTrain'; 'NET'; 'accTrain'; 'accTest'; 'bestAccTest'}; 

vec_features = {'RRI';'waveEnt-T';'waveEnt-U';'waveEnt-P';'Jitter1';'Jitter2-4';'Shimmer1';'Shimmer2-4';'EntropyS';'EntropyLE';'WaveletScat';'instFreq';'specEntropy';'raw'};
vec_N = [60 1 1 1 1 3 1 3 2 2];

pcTrain = 0.85;
N_HL = [100];
f = {'uni'; 'bi'};

c1 = 1;
c2 = 5;

switch(c2)
    case 1
        N = 10;
        for a = 1:size(N_HL,2)
            for b = 1:size(f,1)
                
                [output] = machine_learning(INPUT,'LSTM',pcTrain,N_HL(1,a),f{b,1});
                c1 = c1 + 1;
                out_ML_LSTM(:,c1) = { 60; 0.10; vec_features(1:N,1); [f{b,1} ' LSTM']; pcTrain; output{1,1}; output{2,1}; output{3,1}; 0 };
                
                m_out.LSTM = out_ML_LSTM;
            end
        end
        LSTM = out_ML_LSTM;
        save('ML_reports2.mat', 'LSTM', '-append');
        toc;

    case 2        
        N = 4;
        for M = 1:size(INPUT,2)
            for O = 1:size(INPUT(1,M).dataDEEP,1)
                INPUT(1,M).dataDEEP{O,1} = INPUT(1,M).dataDEEP{O,1}(1:N,:);
            end
        end
        for a = 1:size(N_HL,2)
            for b = 1:size(f,1)
                
                [output] = machine_learning(INPUT,'LSTM',pcTrain,N_HL(1,a),f{b,1});
                c1 = c1 + 1;
                out_ML_LSTM(:,c1) = { 60; 0.10; vec_features(1:N,1); [f{b,1} ' LSTM']; pcTrain; output{1,1}; output{2,1}; output{3,1}; 0 };
                
                m_out.LSTM2 = out_ML_LSTM;
            end
        end
        
        LSTM2 = out_ML_LSTM;
        save('ML_reports2.mat', 'LSTM2', '-append');
        toc;
    case 3
        for c = 1:2
            if c == 1
                N = [1 4];
            else
                N = 1;
            end
        for M = 1:size(INPUT,2)
            for O = 1:size(INPUT(1,M).dataDEEP,1)
                INPUT(1,M).dataDEEP{O,1} = INPUT(1,M).dataDEEP{O,1}(N,:);
            end
        end
        for a = 1:size(N_HL,2)
            for b = 1:size(f,1)
                
                [output] = machine_learning(INPUT,'LSTM',pcTrain,N_HL(1,a),f{b,1});
                c1 = c1 + 1;
                out_ML_LSTM(:,c1) = { 60; 0.10; vec_features(N,1); [f{b,1} ' LSTM']; pcTrain; output{1,1}; output{2,1}; output{3,1}; 0 };
                
                m_out.LSTM3 = out_ML_LSTM;
            end
        end
        
        end
        
        LSTM3 = out_ML_LSTM;
        save('ML_reports2.mat', 'LSTM3', '-append');
        toc;
    case 4        
        for a = 1:size(N_HL,2)
            for b = 1:size(f,1)
                
                [output] = machine_learning(ML_input_file,'LSTM',pcTrain,N_HL(1,a),f{b,1});
                c1 = c1 + 1;
                out_ML_LSTM(:,c1) = { 60; 0.10; vec_features(11,1); [f{b,1} ' LSTM']; pcTrain; output{1,1}; output{2,1}; output{3,1}; 0 };
                
                m_out.LSTM4 = out_ML_LSTM;
            end
        end
        
        LSTM4 = out_ML_LSTM;
        save('ML_reports.mat', 'LSTM4', '-append');
        toc;
        case 5            
            for a = 1:size(N_HL,2)
                for b = 1:size(f,1)
                    
                    [output] = machine_learning(ML_input_file,'LSTM',pcTrain,N_HL(1,a),f{b,1});
                    c1 = c1 + 1;
                    out_ML_LSTM(:,c1) = { 60; 0.10; vec_features(end,1); [f{b,1} ' LSTM']; pcTrain; output{1,1}; output{2,1}; output{3,1}; 0 };
                    
                    m_out.LSTM5 = out_ML_LSTM;
                end
            end
            
            LSTM5 = out_ML_LSTM;
            save('ML_reports_sec.mat', 'LSTM5');
            toc;
    otherwise
end

% [out_ML_LSTM] = machine_learning(ML_input_file,'LSTM',0.85,[100]);

%% Save?
% % Save ML reports
% tic; disp('Saving ML Reports...');
% save('ML_reports.mat','out_ML_MLP','-v7.3'); 
% % save('ML_retorts.mat','out_ML_LSTM','-v7.3');
% toc;