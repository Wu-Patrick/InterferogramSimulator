% =========================================================================
% Copyright:    WZP
% Filename:     showSamples.m
% Description:  If you use this code, please cite:
%               Wu, Zhipeng, et al. "Deep-learning based phase discontinuity prediction for two-dimensional phase unwrapping of SAR interferograms." IEEE Transactions on Geoscience and Remote Sensing (2021).
%               Wu, Zhipeng, et al. "Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms." IEEE Transactions on Geoscience and Remote Sensing 60 (2021): 1-18.
%
% @author:      wuzhipeng
% @email:       763008300@qq.com
% @website:     https://wuzhipeng.cn/
% @create on:   20-Apr-2022 14:28:11
% @version:     Matlab 9.11.0.1769968 (R2021b)
% =========================================================================

function showSamples(params)

folders = fieldnames(params.out);
for idx = length(folders):-1:1
    if ~params.out.(folders{idx})
        folders(idx)=[];
    elseif ~exist(fullfile(params.savePath,folders{idx}),'dir')
        folders(idx)=[];
        warning([folders{idx} ' : Folder does not exist!']);
    end
end

if length(folders)<1; warning('There is nothing to show.'); return; end

showRows = floor(sqrt(length(folders)));
showCols = ceil(length(folders)/showRows);

fileNames = listdir(fullfile(params.savePath,folders{1}),'/*.wzp');

for idx = 1:length(fileNames)
    fileName = fileNames{idx};
    disp([fileName '  ' num2str(idx) '/' num2str(length(fileNames))]);

    figure(1);
    for dirid = 1:length(folders)
        subplot(showRows,showCols,dirid);
        folder = folders{dirid};
        
        if ismember(folders{dirid},{'deformBbox'})
            filepath = fullfile(params.savePath,folder,changeSuffix(fileName,'.txt','.wzp'));
            if ~isfile(filepath);continue;end
            contents = load(filepath);
            img = imreadbin3(fullfile(params.savePath,'interf',fileName),params.sampleSize,params.sampleSize);
            showBbox(img,contents); colormap jet; colorbar; axis image;
            title(folder,'Interpreter','none');
        else
            filepath = fullfile(params.savePath,folder,fileName);
            img = imreadbin3(filepath,params.sampleSize,params.sampleSize);

            h = imagesc(sum(img,3)); colormap jet; colorbar; axis image;
            % set(h,'AlphaData',mask);
            if size(img,3)>1
                title([folder ' (' num2str(size(img,3)) '-channel sum)'],'Interpreter','none');
            else
                title(folder,'Interpreter','none');
            end
        end

    end

    linkaxesAll;
    keyboard;
end

end
