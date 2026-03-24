function [output] = machine_learning(varargin)

% VarArgIn sequence:
%   varargin{1,1} = input struct:       input(1,i).data
%                                       input(1,i).label
%   varargin{1,2} = network type:       'MLP'
%                                       'LSTM'
%                                       'GRU'
%   varargin{1,3:end} = network options:    'MLP' ->    pcTrain, [N_HL],
%                                                   {trans_Fcn}, alg_Train
%                                                   [train_ratio, val_ratio,
%                                                   test_ratio]
%                                           'LSTM' ->   pcTrain, [N_HL],
%                                                   direc

input = varargin{1,1} ;
S = size(input,2);

switch(varargin{1,2})
    case 'MLP'
        
        % Verificar parametros de proporção
%         pcTrain = 0.85;
        pcTrain = varargin{1,3};
%         pcTest = 1 - pTrain;

        treino.p = []; treino.t = [];
        teste.p = []; teste.t = [];
       
        for i = 1:S
            N = size(input(1,i).dataMLP,2);
            
            pcN_train = round(pcTrain*N);
%             pcN_test = N - pcN_train;
            
            vec = randperm(N);
            
            treino.p = [treino.p, input(1,i).dataMLP(:,vec(1:pcN_train))];
            treino.t = [treino.t, input(1,i).labelMLP(:,vec(1:pcN_train))];
            
            teste.p = [teste.p, input(1,i).dataMLP(:,vec(pcN_train+1:N))];
            teste.t = [teste.t, input(1,i).labelMLP(:,vec(pcN_train+1:N))];
            
%             for j = 1:N
%                 if j <= pcN_train
%                     treino.p = [treino.p, input(1,i).dataMLP(:,vec(j))];
%                     treino.t = [treino.t, input(1,i).labelMLP(:,vec(j))];
%                 else
%                     teste.p = [teste.p, input(1,i).dataMLP(:,vec(j))];
%                     teste.t = [teste.t, input(1,i).labelMLP(:,vec(j))];
%                 end
%             end
            
        end
        clear varargin{1,1};
        
        % Rede
%         N_HL = [165 165 165];
%         N_HL{2,1} = [180 180 180];
        N_HL = varargin{1,4};
%         trans_Fcn = {'tansig', 'tansig', 'tansig', 'tansig'};
        trans_Fcn = varargin{1,5};
%         alg_Train = 'trainrp';
        alg_Train = varargin{1,6};
        
        mlp = feedforwardnet(N_HL, alg_Train);
        mlp.numInputs = 1;
        for i = 1:length(trans_Fcn)
            %         mlp.inputs{i}.size = N_HL{j,1}(1,i);
            mlp.layers{i}.transferFcn = trans_Fcn{1,i};
        end

        mlp.trainFcn = alg_Train;
        mlp.trainParam.epochs = 1000;
        mlp.trainParam.goal = 1e-3;
        mlp.trainParam.min_grad = 1e-18;
        % mlp.trainParam.lr = 0.001;
%         mlp.trainParam.showWindow = false;
        mlp.trainParam.max_fail = 20;
        mlp.divideFcn = 'dividerand';
%         mlp.divideParam.trainRatio = 0.85;
%         mlp.divideParam.valRatio = 0.15;
%         mlp.divideParam.testRatio = 0;
        
        Ratio = varargin{1,7};        
        mlp.divideParam.trainRatio = Ratio(1);
        mlp.divideParam.valRatio = Ratio(2);
        mlp.divideParam.testRatio = Ratio(3);

        % Treino e Simulação
        [mlp, ~] = train(mlp, treino.p, treino.t, 'useParallel', 'yes', 'useGPU', 'yes');
        out1 = sim(mlp,teste.p);
        acc1 = accuracyMLP(teste.t,out1);
        
        out2 = sim(mlp,treino.p);
        acc2 = accuracyMLP(treino.t,out2);
        
        output = {mlp; acc2; acc1};
        
    case 'LSTM'
        
%         pcTrain = 0.85;
        pcTrain = varargin{1,3};
        
        treino.p = []; treino.t = [];
        teste.p = []; teste.t = [];

        for i = 1:S
            N = size(input(1,i).dataDEEP2,1);            
            pcN_train = round(pcTrain*N);
%             pcN_test = N - pcN_train;            
            vec = randperm(N);            
                          
            treino.p = [treino.p; input(1,i).dataDEEP2(vec(1:pcN_train),1)];
            treino.t = [treino.t; input(1,i).labelDEEP2(vec(1:pcN_train),1)];
            
            teste.p = [teste.p; input(1,i).dataDEEP2(vec(pcN_train+1:N),1)];
            teste.t = [teste.t; input(1,i).labelDEEP2(vec(pcN_train+1:N),1)];            
        end
        
%         N_HL = 100;
        N_HL = varargin{1,4};
        direc = varargin{1,5};
        switch(direc) 
            case 'uni'
                layers = [ ...
                    sequenceInputLayer(size(treino.p{1,1},1))
                    lstmLayer(N_HL(1,1),'OutputMode','last')
                    fullyConnectedLayer(length(categories(treino.t)))
                    softmaxLayer
                    classificationLayer
                    ];
            case 'bi'
                layers = [ ...
                    sequenceInputLayer(size(treino.p{1,1},1))
                    bilstmLayer(N_HL(1,1),'OutputMode','last')
                    fullyConnectedLayer(length(categories(treino.t)))
                    softmaxLayer
                    classificationLayer
                    ];
            otherwise
        end                
        
        options = trainingOptions('adam', ...
            'MaxEpochs',30, ...
            'MiniBatchSize', 128, ...
            'InitialLearnRate', 0.01, ...
            'SequenceLength', 'longest', ...
            'GradientThreshold', 1, ...
            'ExecutionEnvironment', "auto",...
            'plots','training-progress', ...
            'Verbose',false);
        
        [net, info] = trainNetwork(treino.p,treino.t,layers,options);
        
        % Simulação e Acurácia
        out1 = classify(net,teste.p);
        acc1 = sum(out1 == teste.t)/numel(teste.t)*100;
        
        out2 = classify(net,treino.p);
        acc2 = sum(out2 == treino.t)/numel(treino.t)*100;
        
%         output = {net; info; out2; acc2; out1; acc1};
        output = {net; acc2; acc1};
        
    case 'GRU'
        
    otherwise
        
end

end