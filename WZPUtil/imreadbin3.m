% =========================================================================
% Copyright:    WZP
% Filename:     imreadbin3.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   14-Feb-2020 18:04:45
% @version:     Matlab 9.4.0.813654 (R2018a)
% =========================================================================
%imreadbin3 Read 3D image from real-valued *.wzp binary file.
% matrix = imreadbin3(path, m, n, z, dtype)
%
% Example:
%     1. 
%         a = imreadbin('a.wzp', 180, 180);
%         figure,imagesc(a(:,:,0)); colormap jet; axis equal
%     2. 
%         a = imreadbin('a.wzp', 180, 180, 2);
%         figure,imagesc(a(:,:,0)); colormap jet; axis equal

function matrix = imreadbin3(path, m, n, z, dtype)

if nargin<1
    help imreadbin3;
    return
end

if nargin<5
    dtype = 'single';
end

fileID=fopen(path,'r');
A = fread(fileID,dtype);
fclose(fileID);

lenA = length(A);

if nargin<2
    sideLen = sqrt(lenA/2);
    if floor(sideLen)~=sideLen
        error('This is not a square matrix. Enter m, n, and z.');
    else
        m = floor(sideLen);
        n = m;
        z = 2;
    end
elseif nargin<3
    n = lenA/m/2;
    z = 2;
    if floor(n)~=n
        error('The input m,n,z needs to be an integer.');
    end
elseif nargin<4
    z = lenA/m/n;
    if floor(z)~=z
        error('The input m,n,z needs to be an integer.');
    end
end

matrix = reshape(A,n,m,z);
matrix = permute(matrix,[2 1 3]);
