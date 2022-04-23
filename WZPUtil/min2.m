% =========================================================================
% Copyright:    Zhipeng Wu
% Filename:     min2.m
% Description:
% 
% @author:      Zhipeng Wu
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   14-Mar-2020 21:35:45
% @version:     Matlab 9.4.0.813654 (R2018a)
% =========================================================================
%min2 Minimum elements of an matrix (M).
% 
% v = min2(M)

function v = min2(M)
    if nargin<1
        help min2;
        return;
    end
    v = min(M(:));
end