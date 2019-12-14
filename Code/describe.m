function feature_describtor = describe(img,bestPoint,sigma)

%takes input for grayscale image,best Point, 
%and sigma for the gaussian patch
    %typecast(img,'double')
    blur_patch = fspecial('gaussian',40,sigma);
    I_1_blur = filter2(blur_patch,img);
	%I_1_blur = cast(I_1_blur,'uint8');
    [number,dim] = size(bestPoint);
    [row,col] = size(I_1_blur);
    feature_describtor = zeros(64,number);
    
    for i = 1:number

        point = bestPoint(i,:);
        if (point(1)-3>0 && point(1)+4< row && point(2)-3> 0 && point(2)+4 < col)
            feature = I_1_blur(point(1)-3:point(1)+4,point(2)-3:point(2)+4);
            feature = reshape(feature,[64,1]);
            
            
            feature = standardize(feature);
            feature_describtor(:,i) = feature;
        end
    end
end
