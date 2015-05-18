clear all;
close all;
clc;

addpath ./data
addpath ./util
addpath ./cnn

load mnist_uint8;
load epoch9.mat;

train_x = double(reshape(train_x',28,28,60000))/255;
test_x = double(reshape(test_x',28,28,10000))/255;
train_y = double(train_y');
test_y = double(test_y');

opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 1;

cnn = cnntrain(cnn, train_x, train_y, opts);

[er, bad] = cnntest(cnn, test_x, test_y);

%plot mean squared error
figure; plot(cnn.rL);
assert(er<0.12, 'Too big error');