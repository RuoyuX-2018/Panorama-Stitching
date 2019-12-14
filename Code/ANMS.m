function bestPoint = ANMS(img,Nbest)

% take the input of a grayscale image and the number of points you want
% out put the top bestpoint
    C_img = cornermetric(img);
    possible_corner = imregionalmax(C_img);
    [row,col] = find(possible_corner==1);
    
    toDelete = [];
    [max_row,max_col] = size(img);
    for i = 1:length(row)
        if (row(i)-3<0 || row(i)+4>max_row || col(i)-3<0 || col(i)+4>max_col)
            toDelete = [toDelete,i];
        end
    end
    row(toDelete) = [];
    col(toDelete) = [];
   
    
    
    Nstrong = length(row);
    

    if Nbest> Nstrong
        printf("rescale Nbest = Nstrong/5");
        Nbest = floor(Nstrong/5);
    end
    
    r = inf([1,Nstrong]);
    for i = 1:Nstrong
        
        ED = inf;
        for j = 1:Nstrong
            if C_img(row(i), col(i))<C_img(row(j), col(j))
                ED = (row(j)-row(i))^2+(col(j) - col(i))^2;
                if ED < r(i)
                    r(i) = ED;
                end
            end
        end
    end
    to_Sort = [r',row,col];
    sorted = sortrows(to_Sort,1,'descend');
    bestPoint = sorted([1:Nbest],:);
    bestPoint = [bestPoint(:,2),bestPoint(:,3)];
end
