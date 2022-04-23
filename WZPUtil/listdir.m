% =========================================================================
% Copyright:    Zhipeng Wu
% Filename:     listdir.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      Zhipeng Wu
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   13-Mar-2020 21:35:45
% @version:     Matlab 9.4.0.813654 (R2018a)
% =========================================================================
%listdir Lists the files or subfolders in a folder.
% 
% fileNames = listdir(folder, filter, idx)
% 
% input:
%     folder: must be specified as a character vector or string scalar.
%     filter: 'folder' to get all subfolders, regular expression (e.g.,
%             '*.png') to get files.
%     idx: return file name of idx
%          if idx<=0, return the full paths of all files.
% output:
%     fileNames: a cell

function fileNames = listdir(folder, filter, idx)

if nargin < 1
    help listdir;
    return;
end
if nargin < 2
    filter = '';
end

if strcmp(filter,'folder')
    d = dir(folder);
    isub = [d(:).isdir]; %# returns logical vector
    files = d(isub);
    files = files(3:end);
else
    files = dir(fullfile(folder, filter));
%     files = dir([folder filter]);
end

if nargin == 3
    if idx<=0
        fileNames = fullfile({files.folder},{files.name})';
        fileNames = sort(fileNames);
    else
        fileNames = {files.name}';
        fileNames = fileNames{idx};
    end
else
    fileNames = {files.name}';
    fileNames = sort(fileNames);
end

