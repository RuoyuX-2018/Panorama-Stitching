function C = cylinder(img)
%cylinder projection
[H,W,k]=size(img);
f=W/(2*tan(pi/4/2)); %change f to change the radian of image
C=zeros(H,W);
for i=1:H
    for j=1:W
        yy=f*tan((j-W/2)/f)+W/2;
        xx=(i-H/2)*sqrt((j-W/2)^2+f^2)/f+H/2;
        xx=round(xx);
        yy=round(yy);
        if(xx<1||yy<1||xx>H||yy>W)
            continue;
        end
    C(i,j,1)=img(xx,yy,1);
    C(i,j,2)=img(xx,yy,2);
    C(i,j,3)=img(xx,yy,3);
    end
end
end
