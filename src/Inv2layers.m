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
load net2layers;

%% simulation - do inversion
% model parameters are taken from References:
% [1] 王鹤, 蒋欢, 王亮, 席振铢, and 张道军, 2015, 大地电磁人工神经网络反演: 中南大学
% 学报 (自然科学版), 46, 1707-1714. (in Chinese)
parameters = [200 600 800;
              800 700 100;
              900 300 900;
              900 900 500;
              100 300 300;
              600 700 900;
              500 500 500;
              900 400 300;
              600 800 100;
              300 500 500];
[m,n] = size(parameters);
true_response = zeros(number_of_input, m);
for i=1:m
    rho = parameters(i,1:2);
    h = parameters(i,3);
    true_response(:,i) = MT1D(T,rho,h);
end
% [normalP,PS] = mapminmax(P,0,1);
% normalY = sim(net2layers,normalP);
% Y = mapminmax('reverse',normalY,ts);

Y = sim(net2layers,true_response);
predict_response = zeros(number_of_input, m);
for i=1:m
    rho = Y(1:2,i);
    h = Y(3,i);
    predict_response(:,i) = MT1D(T,rho',h');
end

%% plotting settings
lsize=1.5;
boxlsize=1.2;
legendsize=14;
hsize=13;
labelsize=16;
markersize=6;

%% plot true and predict models
figure('Position', [0 100 600 800]);
for i=1:m
    depth = 0:Y(3,i)+2000;
    true_rho = zeros(length(depth),1);
    true_rho(1:parameters(i,3)) = parameters(i,1);
    true_rho(parameters(i,3)+1:end) = parameters(i,2);
    pre_rho = zeros(length(depth),1);
    pre_rho(1:round(Y(3,i))) = Y(1,i);
    pre_rho(round(Y(3,i))+1:end) = Y(2,i);
    subplot(5,2,i)
    plot(depth,true_rho,'b-','linewidth',lsize);
    hold on
    plot(depth,pre_rho,'r--','linewidth',lsize);
    set(gca,'LineWidth',boxlsize,'fontsize',hsize);
    if mod(i,2)==1
        ylabel('\rho(\Omegam)');
    end
    if i==9 || i==10
        xlabel('Depth(m)');
    end
    if i==1
        h = legend('true','predict');
        set(h, 'Box', 'off','Location','SouthEast', 'fontsize', hsize);
    end
    if i==4
        ylim([850 950]);
    end
    if i==7
        ylim([450 550]);
    end
end

%% plot true and predict apparent resistivities
figure('Position', [800 100 600 800]);
for i=1:m
    subplot(5,2,i)
    semilogx(T,true_response(:,i),'bo','linewidth',lsize,'MarkerSize',markersize);
    hold on
    semilogx(T,predict_response(:,i),'r--','linewidth',lsize);
    set(gca,'LineWidth',boxlsize,'fontsize',hsize);
    %xlim([1e-3 1e3])
    grid on;
    if mod(i,2)==1
        ylabel('\rho_a(\Omegam)');
    end
    if i==9 || i==10
        xlabel('Period (seconds)');
    end
    if i==1
        h = legend('true','predict');
        set(h, 'Box', 'off','Location','SouthEast', 'fontsize', hsize);
    end
    if i==4
        ylim([850 950]);
    end
    if i==7
        ylim([450 550]);
    end
end
