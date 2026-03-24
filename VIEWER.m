% VIEWER

clear all;
close all;
clc;

m = matfile('VIEWER.mat');

a = 500001;
b = 503000;
i = 18;
x = m.afdb(1,i);

x0 = x.sig.viewer1;
x1 = x.sig.viewer1(a:b,1);
x2 = x.sig.viewer2(a:b,1);
x3 = x.sig.viewer3(a:b,1);
x4 = x.sig.viewer4(a:b,1);
x5 = x.sig.viewer5(a:b,1);
x6 = x.sig.viewer6(a:b,1);
x7 = x.sig.viewer7(a:b,1);
x8 = x.sig.viewer8(a:b,1);
x9 = x.sig.viewer9(a:b,1);
x10 = x.sig.viewer10(a:b,1);
x11 = x.sig.viewer11;
x12 = x.sig.viewer12;
x13 = x.anotQRS.ann;

figure; plot(a:b,x1); hold on; grid on; plot(a:b,x2); title('Original, BPF'); legend('Original', 'BPF');
figure; plot(a:b,x2); hold on; grid on; plot(a:b,x3); title('BPF, BPF+MA(3)'); legend('BPF','BPF+MA(3)');
figure; plot(a:b,x1); hold on; grid on; plot(a:b,x3); plot(a+1:b+1,x4); title('Original, BPF, Diff'); legend('Original', 'BPF', 'Diff');
figure; plot(a:b,x1); hold on; grid on; plot(a+1:b+1,x4); plot(a+1:b+1,x5); title('Original , Diff, Norm'); legend('Original', 'Diff', 'Norm');
figure; plot(a+1:b+1,x5); hold on; grid on; plot(a+1:b+1,x6); plot(a+1:b+1,x7); title('Norm, Shannon Energy, ZPF'); legend('Norm', 'Shannon Energy', 'ZPF');
figure; plot(a+1:b+1,x8); hold on; grid on; plot(a+1:b+1,x9); plot(a+1:b+1,x10); title('Hilbert, MA, Hilbert-MA'); legend('Hilbert', 'MA', 'Hilbert - MA');

y1 = zeros(b-a+1,1);
yi1 = find((x11>=a & x11<=b));
ind = x11(yi1,1)-a+1;
y1(ind,1) = x1(ind,1);

y2 = zeros(b-a+1,1);
yi2 = find((x12>=a & x12<=b));
ind = x12(yi2,1)-a+1;
y2(ind,1) = x1(ind,1);

y3 = zeros(b-a+1,1);
yi3 = find((x13>=a & x13<=b));
ind = x13(yi3,1)-a+1;
y3(ind,1) = x1(ind,1);
figure; plot(a:b,x1/max(abs(x1))); hold on; grid on; plot(a+1:b+1,x10/max(abs(x10))); plot(a+1:b+1,x3/max(abs(x3))); stem(a:b,y1/max(abs(x1))); stem(a:b,y2/max(abs(x1))); stem(a:b,y3/max(abs(x1))); title('Original, Hilbert-MA, BPF, ZCP, Real R, Ann'); legend('Original', 'Hilbert-MA', 'BPF', 'ZCP', 'Real R', 'Ann');

figure; t = a:b; plot(a:b,x1/max(abs(x1))); hold on; grid on; plot(a+1:b+1,x10/max(abs(x10))); plot(a+1:b+1,x3/max(abs(x3))); plot(a+1:b+1,x7/max(abs(x7))); ix = (y1~=0); stem(t(ix),y1(ix)/max(abs(x1))); ix = (y2~=0); stem(t(ix),y2(ix)/max(abs(x1))); ix = (y3~=0); stem(t(ix),y3(ix)/max(abs(x1))); title('Original, BPF, Shannon Energy, Hilbert-MA, ZCP, Real R, Ann'); legend('Original', 'Hilbert-MA', 'BPF', 'ShannonEn', 'ZCP', 'Real R', 'Ann');

figure; t = a:b; plot(x0/max(abs(x0))); xlim([a b]); grid on; title('Episódio AF');

% x2 = afdb(i).sig.rSig(a+1:b+1,1);
% y1 = zeros(size(x1,1),1);
% y2 = y1;
% yi1 = find((afdb(1).anotQRS.ann>=a & afdb(1).anotQRS.ann<=b));
% ind = afdb(1).anotQRS.ann(yi1,1)-a+1;
% y1(ind,1) = afdb(1).sig.signals(yi1,1);
% yi2 = find((afdb(1).anotQRS.annR>=a & afdb(1).anotQRS.annR<=b));
% ind = afdb(1).anotQRS.annR(yi2,1)-a+1;
% y2(ind,1) = afdb(1).sig.signals(yi2,1);
% close all;
% figure; plot(a:b,x1/(max(abs(x1)))); hold on; plot(a:b,x2/max(abs(x2))); stem(a:b,y1/max(abs(y1))); stem(a:b,y2/max(abs(y2)));