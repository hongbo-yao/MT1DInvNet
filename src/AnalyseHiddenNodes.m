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
    %% Different Hidden nodes
    % 5
    net5 = feedforwardnet(5);
    net5.trainParam.epochs = 1000; % maximum training time
    net5.trainParam.goal = 5e-3; % training goal tolerance
    net5.trainParam.lr = 0.01; % learning rate
    net5.trainParam.mc = 0.9; % momentum
    net5.trainParam.show = 1; % show step
    net5.divideFcn = 'dividerand';
    net5.divideParam.trainRatio = 0.7;
    net5.divideParam.valRatio = 0.15;
    net5.divideParam.testRatio = 0.15;
    net5.trainFcn='trainlm'; 
    [net5,tr5] = train(net5,p,t);

    % 10
    net10 = feedforwardnet(10);
    net10.trainParam.epochs = 1000; % maximum training time
    net10.trainParam.goal = 5e-3; % training goal tolerance
    net10.trainParam.lr = 0.01; % learning rate
    net10.trainParam.mc = 0.9; % momentum
    net10.trainParam.show = 1; % show step
    net10.divideFcn = 'dividerand';
    net10.divideParam.trainRatio = 0.7;
    net10.divideParam.valRatio = 0.15;
    net10.divideParam.testRatio = 0.15;
    net10.trainFcn='trainlm'; 
    [net10,tr10] = train(net10,p,t);
    
    % 20
    net20 = feedforwardnet(20);
    net20.trainParam.epochs = 1000; % maximum training time
    net20.trainParam.goal = 5e-3; % training goal tolerance
    net20.trainParam.lr = 0.01; % learning rate
    net20.trainParam.mc = 0.9; % momentum
    net20.trainParam.show = 1; % show step
    net20.divideFcn = 'dividerand';
    net20.divideParam.trainRatio = 0.7;
    net20.divideParam.valRatio = 0.15;
    net20.divideParam.testRatio = 0.15;
    net20.trainFcn='trainlm'; 
    [net20,tr20] = train(net20,p,t);
    
    % 30
    net30 = feedforwardnet(30);
    net30.trainParam.epochs = 1000; % maximum training time
    net30.trainParam.goal = 5e-3; % training goal tolerance
    net30.trainParam.lr = 0.01; % learning rate
    net30.trainParam.mc = 0.9; % momentum
    net30.trainParam.show = 1; % show step
    net30.divideFcn = 'dividerand';
    net30.divideParam.trainRatio = 0.7;
    net30.divideParam.valRatio = 0.15;
    net30.divideParam.testRatio = 0.15;
    net30.trainFcn='trainlm'; 
    [net30,tr30] = train(net30,p,t);

    %% analysing training performance
    subplot(2,2,i)
    semilogy(tr5.perf,'k-','linewidth',lsize);
    hold on
    semilogy(tr10.perf,'r-','linewidth',lsize);
    hold on
    semilogy(tr20.perf,'b-','linewidth',lsize);
    hold on
    semilogy(tr30.perf,'m-','linewidth',lsize);
    xlabel('Epochs') 
    ylabel('Mean Squared Error (mse)') 
    set(gca,'LineWidth',boxlsize,'fontsize',hsize);
    if i==1
        h = legend('5 nodes','10 nodes','20 nodes','30 nodes');
        set(h, 'Box', 'on','Location','NorthEast', 'fontsize', hsize);
    end
end
