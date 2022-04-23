% =========================================================================
% Copyright:    WZP
% Filename:     generate.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
%
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   29-Jun-2021 12:55:53
% @version:     Matlab 9.9.0.1467703 (R2020b)
% =========================================================================

function generate(params)
saveFolderNames = fieldnames(params.out);
for idx = length(saveFolderNames):-1:1
    if ~params.out.(saveFolderNames{idx}); saveFolderNames(idx)=[]; end
end
createSubfolder(params.savePath);
for idx=1:length(saveFolderNames)
    createSubfolder(params.savePath,saveFolderNames{idx});
    if params.savePNGFlag && ~ismember(saveFolderNames{idx},{'deformBbox'})
        createSubfolder(params.savePath,[saveFolderNames{idx} 'Show']);
    end
end

fileNames = listdir(params.demFolder,'/*.tif');
fileNum = length(fileNames);

if ~fileNum
    cycleNum = 1;
    warning('DEM file not found, DEM not used!');
else
    cycleNum = fileNum;
end
singleNum = ceil(params.totalNum/cycleNum);

tic
for fileId=1:cycleNum
    if fileNum
        fileName = fileNames{fileId};

        dem = imread(fullfile(params.demFolder, fileName));
        dem = double(dem);

        % Incidence angle range	18.3° - 46.8°
        incidenceAngle = randR([18.3,46.8]); % 32.55;
        wavelength = 0.0560; % unit: meter
        LosPhase = 4*pi*dem*cos(incidenceAngle)/wavelength;
        LosPhase(dem==-32768|dem==inf)=nan;
    else
        LosPhase=nan;
    end
    ibegin = (fileId-1)*singleNum;
    iend = fileId*singleNum-1; if iend>params.totalNum-1; iend=params.totalNum-1; end

    if params.Parallel
        parfor i = ibegin:iend
            randomClipping(params,fileNum,LosPhase,fileId,i,saveFolderNames);
        end
    else
        for i = ibegin:iend
            randomClipping(params,fileNum,LosPhase,fileId,i,saveFolderNames);
        end
    end
end
toc
disp(['average time: ' num2str(toc/params.totalNum)]);
disp('over!');

end

%% Sub-functions for parallel processing
function randomClipping(params,fileNum,LosPhase,fileId,i,saveFolderNames)
if fileNum
    [m,n] = size(LosPhase);
    r1 = randi(m-params.sampleSize+1);
    c1 = randi(n-params.sampleSize+1);
    img = LosPhase(r1:r1+params.sampleSize-1,c1:c1+params.sampleSize-1);

    maxV = max2(img); minV=min2(img);
    if maxV~=minV
        img = (img-min2(img))/(max2(img)-min2(img));
        img = img.*randR([-6*pi,6*pi]); %amp=6*pi;;
    end
else
    img = zeros(params.sampleSize,params.sampleSize);
end

outputs = generateOne(img,params);

name = num2str(i,'%05d');
for idx=1:length(saveFolderNames)
    folderName = saveFolderNames{idx};
    if ~isfield(outputs,folderName);error([folderName ' is not included in the generated data, please check!']);end
    if isnan(outputs.(folderName)); warning(['outputs.' folderName ' is nan, not saved.']);continue;end
    if ismember(folderName,{'deformBbox'})
        if~isempty(outputs.(folderName))
            writematrix(outputs.(folderName),fullfile(params.savePath,folderName,[name,'.txt']),"Delimiter"," ");
        end
    else
        imwritebin3(outputs.(folderName),fullfile(params.savePath,folderName,[name,'.wzp']));
        if params.savePNGFlag; imwrite(matToRGB(outputs.(folderName)),fullfile(params.savePath,[folderName 'Show'],[name,'.png'])); end
    end
    
end

disp(['fileId:' num2str(fileId) '    ' 'i:' num2str(i) '/' num2str(params.totalNum)]);
end