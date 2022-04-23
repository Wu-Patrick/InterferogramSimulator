% =========================================================================
% Copyright:    Zhipeng Wu
% Filename:     max2.m
% Description:
% 
% @author:      Zhipeng Wu
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   14-Mar-2020 21:35:45
% @version:     Matlab 9.4.0.813654 (R2018a)
% =========================================================================
%max2 Maximum elements of an matrix (A).
% 
% v = max2(A)

function v = max2(A)
    if nargin<1
        help max2;
        return;
    end
    v = max(A(:));
end