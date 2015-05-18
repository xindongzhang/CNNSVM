%computes a cumulative sum for a 2D array
%additionally adds a sentinel (zero row/colum)

function CD = cumsum2D(D)
   CD = zeros(size(D,1)+1,size(D,2)+1,size(D,3));
   CD(2:end,2:end,:) = cumsum(cumsum(D,1),2);
end