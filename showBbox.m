% =========================================================================
% Copyright:    WZP
% Filename:     showBbox.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   22-Apr-2022 23:11:38
% @version:     Matlab 9.11.0.1769968 (R2021b)
% =========================================================================

function showBbox(img,contents)
[m,n]=size(img);
imagesc(img);
for i=1:size(contents,1)
    content = contents(i,:);
    labelId = content(1);
    w = content(4);
    h = content(5);
    x = content(2)-w/2;
    y = content(3)-h/2;

    rectangle('Position',[x*n,y*m,w*n,h*m],'EdgeColor','r','LineWidth',2);
    text(x*n,y*m,num2str(labelId),'BackgroundColor','w');
end

end