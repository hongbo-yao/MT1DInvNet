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
parameters = [100 500 1000 900 500;
              200 400 900 900 500;
              1000 500 100 900 500;
              800 600 200 900 500;
              300 900 200 900 500;
              200 700 100 900 500;
              500 200 900 900 500;
              600 100 800 900 500;
              400 200 900 400 900;
              400 900 300 700 1000];
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

%% plot true and predict models
figure('Position', [0 100 600 800]);
for i=1:m
    depth = 0:Y(4,i)+Y(5,i)+2000;
    true_rho = zeros(length(depth),1);
    true_rho(1:parameters(i,4)) = parameters(i,1);
    true_rho(parameters(i,4)+1:parameters(i,4)+parameters(i,5)) = parameters(i,2);
    true_rho(parameters(i,4)+parameters(i,5)+1:end) = parameters(i,3);
    pre_rho = zeros(length(depth),1);
    pre_rho(1:round(Y(4,i))) = Y(1,i);
    pre_rho(round(Y(4,i))+1:round(Y(4,i))+round(Y(5,i))) = Y(2,i);
    pre_rho(round(Y(4,i))+round(Y(5,i))+1:end) = Y(3,i);
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
end
