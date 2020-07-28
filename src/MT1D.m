% 1D layered magnetotelluric (MT) forward modeling code using 
% analytical approach

% References:
% [1] Ward, S., and G. Hohmann, 1987, Electromagnetic theory for 
% geophysical applications: in M. N. Nabighian, ed., SEG, 
% Electromagnetic methods in applied geophysics: vol. 1, 131?311.

% Author:     Hongbo Yao
% Institute:  School of Geosciences and Info-Physics,
%             Central South University (CSU)
% Email:      yaohongbo@csu.edu.cn
% Date:       2020/7/28

% GitHub Page: https://github.com/hongbo-yao
% Researchgate Page: https://www.researchgate.net/profile/Hongbo_Yao2


function [rho_a,phase] = MT1D(T, rho, h) 
% input:
% T: array of working period (1/frequencies)
% rho: electric resistivity of each layer, n_layers
% h: thickness of each layer, n_layers-1
%
% output:
% appres: apparent resistivity
% phase: impedance phase
mu0 = 4*pi*1e-7; 
k = zeros(size(rho,2), size(T,2)); 
for n = 1:size(rho,2) 
    k(n,:)=sqrt(-i*2*pi*mu0./(T.*rho(n))); 
end

m = size(rho,2); 
Z = -(i*mu0*2*pi)./(T.*k(m,:)); 
for n = m-1:-1:1 
    A = -(i*mu0*2*pi)./(T.*k(n,:)); 
    B = exp(-2*k(n,:)*h(n)); 
    Z = A.*(A.*(1-B)+Z.*(1+B))./(A.*(1+B)+Z.*(1-B)); 
end 

rho_a = (T./(mu0*2*pi)).*(abs(Z).^2); 
phase = -atan(imag(Z)./real(Z)).*180/pi; 
 
