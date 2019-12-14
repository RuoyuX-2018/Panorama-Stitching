function standard_feature = standardize(feature)
   
   mu = mean(feature);
   s = std(feature);
   standard_feature = (feature-mu)/s;
   
end