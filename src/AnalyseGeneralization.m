% 1D magnetotelluric (MT) Neural Network inversion

% Author:     Hongbo Yao
% Institute:  School of Geosciences and Info-Physics,
%             Central South University (CSU)
% Email:      yaohongbo@csu.edu.cn
% Date:       2020/7/28

% GitHub Page: https://github.com/hongbo-yao
% Researchgate Page: https://www.researchgate.net/profile/Hongbo_Yao2

clc,clear,close all;

%% load trained net
load net3layers;

%% simulation - do inversion
parameters = [100 500 1200 900 500;     % A-type
              1200 500 100 1000 500;    % Q-type
              50 500 100 600 500;       % K-type
              1200 50 1200 1000 500;    % H-type
              500 500 900 1000 500;     % two layered G-type
              800 800 400 1000 500];    % two layered D-type
[m,n] = size(parameters);
true_response = zeros(number_of_input, m);
for i=1:m
    rho = parameters(i,1:3);
    h = parameters(i,4:5);
    true_response(:,i) = MT1D(T,rho,h);
end
% [normalP,PS] = mapminmax(P,0,1);
% normalY = sim(net2layers,normalP);
% Y = mapminmax('reverse',normalY,ts);

Y = sim(net3layers,true_response);
predict_response = zeros(number_of_input, m);
for i=1:m
    rho = Y(1:3,i);
    h = Y(4:5,i);
    predict_response(:,i) = MT1D(T,rho',h');
end

%% plotting settings
lsize=1.5;
boxlsize=1.2;
legendsize=14;
hsize=13;
labelsize=16;
markersize=6;

