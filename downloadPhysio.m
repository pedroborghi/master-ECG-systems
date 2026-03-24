% Pedro Henrique Borghi de Melo

% Teste visualização das bases de dados e uso das funções da toolbox WFDB
% da PhysioNet

%% Inicialização
clc;
clear all;
close all;

%% Main

% Rotina para aquisição dos dados
names = ['04015'; '04043'; '04048'; '04126'; '04746'; '04908'; 
    '04936'; '05091'; '05121'; '05261'; '06426'; '06453'; '06995';
    '07162'; '07859'; '07879'; '07910'; '08215'; '08219'; '08378';
    '08405'; '08434'; '08455'];
for i = 1:length(names)
    afdb(i).name = names(i,:);
    afdb(i).name_path = ['afdb/' afdb(i).name];
    [afdb(i).sig.signals, afdb(i).sig.fs, ~] = rdsamp(afdb(i).name_path);
    [afdb(i).anotATR.ann, afdb(i).anotATR.anntype, afdb(i).anotATR.subtype, afdb(i).anotATR.chan, afdb(i).anotATR.num, afdb(i).anotATR.comments] = rdann(afdb(i).name_path, 'atr');
    [afdb(i).anotQRS.ann, afdb(i).anotQRS.anntype, afdb(i).anotQRS.subtype, afdb(i).anotQRS.chan, afdb(i).anotQRS.num, afdb(i).anotQRS.comments] = rdann(afdb(i).name_path, 'qrs');
end

save('input.mat','afdb','-v7.3');

%% Rotina para verificação de inconsistencia dos dados
% wfdb2mat('afdb/04015')
% tic;[tm,signal,Fs,siginfo]=rdmat('04015m');toc
% tic;[signal2]=rdsamp('04015m');toc
% if(sum(abs(signal-signal2)) ~=0)
%     error('Record not compatible with RDMAT');
% end



