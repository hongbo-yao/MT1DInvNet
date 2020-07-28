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
tic
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
% [p,ps] = mapminmax(p0,0,1);
% [t,ts] = mapminmax(t0,0,1);
p = p0;
t = t0;

%% build net
net2layers = feedforwardnet(20);

%% training BP algorithm
net2layers.trainFcn='trainlm'; % Levenberg-Marquardt Algorithm

%% net parameters
net2layers.trainParam.epochs = 1000; % maximum training time
net2layers.trainParam.goal = 5e-3; % training goal tolerance
net2layers.trainParam.lr = 0.01; % learning rate
net2layers.trainParam.mc = 0.9; % momentum
net2layers.trainParam.show = 1; % show step

%% training data ...
net2layers.divideFcn = 'dividerand';
net2layers.divideParam.trainRatio = 0.7;
net2layers.divideParam.valRatio = 0.15;
net2layers.divideParam.testRatio = 0.15;

%% train and save
[net2layers,tr] = train(net2layers,p,t);
view(net2layers)
save net2layers;
toc
