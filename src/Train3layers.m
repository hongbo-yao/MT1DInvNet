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
% number of output nodes: 5 (rho1, rho2,rho3, h1, h2)

clc,clear,close all;
tic
T = logspace(-3,3,20); % period 
rho1 = linspace(100,1000,10);
rho2 = linspace(100,1000,10);
rho3 = linspace(100,1000,10);
h1 = linspace(100,1000,5);
h2 = linspace(100,1000,5);
n = length(rho1)*length(rho2)*length(rho3)*length(h1)*length(h2);
number_of_input = 20;
number_of_output = 5;
p0 = zeros(number_of_input, n); % each column represents an input
t0 = zeros(number_of_output, n);% each column represents an output

%% generate input and output data
ii = 1;
for i1=1:length(rho1)
    for i2=1:length(rho2)
        for i3=1:length(rho3)
            for i4=1:length(h1)
                for i5=1:length(h2)
                    t0(1,ii) = rho1(i1);
                    t0(2,ii) = rho2(i2);
                    t0(3,ii) = rho3(i3);
                    t0(4,ii) = h1(i4);
                    t0(5,ii) = h1(i5);
                    ii = ii+1;
                end
            end
        end
    end
end
for ii=1:n
    rho = t0(1:3,ii);
    h = t0(4:5,ii);
    [rhoa,phase] = MT1D(T,rho',h');
    p0(:,ii) = rhoa;
end

%% data normalization using mapminmax
% [p,ps] = mapminmax(p0,0,1);
% [t,ts] = mapminmax(t0,0,1);
p = p0;
t = t0;

%% build net
net3layers = feedforwardnet(10);

%% training BP algorithm
net3layers.trainFcn='trainlm'; % Levenberg-Marquardt Algorithm

%% net parameters
net3layers.trainParam.epochs = 500; % maximum training time
net3layers.trainParam.goal = 1e-2; % training goal tolerance
net3layers.trainParam.lr = 0.01; % learning rate
net3layers.trainParam.mc = 0.9; % momentum
net3layers.trainParam.show = 1; % show step

%% training data ...
net3layers.divideFcn = 'dividerand';
net3layers.divideParam.trainRatio = 0.7;
net3layers.divideParam.valRatio = 0.15;
net3layers.divideParam.testRatio = 0.15;

%% train and save
[net3layers,tr] = train(net3layers,p,t);
view(net3layers)
save net3layers;
toc
