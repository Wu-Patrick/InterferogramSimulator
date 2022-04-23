% =========================================================================
% Copyright:    Zhipeng Wu
% Filename:     linkaxesAll.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      Zhipeng Wu
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   12-Mar-2020 21:35:45
% @version:     Matlab 9.4.0.813654 (R2018a)
% =========================================================================
% linkaxesAll Synchronize limits of all drawn 2-D axes.
%  Use linkaxesAll to synchronize the individual axis limits
%  on different subplots in all figures. This is useful
%  when you want to zoom or pan in one subplot and display
%  the same range of data in another subplot.

% allh=findobj('Units', 'pixels'); % Root and figures
% allh=findobj('Units', 'normalized'); % axes
allh=findobj('Type', 'axes'); % axes
linkaxes(allh);
