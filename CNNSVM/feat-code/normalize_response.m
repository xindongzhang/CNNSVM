function N=normalize_response(R)
    blocksize=16; % every block OE is normalized to sum to 1
    normconst=4.0;
    [H W nch]=size(R);
    [ww hh]=get_sampling_grid(W,H,[blocksize;blocksize]);
    %correct for sentinel
    ww = ww{1}+1;
    hh = hh{1}+1;
    %compute cumulative sum
    C=cumsum2D(sum(R,3));
    N=zeros(size(R),'double');
    for i = 2:size(ww,1)
      for j = 2:size(ww,2)
        wi=ww(i,j); wi_=ww(i-1,j-1);
        hi=hh(i,j); hi_=hh(i-1,j-1);
        NF=C(hi,wi)-C(hi_,wi)-C(hi,wi_)+C(hi_,wi_)+normconst;
        N(hi_:hi-1,wi_:wi-1,:)=R(hi_:hi-1,wi_:wi-1,:)/NF;
      end
    end
end