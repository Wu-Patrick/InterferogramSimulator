% =========================================================================
% Copyright:    WZP
% Filename:     getSlop.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
%
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   04-Aug-2021 16:51:35
% @version:     Matlab 9.9.0.1467703 (R2020b)
% =========================================================================

function img = getSlop(ro,co,ampRange)

%%% params
if nargin<3
    ampRange = [0,co/4.*pi]; % Amplitude range
end
rows = 1.5*ro;
cols = 1.5*co;

cx = 1:cols;
cy = func(cx);

rx = 1:rows;
ry = func(rx);

img = ry'*cy;
img = img./(max2(img)-min2(img));
img = img.*randR(ampRange);

img = imrotate(img,randR([0,360]),'bilinear');
% subplot(121),imagesc(wrapToPi(img));colormap jet;
[rows,cols]=size(img);
r1 = round((rows-ro)/2);
c1 = round((cols-co)/2);
img = img(r1:r1+ro-1,c1:c1+co-1);

% subplot(122),imagesc(wrapToPi(img));colormap jet;
end

function res=func(x)
if rand<0.2 % Probability of nonlinear transformation
    res= x.^2.*randn;
elseif rand<0.4 % Probability of nonlinear transformation
    res= sqrt(x).*randn;
else
    res = x*randn;
end
end