% =========================================================================
% Copyright:    WZP
% Filename:     changeSuffix.m
% Description:
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   02-Sep-2020 10:52:27
% @version:     Matlab 9.4.0.813654 (R2018a)
% =========================================================================
%changeSuffix Change the suffix of the path.
% 
%   newpath = changeSuffix(oldPath,newS,oldS)
%   for example:
%       newpath = changeSuffix('C:\a.wzp','.png','.wzp')

function newpath = changeSuffix(oldPath,newS,oldS)
    if nargin<1
        help changeSuffix; return;
    end
    [pathstr, name, ext] = fileparts(oldPath);
    if nargin<3
        newpath = fullfile(pathstr, [name, newS]);
    else
        newpath = fullfile(pathstr, replace([name, ext],oldS,newS));
    end
end