% =========================================================================
% Copyright:    WZP
% Filename:     getLocalVariance.m
% Description:
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   02-Apr-2021 14:41:54
% @version:     Matlab 9.9.0.1467703 (R2020b)
% =========================================================================


function [dataStd, absDataMean] = getLocalVariance(srcData, r)
% 计算局部标准差和均值
[nHeight, nWidth] = size(srcData);
N               = boxfilter(ones(nHeight, nWidth), r);
absDataMean     = boxfilter(abs(srcData), r*2) ./ N;
srcDataMean     = boxfilter(srcData, r) ./ N;
srcDataDataMean = boxfilter(srcData.*srcData, r) ./ N;
dataVariance    = srcDataDataMean - srcDataMean .* srcDataMean;
dataVariance(dataVariance<0)=0;
dataStd         = sqrt(dataVariance);
end
