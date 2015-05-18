%compute the weighted concatenated features
function f = concat_features(feats,level_weights)
   num_feats = size(feats{1},1);
   dim_sum = 0;
   for i = 1:length(feats)
     dim_sum = dim_sum + size(feats{i},2);
   end
   if(nargin < 2),
       level_weights = 2.^(0:length(feats)-1);
   end
   f = zeros(num_feats,dim_sum);
   dim_sum = 0;
   for i = 1:length(feats);
     f(:,dim_sum+1:dim_sum+size(feats{i},2)) = level_weights(i)*feats{i};
     dim_sum = dim_sum + size(feats{i},2);
   end
end