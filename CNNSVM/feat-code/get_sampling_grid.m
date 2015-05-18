%computes the locations of the grid points
function [ww hh level_weights] = get_sampling_grid(w,h,blocks,do_overlap)
   if(nargin < 4 || do_overlap == 0),
       num_levels = size(blocks,2);
       ww = cell(num_levels,1);
       hh = cell(num_levels,1);
       for level=1:num_levels
         bw = blocks(1,level);
         bh = blocks(2,level);
         offsetw = floor(mod(w,bw)/2);
         offseth = floor(mod(h,bh)/2);
         [ww{level},hh{level}]=meshgrid(offsetw:bw:w,offseth:bh:h);
       end
   else
       f_overlap = 0.5;
       ww={}; hh = {}; level_weights = [];
       gidx = 1;
       num_levels = size(blocks,2);
       for level = 1:num_levels,
           bw = blocks(1,level);
           bh = blocks(2,level);
           f_bw = bw*f_overlap;
           f_bh = bh*f_overlap;
           
           ow = unique(round(0:f_bw:bw-f_bw));
           oh = unique(round(0:f_bh:bh-f_bh));
           offsetw = floor(mod(w,bw)/2);
           offseth = floor(mod(h,bh)/2);
           for i = 1:length(ow),
               for j = 1:length(oh),
               if(i==length(ow) && j == length(oh)), continue, end;  
               [ww{gidx},hh{gidx}]=meshgrid(offsetw+ow(i):bw:w,offseth+oh(j):bh:h);
               level_weights(gidx) = 2^(level-1);
               gidx = gidx+1;
           end
           
       end
   end
end