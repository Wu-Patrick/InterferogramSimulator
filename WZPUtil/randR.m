% =========================================================================
% Copyright:    WZP
% Filename:     randR.m
% Description:  
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   06-Sep-2019 10:50:50
% @version:     Matlab 9.4.0.813654 (R2018a)
% =========================================================================
%randR Uniformly distributed pseudorandom numbers within a certain range.
% 
% out = randR(range,m,n)
%   returns an m-by-n matrix containing pseudorandom values drawn
%   from the standard uniform distribution on the open interval range.
%   default: 
%       range: [0,1]
%       m: 1
%       n: 1

function out = randR(range,m,n)

if nargin < 3
    n = 1;
end

if nargin < 2
    m = 1;
end

if nargin < 1
    range = [0,1];
end

out = rand(m,n)*(range(2)-range(1))+range(1);