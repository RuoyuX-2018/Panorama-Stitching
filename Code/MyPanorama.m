function panorama = MyPanorama(img_path)
%img_path is string like '../p2_test_images/test2/',output is the panorama
%of all images in set
%%
%load image, dataset has n sells storing images
directory = img_path;
files = dir(directory);
files = files(3:end);

N = numel(files);
dataset = {};
cnt = 1;
for i = 1:N
    if files(i).name(1) ~= '.'
    im = imread(strcat(directory,files(i).name));
    im = double(im)/255;
    dataset{cnt} = im;
    imshow(im);
    drawnow;
    cnt = cnt + 1;
    end
end

%%
%register image pairs
%initialize I(1) to use as pointsPrevious and featuresPrevious
I = dataset{1};
I_gray = rgb2gray(I);
%get corner points coordinates
points = ANMS(I_gray,300);
%feature descriptor
features = describe(I_gray,points,1.4);
tform(N) = projective2d(eye(3));
imageSize = zeros(N,2);
%imageSize(1,:) = size(I_gray);
for n = 2:N
    pointsPrevious = points;
    featuresPrevious = features;
    I = dataset{n};
    I_gray = rgb2gray(I);
    imageSize(n,:) = size(I_gray);
    points = ANMS(I_gray,300);
    features = describe(I_gray,points,1.4);
    thredhold = 2;
    ite = 1000;
    thres_homo = 100;
    thres_inlier = 0.8;
    %get match points
    [match_point_1,match_point_2]=feature_match(featuresPrevious,features,pointsPrevious,points,thredhold);
    %use RANSAC to optimize
    [good_points_1,good_points_2,H] = RANSAC(match_point_1,match_point_2,ite,thres_homo,thres_inlier);
    %hImage_test = showMatchedFeatures(I_1,I_2,[good_points_1(:,2),good_points_1(:,1)],[good_points_2(:,2),good_points_2(:,1)],'montage');
    %I = imgBlending(I_1_rgb,I_2_rgb,good_points_1,good_points_2);

    %get transform matrixs
    good_points_1(:,[1,2]) = good_points_1(:,[2,1]);
    good_points_2(:,[1,2]) = good_points_2(:,[2,1]);
    tform(n) = estimateGeometricTransform(good_points_2,good_points_1,'projective');
    tform(n).T = tform(n).T * tform(n-1).T;
end

%%
%compute the output limits for each transform
for i = 1:N
    [xlim(i,:), ylim(i,:)] = outputLimits(tform(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end
avgXlim = mean(xlim,2);
[~,idx_x] = sort(avgXlim);
centerIdx_x = floor(N/2);
centerImgIdx_x = idx_x(centerIdx_x);
Tinv = invert(tform(centerImgIdx_x));

for i = 1:N
    tform(i).T = tform(i).T * Tinv.T;
end

%%
%initialize the panomara
for i = 1:N
    [xlim(i,:), ylim(i,:)] = outputLimits(tform(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

maxImageSize = max(imageSize);

% Find the minimum and maximum output limits
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', I);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:N

    I = dataset{i};

    % Transform I into the panorama.
    warpedImage = imwarp(I, tform(i), 'OutputView', panoramaView);

    % Generate a binary mask.
    mask = imwarp(true(size(I,1),size(I,2)), tform(i), 'OutputView', panoramaView);

    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
end

figure;
imshow(panorama);
end
