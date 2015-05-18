function [f_train,f_test] = compute_sphog_features(x_train,x_test)
    global config;
    blocks = config.BLOCKS;
    H = config.PATCH_H;
    W = config.PATCH_W;
    
    [gw, gh, level_weights] = get_sampling_grid(W,H,blocks,config.DO_OVERLAP);
    
    
    param.nori=config.NORI; 
    param.ww = W; param.hh = H;
    
    dim = 0;
    breaks = 0;
    for i = 1:length(gw),
        dim = dim + (size(gw{i},1)-1)*(size(gw{i},2)-1)*param.nori;
    end
    fprintf('features are %i dimensional..\n',dim);
    
    f_train = zeros(size(x_train,1),dim);
    f_test  = zeros(size(x_test,1),dim);
    
    tic;
    for i = 1:size(x_train,1),
        f_train(i,:) = make_sphog_features(x_train(i,:),param,gw,gh,level_weights);
        if(mod(i,500)==0),
            fprintf('%i..',i);
        end
    end
    fprintf('\n%.2fs to compute training features\n',toc);
    
    tic;
    for i = 1:size(x_test,1),
        f_test(i,:) = make_sphog_features(x_test(i,:),param,gw,gh,level_weights);
        if(mod(i,500)==0),
            fprintf('%i..',i);
        end
    end
    fprintf('\n%.2fs to compute test features\n',toc);

end

function f=make_sphog_features(x,param,gw,gh,level_weights)
   I  = reshape(x,param.ww,param.hh);
   f = compute_features(I,param,gw,gh,1,level_weights);
end
