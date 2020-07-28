% 1D layered magnetotelluric (MT) forward modeling code using 
% analytical approach, testing code

% Author:     Hongbo Yao
% Institute:  School of Geosciences and Info-Physics,
%             Central South University (CSU)
% Email:      yaohongbo@csu.edu.cn
% Date:       2020/7/28

% GitHub Page: https://github.com/hongbo-yao
% Researchgate Page: https://www.researchgate.net/profile/Hongbo_Yao2

clc,clear,close all;
lsize=1.5;   %% plotting settings
size=10;
legendsize=14;
hsize=14;
labelsize = 16;

%% two-layered Earth model
% G-type
GT = logspace(-4,4,100); 
Grho = [100,600];
Gh = 2000;
[Grhoa,Gphase] = MT1D(GT,Grho,Gh); 
% D-type
DT = logspace(-4,4,40); 
Drho = [600,100];
Dh = 2000;
[Drhoa,Dphase] = MT1D(DT,Drho,Dh); 

figure('Position', [200 100 700 600]);
subplot(2,1,1) 
semilogx(GT,Grhoa,'r-','linewidth',lsize) 
hold on
semilogx(DT,Drhoa,'b-','linewidth',lsize) 
xlabel('Period (seconds)') 
ylabel('\rho_a(\Omegam)') 
set(gca,'LineWidth', lsize,'fontsize',hsize);
% xlim([1e-4 1e4])
subplot(2,1,2) 
semilogx(GT,Gphase,'r-','linewidth',lsize) 
hold on
semilogx(DT,Dphase,'b-','linewidth',lsize) 
xlabel('Period (seconds)') 
ylabel('phase(\circ)') 
set(gca,'LineWidth', lsize, 'fontsize', hsize);
% xlim([1e-4 1e4])
h = legend('G-type','D-type');
set(h, 'Box', 'off','Location','SouthEast', 'fontsize', hsize);


%% three-layerd Earth model
%% A-type
AT = logspace(-4,4,100); 
Arho = [50 600 1000];
Ah = [1000 500];
[Arhoa,Aphase] = MT1D(AT,Arho,Ah); 
figure('Position', [400 100 800 600]);
subplot 221
Ax = 0:1000;
Ay = 0:sum(Ah)+2000;
Avalue = zeros(length(Ay),length(Ax));
Avalue(1:Ah(1),:) = Arho(1);
Avalue(Ah(1)+1:Ah(1)+Ah(2),:) = Arho(2);
Avalue(Ah(1)+Ah(2)+1:end,:) = Arho(3);
imagesc(Ax,Ay,Avalue);
colorbar;
xlabel('Distance (m)')
ylabel('Depth (m)')
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.1 0.6 0.08 0.3]);

subplot 223
plot(Avalue(:,1),Ay,'k--','linewidth',2);
set(gca,'YDir','reverse');
xlabel('Resistivity (\Omegam)')
ylabel('Depth (m)')
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.1 0.1 0.15 0.3]);

subplot 222
semilogx(AT,Arhoa,'k-','linewidth',lsize) 
xlabel('Period (seconds)') 
ylabel('\rho_a(\Omegam)') 
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.35 0.6 0.6 0.3]);

subplot 224
semilogx(AT,Aphase,'k-','linewidth',lsize) 
xlabel('Period (seconds)') 
ylabel('phase(\circ)') 
set(gca,'LineWidth', lsize, 'fontsize', hsize);
h = legend('A-type');
set(h, 'Box', 'off','Location','SouthEast', 'fontsize', hsize);
set(gca,'position',[0.35 0.1 0.6 0.3]);

%% Q-type
QT = logspace(-4,4,100); 
Qrho = [1000 600 50];
Qh = [1000 500];
[Qrhoa,Qphase] = MT1D(QT,Qrho,Qh); 
figure('Position', [400 100 800 600]);
subplot 221
Qx = 0:1000;
Qy = 0:sum(Qh)+2000;
Qvalue = zeros(length(Qy),length(Qx));
Qvalue(1:Qh(1),:) = Qrho(1);
Qvalue(Qh(1)+1:Qh(1)+Qh(2),:) = Qrho(2);
Qvalue(Qh(1)+Qh(2)+1:end,:) = Qrho(3);
imagesc(Qx,Qy,Qvalue);
colorbar;
xlabel('Distance (m)')
ylabel('Depth (m)')
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.1 0.6 0.08 0.3]);

