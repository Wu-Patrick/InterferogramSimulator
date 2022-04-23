% =========================================================================
% Copyright:    WZP
% Filename:     main.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
%
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   19-Apr-2022 15:01:24
% @version:     Matlab 9.11.0.1769968 (R2021b)
% =========================================================================

%% Setting parameters
close all;clear;clc;
addpath('WZPUtil');

%%% Control parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.savePath = 'data/test';
                                % Data saving path
params.totalNum = 50;           % Total number of samples
params.sampleSize = 256;        % Size of generated sample
params.multilook = [1,4];       % multilook [Azimuth, Range]
params.demFolder = 'DEM/unzip';
                                % Folder path containing multiple DEM (*.tif format)
                                % You can download DEM files from: https://srtm.csi.cgiar.org/srtmdata/

%%% output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.savePNGFlag = 1;         % Save the *.png image corresponding to the data
params.out.origin = 1;          % Original phase
params.out.originWrapped = 1;   % Wrapped version of the original phase, i.e., noise-free interferogram
params.out.interf = 1;          % Simulated interferogram
params.out.coherence = 1;       % Estimated coherence
params.out.deformBbox = 1;      % Location and category of deformation area
params.out.VDRI = 1;            % Horizontal phase gradient + residual map
                                % + vertical phase gradient + interferogram (4 channels)
params.out.branchCut = 1;       % Horizontal branch-cut and vertical branch-cut (2 channels)
% You can customize other types of output and implement them in "generateOne.m".

%%% Add phase components with a certain probability (0-1) %%%%%%%%%%%%%%%%%
params.probSlop = 0.1;          % Slope phase
params.probBuilding = 0.2;      % Building phase
params.probTurbulence = 0.8;    % Atmospheric turbulence phase, i.e., fractal Perlin noises
params.probDeform = 0.2;        % Distorted two-dimensional Gaussian surface
params.probEarthquake = 0.2;    % Deformation caused by earthquakes
params.probWater = 0.5;         % Completely decorrelated area (water area)

params.noiseType = 0;           % 0 : Deformation-related noise
                                % 1 : Noise with random signal-to-noise ratio, not recommended
params.noiseSNRRange = [0.2,5]; % Need to specify when noiseType=1
% Other parameters can be modified in the source code.

%%% Parallel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.Parallel = 0;
% if params.Parallel; delete(gcp('nocreate')); end

%% Run
generate(params);

%% Show samples
showSamples(params);