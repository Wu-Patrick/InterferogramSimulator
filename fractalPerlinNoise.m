% =========================================================================
% Copyright:    WZP
% Filename:     fractalPerlinNoise.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
% 
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   29-Oct-2019 20:38:07
% @version:     Matlab 9.4.0.813654 (R2018a)
% =========================================================================

%% fractalPerlinNoise
function zmat = fractalPerlinNoise(lenx,leny,fractal,q,maxx,maxy)

if nargin<4
    q = randR([0.5,1]);
end
if nargin<3
    fractal = randsrc(1,1,[1, 2, 3, 4, 5]);
end
if nargin<2
    leny = 180;
end
if nargin<1
    lenx = 180;
end

if nargin<6
    % Upper limit of the range of images
    maxx=randsrc(1,1,[2, 3, 4, 5, 6, 7]);
    maxy=randsrc(1,1,[2, 3, 4, 5, 6, 7]);
end

dx=maxx/lenx;dy=maxy/leny; % Image granularity
    
zmat = zeros(leny,lenx);
for i=1:fractal
    c = 2^(i-1);
    zmatn = perlinnoise2f([0 maxx*c],[0 maxy*c],dx*c,dy*c);
    zmat = zmat + zmatn*q^(i-1);
end
maxV = max(max(zmat)); minV = min(min(zmat));
% zmat = (zmat-minV)/(maxV-minV);
zmat = 2*(zmat-minV)/(maxV-minV)-1;
% imagesc(zmat);

end

%% perlinnoise2f
function zmat=perlinnoise2f(limx,limy,dx,dy)
% Two-dimensional Perlin noise

% Define the grid
minx=limx(1);maxx=limx(2);
miny=limy(1);maxy=limy(2);
numx=maxx-minx+1;
numy=maxy-miny+1;
numx_z=round((maxx-minx)/dx);
numy_z=round((maxy-miny)/dy);

% Generate a random vector array, note the number of rows and columns
[uxmat,uymat]=randxymat(numx+1,numy+1); 

[x,y]=meshgrid(linspace(minx,maxx,numx_z),linspace(miny,maxy,numy_z));

% Calculation of n00
ddx=x-floor(x);
ddy=y-floor(y);
ux=uxmat(sub2ind(size(uxmat),floor(y)-miny+1,floor(x)-minx+1));
uy=uymat(sub2ind(size(uymat),floor(y)-miny+1,floor(x)-minx+1));
n00=GridGradient(ux,uy,ddx,ddy);

% Calculation of n10
ddx=x-floor(x)-1;
ddy=y-floor(y);
ux=uxmat(sub2ind(size(uxmat),floor(y)-miny+1,floor(x)-minx+2));
uy=uymat(sub2ind(size(uymat),floor(y)-miny+1,floor(x)-minx+2));
n10=GridGradient(ux,uy,ddx,ddy);

% Calculation of n01
ddx=x-floor(x);
ddy=y-floor(y)-1;
ux=uxmat(sub2ind(size(uxmat),floor(y)-miny+2,floor(x)-minx+1));
uy=uymat(sub2ind(size(uymat),floor(y)-miny+2,floor(x)-minx+1));
n01=GridGradient(ux,uy,ddx,ddy);

% Calculation of n11
ddx=x-floor(x)-1;
ddy=y-floor(y)-1;
ux=uxmat(sub2ind(size(uxmat),floor(y)-miny+2,floor(x)-minx+2));
uy=uymat(sub2ind(size(uymat),floor(y)-miny+2,floor(x)-minx+2));
n11=GridGradient(ux,uy,ddx,ddy);
        
% Weighted Integration
n0=lerp(n00,n10,x-floor(x));
n1=lerp(n01,n11,x-floor(x));
zmat=lerp(n0,n1,y-floor(y));

% Scaling the value to [0, 1]
% zmat=zmat+0.5;
% zmat(zmat>1)=1;zmat(zmat<0)=0;
% maxV = max(max(zmat)); minV = min(min(zmat));
% zmat = (zmat-minV)/(maxV-minV);

% Generate images
% [xmat,ymat]=meshgrid(minx:dx:maxx,miny:dy:maxy);
% figure
% pcolor(xmat,ymat,zmat)
% shading interp

% Show arrows
% clf; imagesc(zmat);
% for i=1:3
%     for j=1:3
%         x = i/4; y = j/4;
%         annotation('arrow',[x,x+uxmat(i,j)/10],[y,y+uymat(i,j)/10]);
%     end
% end

end

% Calculation of gradient
function u=GridGradient(ux,uy,dx,dy)
    u=ux.*dx+uy.*dy;
end

% Weighted Integration
function u=lerp(a,b,t)
    tw=6*t.^5-15*t.^4+10*t.^3; % 6*t.^5-15*t.^4+10*t.^3;%3*t.^2-2*t.^3;%
    u=(1-tw).*a + tw.*b;
end

% Random vectors in the unit circle
function [uxmat,uymat]=randxymat(numx,numy)
    theta = randR([0,2*pi],numy,numx);
    r = rand(numy,numx);
    uxmat = r.*cos(theta);
    uymat = r.*sin(theta);
end