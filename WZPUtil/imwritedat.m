% =========================================================================
% Copyright:    WZP
% Filename:     imwritedat.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   20-Jun-2021 17:26:26
% @version:     Matlab 9.9.0.1467703 (R2020b)
% =========================================================================
%imwritedat Save image to a real-valued or complex-valued binary file 
% (*.wzp, *.dat, or the files used by gamma software).
% 
% imreaddat(matrix, path, machineformat)
%   dtype (default: 'single'):
%       'int8'    'integer*1'      integer, 8 bits.
%       'int16'   'integer*2'      integer, 16 bits.
%       'int32'   'integer*4'      integer, 32 bits.
%       'int64'   'integer*8'      integer, 64 bits.
%       'uint8'   'integer*1'      unsigned integer, 8 bits.
%       'uint16'  'integer*2'      unsigned integer, 16 bits.
%       'uint32'  'integer*4'      unsigned integer, 32 bits.
%       'uint64'  'integer*8'      unsigned integer, 64 bits.
%       'single'  'real*4'         floating point, 32 bits.
%       'float32' 'real*4'         floating point, 32 bits.
%       'double'  'real*8'         floating point, 64 bits.
%       'float64' 'real*8'         floating point, 64 bits.
%       'complex' 'float32*2'      floating point, 64 bits.
%   machineformat (default: 'l'):
%       'b' for Big-endian ordering (GAMMA) 
%       'l' for Little-endian ordering
% 
% Example:
%     1. diff
%         imwritedat(matrix, '190104_190215.adf.diff')
%     2. unw
%         imwritedat(matrix, '190104_190215.adf.unw')

function imwritedat(matrix, path, machineformat)

if nargin<1
    help imwritedat;
    return;
end
if nargin<2
    error('Please enter save path.');
end

if nargin<3
    machineformat = 'l'; % machineformat, 'b' for Big-endian ordering(GAMMA) 'l' for Little-endian ordering
end

cpx = 2-isreal(matrix);
dtype = class(matrix);

if cpx==2
    matrixNew = zeros(size(matrix).*[1 2]);
    matrixNew(:,1:2:end)=real(matrix);
    matrixNew(:,2:2:end)=imag(matrix);
    matrix = matrixNew;
end

fileID = fopen(path,'wb',machineformat);
fwrite(fileID, squeeze(matrix'), 'single', 0, machineformat);
fclose(fileID);
