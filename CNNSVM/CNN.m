clear all;
close all;
clc;

addpath ./data
addpath ./util
addpath ./cnn
addpath ./cnn-model

load mnist_uint8;
load epoch10.mat;


train_x = double(reshape(train_x',28,28,60000))/255;
test_x = double(reshape(test_x',28,28,10000))/255;
train_y = double(train_y');
test_y = double(test_y');


[er, predict, groundtruth] = cnn_predict(cnn, test_x, test_y);
disp(strcat('准确率为 ',num2str((1-er)*100),'%'))
C = confusionmat(groundtruth, predict)   
