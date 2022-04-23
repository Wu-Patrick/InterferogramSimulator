% =========================================================================
% Copyright:    WZP
% Filename:     imwritebin3.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   14-Feb-2020 18:33:54
% @version:     Matlab 9.4.0.813654 (R2018a)
% =========================================================================
%imwritebin3 Save 3D image (img) to real-valued *.wzp binary file (path).
% 
% imwritebin3(img, path);

function imwritebin3(img, path)

if nargin<2
    help imwritebin3;
    return;
end

fileID = fopen(path,'wb');
machineformat = 'native';
fwrite(fileID, permute(img,[2 1 3]), 'single', 0, machineformat);
fclose(fileID);