subplot 223
plot(Qvalue(:,1),Qy,'k--','linewidth',2);
set(gca,'YDir','reverse');
xlabel('Resistivity (\Omegam)')
ylabel('Depth (m)')
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.1 0.1 0.15 0.3]);

subplot 222
semilogx(QT,Qrhoa,'k-','linewidth',lsize) 
xlabel('Period (seconds)') 
ylabel('\rho_a(\Omegam)') 
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.35 0.6 0.6 0.3]);

subplot 224
semilogx(QT,Qphase,'k-','linewidth',lsize) 
xlabel('Period (seconds)') 
ylabel('phase(\circ)') 
set(gca,'LineWidth', lsize, 'fontsize', hsize);
h = legend('Q-type');
set(h, 'Box', 'off','Location','SouthEast', 'fontsize', hsize);
set(gca,'position',[0.35 0.1 0.6 0.3]);

%% K-type
KT = logspace(-4,4,100); 
Krho = [100 1000 100];
Kh = [1000 500];
[Krhoa,Kphase] = MT1D(KT,Krho,Kh); 
figure('Position', [400 100 800 600]);
subplot 221
Kx = 0:1000;
Ky = 0:sum(Kh)+2000;
Kvalue = zeros(length(Ky),length(Kx));
Kvalue(1:Kh(1),:) = Krho(1);
Kvalue(Kh(1)+1:Kh(1)+Kh(2),:) = Krho(2);
Kvalue(Kh(1)+Kh(2)+1:end,:) = Krho(3);
imagesc(Kx,Ky,Kvalue);
colorbar;
xlabel('Distance (m)')
ylabel('Depth (m)')
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.1 0.6 0.08 0.3]);

subplot 223
plot(Kvalue(:,1),Ky,'k--','linewidth',2);
set(gca,'YDir','reverse');
xlabel('Resistivity (\Omegam)')
ylabel('Depth (m)')
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.1 0.1 0.15 0.3]);

subplot 222
semilogx(KT,Krhoa,'k-','linewidth',lsize) 
xlabel('Period (seconds)') 
ylabel('\rho_a(\Omegam)') 
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.35 0.6 0.6 0.3]);

subplot 224
semilogx(KT,Kphase,'k-','linewidth',lsize) 
xlabel('Period (seconds)') 
ylabel('phase(\circ)') 
set(gca,'LineWidth', lsize, 'fontsize', hsize);
h = legend('K-type');
set(h, 'Box', 'off','Location','SouthEast', 'fontsize', hsize);
set(gca,'position',[0.35 0.1 0.6 0.3]);

%% H-type
HT = logspace(-4,4,100); 
Hrho = [1000 100 1000];
Hh = [1000 500];
[Hrhoa,Hphase] = MT1D(HT,Hrho,Hh); 
figure('Position', [400 100 800 600]);
subplot 221
Hx = 0:1000;
Hy = 0:sum(Hh)+2000;
Hvalue = zeros(length(Hy),length(Hx));
Hvalue(1:Hh(1),:) = Hrho(1);
Hvalue(Hh(1)+1:Hh(1)+Hh(2),:) = Hrho(2);
Hvalue(Hh(1)+Hh(2)+1:end,:) = Hrho(3);
imagesc(Hx,Hy,Hvalue);
colorbar;
xlabel('Distance (m)')
ylabel('Depth (m)')
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.1 0.6 0.08 0.3]);

subplot 223
plot(Hvalue(:,1),Hy,'k--','linewidth',2);
set(gca,'YDir','reverse');
xlabel('Resistivity (\Omegam)')
ylabel('Depth (m)')
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.1 0.1 0.15 0.3]);

subplot 222
semilogx(HT,Hrhoa,'k-','linewidth',lsize) 
xlabel('Period (seconds)') 
ylabel('\rho_a(\Omegam)') 
set(gca,'LineWidth', lsize,'fontsize',hsize);
set(gca,'position',[0.35 0.6 0.6 0.3]);

subplot 224
semilogx(HT,Hphase,'k-','linewidth',lsize) 
xlabel('Period (seconds)') 
ylabel('phase(\circ)') 
set(gca,'LineWidth', lsize, 'fontsize', hsize);
h = legend('H-type');
set(h, 'Box', 'off','Location','SouthEast', 'fontsize', hsize);
set(gca,'position',[0.35 0.1 0.6 0.3]);
