% =========================================================================
% Copyright:    WZP
% Filename:     createSubfolder.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   29-Jun-2021 13:08:05
% @version:     Matlab 9.9.0.1467703 (R2020b)
% =========================================================================

function folderPath=createSubfolder(rootPath,subfolder,createFlag)
if nargin<2
    subfolder='';
end
if nargin<3
    createFlag=1;
end
if ~createFlag
    folderPath = '';
    return;
end
folderPath = fullfile(rootPath,subfolder);
if ~exist(folderPath,'dir')
    mkdir(folderPath); 
end
end