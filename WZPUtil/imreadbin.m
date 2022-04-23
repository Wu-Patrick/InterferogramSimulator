% =========================================================================
% Copyright:    WZP
% Filename:     imreadbin.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   04-Jul-2019 17:09:26
% @version:     Matlab 9.9.0.1467703 (R2020b)
% =========================================================================
%imreadbin Read image from real-valued *.wzp binary file.
% 
% img = imreadbin(path, rows, cols)
% 
% Example:
%     1. 
%         img = imreadbin('a.wzp', 180);
%         figure,imagesc(a); colormap jet; axis equal
%     2. 
%         img = imreadbin('a.wzp', 180, 180);
%         figure,imagesc(a); colormap jet; axis equal

function matrix = imreadbin(path, rows, cols)

if nargin<1
    help imreadbin;
    return
end

fileID=fopen(path,'r');
A = fread(fileID,'single');
fclose(fileID);

lenA = length(A);

if nargin<2
    sideLen = sqrt(lenA);
    if floor(sideLen)~=sideLen
        error('This is not a square matrix. Enter rows and cols.');
    else
        rows = floor(sideLen);
        cols = rows;
    end
elseif nargin<3
    cols = lenA/rows;
    if floor(cols)~=cols
        error('The input rows needs cols to be an integer.');
    end
end

if rows<=0
    rows = lenA/cols;
end
matrix = reshape(A,cols,rows)';
