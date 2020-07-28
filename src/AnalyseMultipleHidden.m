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
    %% Different Hidden layers
    % 1 hidden layer
    net1 = feedforwardnet(10);
    net1.trainParam.epochs = 1000; % maximum training time
    net1.trainParam.goal = 5e-3; % training goal tolerance
    net1.trainParam.lr = 0.01; % learning rate
    net1.trainParam.mc = 0.9; % momentum
    net1.trainParam.show = 1; % show step
    net1.divideFcn = 'dividerand';
    net1.divideParam.trainRatio = 0.7;
    net1.divideParam.valRatio = 0.15;
    net1.divideParam.testRatio = 0.15;
    net1.trainFcn='trainlm'; 
    [net1,tr1] = train(net1,p,t);

    % 2 hidden layers
    net2 = feedforwardnet([10,10]);
    net2.trainParam.epochs = 1000; % maximum training time
    net2.trainParam.goal = 5e-3; % training goal tolerance
    net2.trainParam.lr = 0.01; % learning rate
    net2.trainParam.mc = 0.9; % momentum
    net2.trainParam.show = 1; % show step
    net2.divideFcn = 'dividerand';
    net2.divideParam.trainRatio = 0.7;
    net2.divideParam.valRatio = 0.15;
    net2.divideParam.testRatio = 0.15;
    net2.trainFcn='trainlm'; 
    [net2,tr2] = train(net2,p,t);
    
    % 3 hidden layers
    net3 = feedforwardnet([10,10,10]);
    net3.trainParam.epochs = 1000; % maximum training time
    net3.trainParam.goal = 5e-3; % training goal tolerance
    net3.trainParam.lr = 0.01; % learning rate
    net3.trainParam.mc = 0.9; % momentum
    net3.trainParam.show = 1; % show step
    net3.divideFcn = 'dividerand';
    net3.divideParam.trainRatio = 0.7;
    net3.divideParam.valRatio = 0.15;
    net3.divideParam.testRatio = 0.15;
    net3.trainFcn='trainlm'; 
    [net3,tr3] = train(net3,p,t);
    
    % 30
    net4 = feedforwardnet([10,10,10,10]);
    net4.trainParam.epochs = 1000; % maximum training time
    net4.trainParam.goal = 5e-3; % training goal tolerance
    net4.trainParam.lr = 0.01; % learning rate
    net4.trainParam.mc = 0.9; % momentum
    net4.trainParam.show = 1; % show step
    net4.divideFcn = 'dividerand';
    net4.divideParam.trainRatio = 0.7;
    net4.divideParam.valRatio = 0.15;
    net4.divideParam.testRatio = 0.15;
    net4.trainFcn='trainlm'; 
    [net4,tr4] = train(net4,p,t);

    %% analysing training performance
    subplot(2,2,i)
    semilogy(tr1.perf,'k-','linewidth',lsize);
    hold on
    semilogy(tr2.perf,'r-','linewidth',lsize);
    hold on
    semilogy(tr3.perf,'b-','linewidth',lsize);
    hold on
    semilogy(tr4.perf,'m-','linewidth',lsize);
    xlabel('Epochs') 
    ylabel('Mean Squared Error (mse)') 
    set(gca,'LineWidth',boxlsize,'fontsize',hsize);
    if i==1
        h = legend('1 hidden layer','2 hidden layers','3 hidden layers','4 hidden layers');
        set(h, 'Box', 'on','Location','NorthEast', 'fontsize', hsize);
    end
end
