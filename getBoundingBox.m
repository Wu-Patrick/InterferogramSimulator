% =========================================================================
% Copyright:    WZP
% Filename:     getBoundingBox.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
%
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   22-Apr-2022 22:25:29
% @version:     Matlab 9.11.0.1769968 (R2021b)
% =========================================================================

function [bbox,columnLabel]=getBoundingBox(BW,classId,showFlag)
if nargin<2
    classId=1;
end
if nargin<3
    showFlag=0;
end
if ~islogical(BW)
    error('Input must be a 2-D binary image.');
end

columnLabel = {'classId', 'xCenter', 'yCenter', 'width', 'height'};
bbox=[];

[m,n]=size(BW);
[L,Num] = bwlabel(BW);
if Num<1    
    return;
end

for idx=1:Num
    [y,x]=find(L==idx);
    x1 = min(x); x2 = max(x);
    y1 = min(y); y2 = max(y);

    xCenter = (x1+x2)/2/n;
    yCenter = (y1+y2)/2/m;
    w = (x2-x1)/n;
    h = (y2-y1)/m;

    bbox = [bbox; classId xCenter yCenter w h];
end
if showFlag
    showBbox(BW,bbox);
end

end


