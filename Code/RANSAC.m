function [good_points_1,good_points_2,H] = RANSAC(match_point_1,match_point_2,iteMax,thres_homo,thres_inlier)
%match_point_1 and match_point_2 are n*2 matrix gotten from feature_match
%function. iteMax is the max iteration of RANSAC and thres_homo is the
%threshold of SSD. good_points_1 are the coordinates of source image matched points after
%RANSAC and good_point_2 are the coordinates of destnation image
%initialized inliers and ietration
[matched_row,dim] = size(match_point_1);
inlier = 0;
ite = 0;
max_good_points_1 = [];
max_good_points_2 = [];
maxInlier = 0;
while inlier < thres_inlier*matched_row && ite<iteMax
    inlier = 0;
    %find four random feature pairs
    index = randperm(matched_row,4);
    ini_coor1 = [];
    ini_coor2 = [];
    %get the coordinates of four pairs
    for i = 1:4
        index_1 = index(i);
        ini_coor1 = [ini_coor1;match_point_1(index_1,:)];
        ini_coor2 = [ini_coor2;match_point_2(index_1,:)];
    end
    %calculate homography matrix
    H = est_homography(ini_coor2(:,2),ini_coor2(:,1),ini_coor1(:,2),ini_coor1(:,1));
    %get H*pi
    [homo_X,homo_Y] = apply_homography(H,match_point_1(:,2),match_point_1(:,1));
    good_points_1 = [];
    good_points_2 = [];
    %get SSD of each matched coordinate and store matched points of which
    %the SSD is less than threshold
    for i = 1:matched_row
        sum = (homo_X(i) - match_point_2(i,2))^2 + (homo_Y(i)-match_point_2(i,1))^2;
        if sum < thres_homo
            good_points_1 = [good_points_1;match_point_1(i,:)];
            good_points_2 = [good_points_2;match_point_2(i,:)];
            inlier = inlier + 1;
        end
    end
    if inlier > maxInlier
        maxInlier = inlier;
        max_good_points_1 = good_points_1;
        max_good_points_2 = good_points_2;
    end
    ite = ite + 1;
end
good_points_1 = max_good_points_1;
good_points_2 = max_good_points_2;
H = est_homography(good_points_2(:,2),good_points_2(:,1),good_points_1(:,2),good_points_1(:,1));
end
