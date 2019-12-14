function I = testPano(I_1_rgb,I_2_rgb,numHarris,thres_homo,thres_inlier,ite)
%   input is two rgb pictures, numHarris is the number of corners after
%   ANMS, thres_homo is the max SSD threshold, thres_inlier is the max
%   number of inliers and ite is the ietration.
%   output I is the panorama image
    I_1 = rgb2gray(I_1_rgb);
    I_2 = rgb2gray(I_2_rgb);
    bestPoint_1 = ANMS(I_1,numHarris);
    bestPoint_2 = ANMS(I_2,numHarris);
    imshow(I_1),hold on;
    plot(bestPoint_1(:,2),bestPoint_1(:,1),'ys'); hold off;
    figure;
    imshow(I_2),hold on;
    plot(bestPoint_2(:,2),bestPoint_2(:,1),'ys'); hold off;
    d1 = describe(I_1,bestPoint_1,1.4);
    d2 = describe(I_2,bestPoint_2,1.4);
    thredhold = 2;
    [match_point_1,match_point_2]=feature_match(d1,d2,bestPoint_1,bestPoint_2,thredhold);
    [good_points_1,good_points_2,H] = RANSAC(match_point_1,match_point_2,ite,thres_homo,thres_inlier);
    %hImage_test = showMatchedFeatures(I_1,I_2,[good_points_1(:,2),good_points_1(:,1)],[good_points_2(:,2),good_points_2(:,1)],'montage');
    I = imgBlending(I_1_rgb,I_2_rgb,good_points_1,good_points_2);
end

