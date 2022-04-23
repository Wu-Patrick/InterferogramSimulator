% =========================================================================
% Copyright:    WZP
% Filename:     getFalts.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      wangteng, wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   31-Mar-2021 14:48:59
% @version:     Matlab 9.9.0.1467703 (R2020b)
% =========================================================================

function dLOS=getFalts(faltParms)
if nargin<1
    faltParms.defalt = 1;
end

% Define fault model:
if ~isfield(faltParms, 'rows'); faltParms.rows=128; end
if ~isfield(faltParms, 'cols'); faltParms.cols=128; end
if ~isfield(faltParms, 'length'); faltParms.length=faltParms.cols/4; end
if ~isfield(faltParms, 'width'); faltParms.width=faltParms.rows/4; end
if ~isfield(faltParms, 'depth'); faltParms.depth=10; end
if ~isfield(faltParms, 'dip'); faltParms.dip=-90; end
if ~isfield(faltParms, 'strike'); faltParms.strike=90; end
if ~isfield(faltParms, 'xloc'); faltParms.xloc=faltParms.cols/2; end
if ~isfield(faltParms, 'yloc'); faltParms.yloc=faltParms.rows/2; end
if ~isfield(faltParms, 'sslip'); faltParms.sslip=0; end % positive means left-lateral, negtive means right-lateral
if ~isfield(faltParms, 'dslip'); faltParms.dslip=0.8; end
if ~isfield(faltParms, 'opening'); faltParms.opening=0; end
if ~isfield(faltParms, 'ATorDT'); faltParms.ATorDT='AT'; end % AT or DT

% set(gcf,'visible','off');
% Path_Out = ['.', '\','Outfiles', '\'];
% revised by yuqinghe 2020/5/10

% Ascending
% Mean heading angle: -13.3281 degrees
% Mean incidence angle: 34.1712 degrees
ha_AT=-13.3281/180*pi;
ia_AT=34.1712/180*pi;

prE_AT=sin(ia_AT)*cos(ha_AT);
prN_AT=sin(ia_AT)*sin(ha_AT);
prU_AT=cos(ia_AT);

% Desending
% Mean heading angle: -166.487 degrees
% Mean incidence angle: 34.16 degrees
ha_DT=-166.487/180*pi;
ia_DT=34.16/180*pi;

prE_DT=sin(ia_DT)*cos(ha_DT);
prN_DT=sin(ia_DT)*sin(ha_DT);
prU_DT=cos(ia_DT);

% LOS vector [ENU]
if strcmp(faltParms.ATorDT,'AT')
    los = [prE_AT prN_AT prU_AT];
else
    los = [prE_DT prN_DT prU_DT];
end

% los = [0.3 -0.15 .9];%ENVISAT
% los = [0.5487 -0.1000 0.8300]; %terraSAR descending
% los_az = [-0.1793 -0.9838 0];%terraSAR descending in azimuth
%los = [ -0.4150 -0.0791 0.9064]; ascending
% Poissions ratio
nu = 0.25;

pm = [faltParms.length,faltParms.width,faltParms.depth,faltParms.dip,faltParms.strike,faltParms.xloc,faltParms.yloc,faltParms.sslip,faltParms.dslip,faltParms.opening]; 

% Define coordinate grid [faltParms.length]:
[xc,yc] = meshgrid(1:faltParms.cols,1:faltParms.rows);

% Caculate model for given coordinates
G = disloc(pm',[xc(:) yc(:)]',nu);

% Extract deformation components
dE = 0*xc; dE(:) = G(1,:);
dN = 0*xc; dN(:) = G(2,:);
dU = 0*xc; dU(:) = G(3,:);
dLOS = (los(1)*dE + los(2)*dN +los(3)*dU);
dLOS = 4*dLOS*pi/0.056;
% w = wrap(4*dLOS*pi/0.056);
end