%% A-type
figure('Position', [0 100 500 600]);
i=1;
depth = 0:Y(4,i)+Y(5,i)+2000;
true_rho = zeros(length(depth),1);
true_rho(1:parameters(i,4)) = parameters(i,1);
true_rho(parameters(i,4)+1:parameters(i,4)+parameters(i,5)) = parameters(i,2);
true_rho(parameters(i,4)+parameters(i,5)+1:end) = parameters(i,3);
pre_rho = zeros(length(depth),1);
pre_rho(1:round(Y(4,i))) = Y(1,i);
pre_rho(round(Y(4,i))+1:round(Y(4,i))+round(Y(5,i))) = Y(2,i);
pre_rho(round(Y(4,i))+round(Y(5,i))+1:end) = Y(3,i);
subplot(2,1,1)
plot(depth,true_rho,'b-','linewidth',lsize);
hold on
plot(depth,pre_rho,'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho(\Omegam)');
xlabel('Depth(m)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);
title('A-type')

subplot(2,1,2)
semilogx(T,true_response(:,i),'bo','linewidth',lsize,'MarkerSize',markersize);
hold on
semilogx(T,predict_response(:,i),'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho_a(\Omegam)');
xlabel('Period (seconds)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);

%% Q-type
figure('Position', [200 100 500 600]);
i=2;
depth = 0:Y(4,i)+Y(5,i)+2000;
true_rho = zeros(length(depth),1);
true_rho(1:parameters(i,4)) = parameters(i,1);
true_rho(parameters(i,4)+1:parameters(i,4)+parameters(i,5)) = parameters(i,2);
true_rho(parameters(i,4)+parameters(i,5)+1:end) = parameters(i,3);
pre_rho = zeros(length(depth),1);
pre_rho(1:round(Y(4,i))) = Y(1,i);
pre_rho(round(Y(4,i))+1:round(Y(4,i))+round(Y(5,i))) = Y(2,i);
pre_rho(round(Y(4,i))+round(Y(5,i))+1:end) = Y(3,i);
subplot(2,1,1)
plot(depth,true_rho,'b-','linewidth',lsize);
hold on
plot(depth,pre_rho,'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho(\Omegam)');
xlabel('Depth(m)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);
title('Q-type')

subplot(2,1,2)
semilogx(T,true_response(:,i),'bo','linewidth',lsize,'MarkerSize',markersize);
hold on
semilogx(T,predict_response(:,i),'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho_a(\Omegam)');
xlabel('Period (seconds)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);

%% K-type
figure('Position', [300 100 500 600]);
i=3;
depth = 0:Y(4,i)+Y(5,i)+2000;
true_rho = zeros(length(depth),1);
true_rho(1:parameters(i,4)) = parameters(i,1);
true_rho(parameters(i,4)+1:parameters(i,4)+parameters(i,5)) = parameters(i,2);
true_rho(parameters(i,4)+parameters(i,5)+1:end) = parameters(i,3);
pre_rho = zeros(length(depth),1);
pre_rho(1:round(Y(4,i))) = Y(1,i);
pre_rho(round(Y(4,i))+1:round(Y(4,i))+round(Y(5,i))) = Y(2,i);
pre_rho(round(Y(4,i))+round(Y(5,i))+1:end) = Y(3,i);
subplot(2,1,1)
plot(depth,true_rho,'b-','linewidth',lsize);
hold on
plot(depth,pre_rho,'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho(\Omegam)');
xlabel('Depth(m)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);
title('K-type')

subplot(2,1,2)
semilogx(T,true_response(:,i),'bo','linewidth',lsize,'MarkerSize',markersize);
hold on
semilogx(T,predict_response(:,i),'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho_a(\Omegam)');
xlabel('Period (seconds)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);

%% K-type
figure('Position', [400 100 500 600]);
i=4;
depth = 0:Y(4,i)+Y(5,i)+2000;
true_rho = zeros(length(depth),1);
true_rho(1:parameters(i,4)) = parameters(i,1);
true_rho(parameters(i,4)+1:parameters(i,4)+parameters(i,5)) = parameters(i,2);
true_rho(parameters(i,4)+parameters(i,5)+1:end) = parameters(i,3);
pre_rho = zeros(length(depth),1);
pre_rho(1:round(Y(4,i))) = Y(1,i);
pre_rho(round(Y(4,i))+1:round(Y(4,i))+round(Y(5,i))) = Y(2,i);
pre_rho(round(Y(4,i))+round(Y(5,i))+1:end) = Y(3,i);
subplot(2,1,1)
plot(depth,true_rho,'b-','linewidth',lsize);
hold on
plot(depth,pre_rho,'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho(\Omegam)');
xlabel('Depth(m)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);
title('H-type')

subplot(2,1,2)
semilogx(T,true_response(:,i),'bo','linewidth',lsize,'MarkerSize',markersize);
hold on
semilogx(T,predict_response(:,i),'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho_a(\Omegam)');
xlabel('Period (seconds)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);

%% two layered G-type
figure('Position', [500 100 500 600]);
i=5;
depth = 0:Y(4,i)+Y(5,i)+2000;
true_rho = zeros(length(depth),1);
true_rho(1:parameters(i,4)) = parameters(i,1);
true_rho(parameters(i,4)+1:parameters(i,4)+parameters(i,5)) = parameters(i,2);
true_rho(parameters(i,4)+parameters(i,5)+1:end) = parameters(i,3);
pre_rho = zeros(length(depth),1);
pre_rho(1:round(Y(4,i))) = Y(1,i);
pre_rho(round(Y(4,i))+1:round(Y(4,i))+round(Y(5,i))) = Y(2,i);
pre_rho(round(Y(4,i))+round(Y(5,i))+1:end) = Y(3,i);
subplot(2,1,1)
plot(depth,true_rho,'b-','linewidth',lsize);
hold on
plot(depth,pre_rho,'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho(\Omegam)');
xlabel('Depth(m)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);
title('Two-layered G-type')

subplot(2,1,2)
semilogx(T,true_response(:,i),'bo','linewidth',lsize,'MarkerSize',markersize);
hold on
semilogx(T,predict_response(:,i),'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho_a(\Omegam)');
xlabel('Period (seconds)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);

%% two layered D-type
figure('Position', [600 100 500 600]);
i=6;
depth = 0:Y(4,i)+Y(5,i)+2000;
true_rho = zeros(length(depth),1);
true_rho(1:parameters(i,4)) = parameters(i,1);
true_rho(parameters(i,4)+1:parameters(i,4)+parameters(i,5)) = parameters(i,2);
true_rho(parameters(i,4)+parameters(i,5)+1:end) = parameters(i,3);
pre_rho = zeros(length(depth),1);
pre_rho(1:round(Y(4,i))) = Y(1,i);
pre_rho(round(Y(4,i))+1:round(Y(4,i))+round(Y(5,i))) = Y(2,i);
pre_rho(round(Y(4,i))+round(Y(5,i))+1:end) = Y(3,i);
subplot(2,1,1)
plot(depth,true_rho,'b-','linewidth',lsize);
hold on
plot(depth,pre_rho,'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho(\Omegam)');
xlabel('Depth(m)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);
title('Two-layered D-type')

subplot(2,1,2)
semilogx(T,true_response(:,i),'bo','linewidth',lsize,'MarkerSize',markersize);
hold on
semilogx(T,predict_response(:,i),'r--','linewidth',lsize);
set(gca,'LineWidth',boxlsize,'fontsize',hsize);
ylabel('\rho_a(\Omegam)');
xlabel('Period (seconds)');
h = legend('true','predict');
set(h, 'Box', 'off','Location','Best', 'fontsize', hsize);
