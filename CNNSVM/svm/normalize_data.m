function nD = normalize_data(D,type)
    if(strcmpi(type,'l2')==1),
        D2 = sqrt(sum(D.^2,2)); %norm of each
        nD = zeros(size(D));
        for i = 1:size(D,1),
            nD(i,:) = D(i,:)./D2(i);
        end
    elseif(strcmpi(type,'l1')==1),
        D1 = sum(D,2);
        nD = zeros(size(D));
        for i = 1:size(D,1),
            nD(i,:) = D(i,:)./D1(i);
        end
        
    end
    
end