%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Media and Cognition                                 %
% Demo for SVM based handwritten numeral recognition  %
% TH-EE copyright 2015                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all,close all,clc;

addpath ./svm
addpath ./data
addpath ./feat-code

numLabels=10; % 10 categories: 0~9

numTrain = 6000;   % number of training samples used. libsvm runs very slowly if the number is large
numTest = 1000;     % number of testing samples used

%configuration for sphog(Signed Response Histograms of Oriented Gradients) feature extraction 
%reference for sphog:  http://people.cs.umass.edu/~smaji/projects/digits/index.html
%please try other features if possible
global config;
config.BLOCKS      = [14 7 4; 14 7 4]; % block sizes for histogramming
config.DO_OVERLAP  = true;             % have overlapping blocks
config.NORI        = 4;               % number of orientations  
config.PATCH_W     = 28;               % patch width (do not change)
config.PATCH_H     = 28;               % patch height (do not change)
config.NORM_TYPE   = 'l1';             % or l1 (total pixels are normalized)
config.GRAD_TYPE   = 2;                % 0 - tap, 1-sobel, 2 - gaussian filters 
config.GRAD_SIGMA  = 2;                % sigma of the gaussian filter

data_dir = 'data';

load mnist_uint8;

train_x = double(train_x)/255;
test_x = double(test_x)/255;
train_y = double(train_y');
test_y = double(test_y');

tr_labels = train_y;
tr_labels = [0:9] * tr_labels;
tr_labels = tr_labels';
tr_data   = train_x;

te_labels = test_y;
te_labels = [0:9] * te_labels;
te_labels = te_labels';
te_data   = test_x;


%display some data
display_images(tr_labels,tr_data);

tr_data = tr_data(1:numTrain, :);
te_data = te_data(1:numTest, :);
tr_labels = tr_labels(1:numTrain);
te_labels = te_labels(1:numTest);

%compute SPHOG features
sphog_file = sprintf('.\\cache\\sphog_%i_%i.mat',numTrain,config.NORI);
if(exist(sphog_file,'file')),
    tic;
    load(sphog_file);
    fprintf('%.2fs to load precomputed features..\n',toc);
else
    [tr_sphog_feats,te_sphog_feats] = compute_sphog_features(tr_data,te_data);
    save(sphog_file,'tr_sphog_feats','te_sphog_feats');
end

%using original image samples
%trainFeaSel = tr_data(1:numTrain,:);   

%using sphog_features
trainFeaSel = tr_sphog_feats(1:numTrain,:); 
trainLabelSel = tr_labels(1:numTrain);
trainLabelSel = trainLabelSel+1;

%using original image samples
%testFeaSel = te_data(1:numTest,:); 

%using sphog_features   
testFeaSel = te_sphog_feats(1:numTest,:); 
testLabelSel = te_labels(1:numTest);
testLabelSel = testLabelSel+1;

%# train one-against-all models
% please try to use one-against-one models and different model parameters
model = cell(numLabels,1);
for k=1:numLabels
    trainLabelSelBin=double(trainLabelSel==k);
    model{k} = svmtrain(trainLabelSelBin, trainFeaSel, '-c 1 -g 0.2 -b 1');
end

%# get probability estimates of test instances using each model
prob = zeros(numTest,numLabels);
for k=1:numLabels
    testLabelSelBin = double(testLabelSel==k)
    [~,~,p] = svmpredict(testLabelSelBin, testFeaSel, model{k}, '-b 1');
    prob(:,k) = p(:,model{k}.Label==1);    %# probability of class==k
end

%# predict the class with the highest probability
[~,pred] = max(prob,[],2);
acc = sum(pred == testLabelSel) ./ numel(testLabelSel)    %# accuracy
C = confusionmat(testLabelSel, pred)                   %# confusion matrix