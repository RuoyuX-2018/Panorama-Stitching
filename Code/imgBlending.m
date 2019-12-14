function I = imgBlending(I_1_rgb,I_2_rgb,good_points_1,good_points_2)
hsv_1 = rgb2hsv(I_1_rgb);
hsv_2 = rgb2hsv(I_2_rgb);
[goodpoints_1_h,dim] = size(good_points_1);
V1 = 0;
V2 = 0;
for i = 1:goodpoints_1_h
    V1 = V1 + hsv_1(good_points_1(i,1),good_points_1(i,2),3);
    V2 = V2 + hsv_2(good_points_2(i,1),good_points_2(i,2),3);
end
scaleFactor = V2/V1;
hsv_1(:,:,3) = hsv_1(:,:,3)*scaleFactor;
I_1_rgb = hsv2rgb(hsv_1);

%blend images
good_points_1(:,[1,2]) = good_points_1(:,[2,1]);
good_points_2(:,[1,2]) = good_points_2(:,[2,1]);
tform = estimateGeometricTransform(good_points_2,good_points_1,'projective');
Rfixed = imref2d(size(I_1_rgb));
[j1,j2] = imwarp(I_2_rgb,tform);
I = imshowpair(I_1_rgb,Rfixed,j1,j2,'blend');
I = I.CData;
end