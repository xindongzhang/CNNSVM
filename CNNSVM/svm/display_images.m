%loop over training data and show images
function display_images(tr_label,tr_feat)
    figure;
    for i = 1:10,
        clf;
        imagesc(reshape(tr_feat(i,:),28,28)'); colormap gray;
        title(sprintf('digit type : %i\n',tr_label(i)));
        pause(1);
    end
end