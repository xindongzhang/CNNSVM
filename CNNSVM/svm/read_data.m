function [tr_label,tr_feats,te_label,te_feats] = read_data(ntrain,data_dir)
global config;

if(nargin < 2),
    data_dir = 'data';
end 

if(nargin < 1),
    ntrain = -1;
end

% MNIST digits dataset (LeCun et al.)
te_label_file = [data_dir '/t10k-labels.idx1-ubyte'];
tr_label_file = [data_dir '/train-labels.idx1-ubyte'];
te_data_file  = [data_dir '/t10k-images.idx3-ubyte'];
tr_data_file  = [data_dir '/train-images.idx3-ubyte'];


% read training labels
tic;
fid = fopen(tr_label_file,'r');
B = fread(fid); fclose(fid);
%60000 training labels are the last 60000 bytes
tr_label = B(end-60000+1:end);
fprintf('%.4fs to read training labels\n',toc);

% read test labels
tic;
fid = fopen(te_label_file,'r');
B = fread(fid); fclose(fid);
%10000 test labels are the last 10000 bytes
te_label = B(end-10000+1:end);
fprintf('%.4fs to read test labels\n',toc);

% read the training data
tic;
fid = fopen(tr_data_file,'r');
if(ntrain < 0),
    B = fread(fid); fclose(fid);
    %ignore the headers 4x4 bytes
    B = B(17:end); 
    tr_feats = reshape(B,28*28,60000)';
    fprintf('%.4fs to read all training images\n',toc);
else
    lastB = 16 + ntrain*28*28;
    B = fread(fid,lastB);
    B = B(17:end); 
    tr_feats = reshape(B,28*28,ntrain)';
    tr_label = tr_label(1:ntrain);
    fprintf('%.4fs to read %i training images\n',toc,ntrain);
end    

% read the training data
tic;
fid = fopen(te_data_file,'r');
B = fread(fid); fclose(fid);
%ignore the headers 4x4 bytes
B = B(17:end); 
te_feats = reshape(B,28*28,10000)';
fprintf('%.4fs to read test images\n',toc);

%normalize the data
norm_type=config.NORM_TYPE; 
tic;
tr_feats = normalize_data(tr_feats,norm_type);
te_feats = normalize_data(te_feats,norm_type);
fprintf('%.4fs to %s normalize features\n',toc,norm_type);


