function dim=compute_feature_dim(ww,hh,nori)
   dim = zeros(length(ww),1);
   for i = 1:length(ww)
     dim(i) = nori*(size(ww{i},1)-1)*(size(ww{i},2)-1);
   end
end