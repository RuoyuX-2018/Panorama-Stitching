function [match_point_1,match_point_2]=feature_match(d1,d2,bestPoint_1,bestPoint_2,thredhold)
% bestPoint_1, bestPoint_2, bestPoint from ANMS;
% d1, d2, feature describtor for best_point_1 and best_point_2;
% thredhold: determined how much the ratio for first_match/second_match
% should be


len1 = length(bestPoint_1(:,1));

match_point_1 = [];
match_point_2 = [];

for j = 1:len1
    point1 = d1(:,j);
    len2 = length(bestPoint_2(:,1));
    distance = inf([len2,1]);
    
    for i = 1:len2
        point2 = d2(:,i);
        distance(i) = sum((point1 - point2).^2);
    end
    toSort = [distance,bestPoint_2];
    sorted = sortrows(toSort,1,'ascend');
    if (sorted(2,1)/sorted(1,1)> thredhold)
        match_point_1 = [match_point_1; bestPoint_1(j,:)];
        match_point_2 = [match_point_2; sorted(1,[2:3])];
        
    end
end