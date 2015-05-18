function feats=compute_features(I,param,gw,gh,sampling,level_weights)
    [h,w,nch]=size(I);
    R = compute_gradient(I,param.nori);
    if(sampling == 1)
      %center clip 
      loch = floor(mod(h,param.hh)/2)+1;
      locw = floor(mod(w,param.ww)/2)+1;
    else 
      %ramdomly sample 128x64 images from the image
      locw=floor(rand(sampling,1)*(w-param.ww - 2*param.border))+1+param.border;
      loch=floor(rand(sampling,1)*(h-param.hh - 2*param.border))+1+param.border;
    end
    if(nargin > 5),
        feats = compute_gradient_features(R,param.ww,param.hh,locw,loch,gw,gh,level_weights);
    else
        feats = compute_gradient_features(R,param.ww,param.hh,locw,loch,gw,gh);
    end
        
end
