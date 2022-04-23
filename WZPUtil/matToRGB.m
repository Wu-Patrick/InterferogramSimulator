% =========================================================================
% Copyright:    WZP
% Filename:     matToRGB.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   12-Jun-2020 19:47:59
% @version:     Matlab 9.4.0.813654 (R2018a)
% =========================================================================
%matToRGB Convert matrix to color RGB image.
% 
% [H,alpha] = matToRGB(G, caxisV, C)
%   converts the matrix G to the color RGB image H.
%   input:
%     G: input mat metrix
%     caxisV: the two element vector [cmin cmax], specify the colorbar range 
%     C: colormap, such as 'jet' or 'flipud(jet)'
%   output:
%     H: rgb metrix
%     alpha: alpha channel, used to save transparent png


function [H,alpha] = matToRGB(G, caxisV, C)

if nargin < 1
    help matToRGB;
    return
end

if nargin >= 2 && caxisV(1) ~= caxisV(2)
    cmin = caxisV(1);
    cmax = caxisV(2);
else    
    cmin = min(G(:));
    cmax = max(G(:));
end

if nargin<3
    % Now make an RGB image that matches display from IMAGESC:
    C = jet(64);  % Get the figure's colormap.
end

G = sum(G,3);

alpha = G;
alpha(alpha~=0)=1;

G(G>cmax) = cmax;
G(G<cmin) = cmin;

% % Say this is the given matrix:
% G = rand(10,10)*300 - 100;
% % Use IMAGESC to plot G.
% figure('pos',[100 100 1000 800]);
% % colormap(copper) % You realize this affects final image (H)?
% subplot(1,2,1)
% imagesc(G);
% title('IMAGESC (MxN)')



L = size(C,1);
% Scale the matrix to the range of the map.
if cmax==cmin
    Gs = ones(size(G));
else
    Gs = round(interp1(linspace(cmin,cmax,L),1:L,G));
end


Gs(isnan(Gs))=1;

H = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.

% figure,imshow(H)