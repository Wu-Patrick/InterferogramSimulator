% =========================================================================
% Copyright:    WZP
% Filename:     getBuilding.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   04-Aug-2021 17:36:01
% @version:     Matlab 9.9.0.1467703 (R2020b)
% =========================================================================

function img = getBuilding(ro,co,numRange,ampRange)

%%% params
if nargin<4
    ampRange = [pi/2,4*pi]; % Amplitude range
end
if nargin<3
    numRange = [0,20]; % Number of buildings (integer)
end
if nargin<2
    co = 180;
end
if nargin<1
    ro = 180;
end

rows = 1.5*ro;
cols = 1.5*co;

img = zeros(rows,cols);
maxNum = randi(floor(numRange));
for i=1:maxNum
    r1 = randi(rows);
    c1 = randi(cols);
    r2 = r1+round(randR([3,rows/8]))-1;if r2>rows;r2=rows;end
    c2 = c1+round(randR([3,cols/8]))-1;if c2>cols;c2=cols;end
    img(r1:r2,c1:c2)=img(r1:r2,c1:c2)+1;
%     if rand<0.2
%         img(r1:r2,c1:c2)=img(r1:r2,c1:c2)+getRamp(r2-r1+1,c2-c1+1);
%     else
%         img(r1:r2,c1:c2)=img(r1:r2,c1:c2)+1;
%     end
end


img = img./(max2(img)-min2(img));
img = img.*randR(ampRange);

img = imrotate(img,randR([0,360]),'nearest');
% subplot(121),imagesc((img));colormap jet;colorbar;
[rows,cols]=size(img);
r1 = round((rows-ro)/2);
c1 = round((cols-co)/2);
img = img(r1:r1+ro-1,c1:c1+co-1);
% subplot(122),imagesc((img));colormap jet;colorbar;