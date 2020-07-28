% 1D magnetotelluric (MT) Neural Network inversion

% Author:     Hongbo Yao
% Institute:  School of Geosciences and Info-Physics,
%             Central South University (CSU)
% Email:      yaohongbo@csu.edu.cn
% Date:       2020/7/28

% GitHub Page: https://github.com/hongbo-yao
% Researchgate Page: https://www.researchgate.net/profile/Hongbo_Yao2

% Training parameters:
% frequencies: 20, 1000-0.001Hz
% periods: 20, 0.001-1000s
% number of input nodes: 20
% number of output nodes: 3 (rho1, rho2, h1)

clc,clear,close all;
T = logspace(-3,3,20); % period 
rho1 = linspace(100,1000,10);
rho2 = linspace(100,1000,10);
h1 = linspace(100,1000,10);
n = length(rho1)*length(rho2)*length(h1);
number_of_input = 20;
number_of_output = 3;
p0 = zeros(number_of_input, n); % each column represents an input
t0 = zeros(number_of_output, n);% each column represents an output

%% generate input and output data
ii = 1;
for i=1:length(rho1)
    for j=1:length(rho2)
        for k=1:length(h1)
            t0(1,ii) = rho1(i);
            t0(2,ii) = rho2(j);
            t0(3,ii) = h1(k);
            ii = ii+1;
        end
    end
end
for ii=1:n
    rho = t0(1:2,ii);
    h = t0(3,ii);
    [rhoa,phase] = MT1D(T,rho',h');
    p0(:,ii) = rhoa;
end

%% data normalization using mapminmax
[p,ps] = mapminmax(p0,0,1);
[t,ts] = mapminmax(t0,0,1);

%% analyse
lsize=1.5;   %% plotting settings
boxlsize=1.2;
legendsize=14;
hsize=14;
labelsize = 16;
figure('Position', [200 100 800 650]);

%% we do four times running
for i=1:4
    %% net parameters
    net = feedforwardnet(10);
    % view(net2layers)
    net.trainParam.epochs = 1000; % maximum training time
    net.trainParam.goal = 5e-3; % training goal tolerance
    net.trainParam.lr = 0.01; % learning rate
    net.trainParam.mc = 0.9; % momentum
    net.trainParam.show = 1; % show step

    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 0.7;
    net.divideParam.valRatio = 0.15;
    net.divideParam.testRatio = 0.15;

    %% Different BP algorithms
    % Levenberg-Marquardt Algorithm
    net.trainFcn='trainlm'; 
    [netlm,trlm] = train(net,p,t);

    % RPROP Algorithm
    net.trainFcn='trainrp'; 
    [netrp,trrp] = train(net,p,t);

    % Quasi-Newton Algorithm
    net.trainFcn = 'trainbfg';
    [netfg,trfg] = train(net,p,t);

    %% analysing training performance
    subplot(2,2,i)
    semilogy(trlm.perf,'k-','linewidth',lsize);
    hold on
    semilogy(trrp.perf,'r-','linewidth',lsize);
    hold on
    semilogy(trfg.perf,'b-','linewidth',lsize);
    xlabel('Epochs') 
    ylabel('Mean Squared Error (mse)') 
    set(gca,'LineWidth',boxlsize,'fontsize',hsize);
    if i==1
        h = legend('Levenberg-Marquardt','RPROP','Quasi-Newton');
        set(h, 'Box', 'on','Location','NorthEast', 'fontsize', hsize);
    end
end
