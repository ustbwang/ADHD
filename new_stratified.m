clear all
clc
%% %%%%%%%%%%%%%%%%%%%%%%%%   PU1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('E:\研究生\代码整理及fig文件\data\pu1_data_train.mat');
% load('E:\研究生\代码整理及fig文件\data\pu1_data_test.mat');
% load('E:\研究生\代码整理及fig文件\data\pu1_label_train.mat');
% load('E:\研究生\代码整理及fig文件\data\pu1_label_test.mat');
% load('E:\研究生\代码整理及fig文件\data\pu1_data_vali.mat');
% load('E:\研究生\代码整理及fig文件\data\pu1_label_vali.mat');
% x_train = pu1_data_train;
% y_train = pu1_label_train';
% x_test = pu1_data_test;
% y_test = pu1_label_test';
% x_vali = pu1_data_vali;
% y_vali = pu1_label_vali;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  PU2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('E:\研究生\代码整理及fig文件\data\pu2_data_train.mat');
% load('E:\研究生\代码整理及fig文件\data\pu2_data_test.mat');
% load('E:\研究生\代码整理及fig文件\data\pu2_label_train.mat');
% load('E:\研究生\代码整理及fig文件\data\pu2_label_test.mat');
% load('E:\研究生\代码整理及fig文件\data\pu2_data_vali.mat');
% load('E:\研究生\代码整理及fig文件\data\pu2_label_vali.mat');
% x_train = pu2_data_train;
% y_train = pu2_label_train';
% x_test = pu2_data_test;
% y_test = pu2_label_test';
% x_vali = pu2_data_vali;
% y_vali = pu2_label_vali;
%% %%%%%%%%%%%%%%%%%%%%%%%%%% KKI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('E:\研究生\代码整理及fig文件\data\kki_data_train.mat');
% load('E:\研究生\代码整理及fig文件\data\kki_data_test.mat');
% load('E:\研究生\代码整理及fig文件\data\kki_label_train.mat');
% load('E:\研究生\代码整理及fig文件\data\kki_label_test.mat');
% load('E:\研究生\代码整理及fig文件\data\kki_data_vali.mat');
% load('E:\研究生\代码整理及fig文件\data\kki_label_vali.mat');
% x_train = kki_data_train;
% y_train = kki_label_train';
% x_test = kki_data_test;
% y_test = kki_label_test';
% x_vali = kki_data_vali;
% y_vali = kki_label_vali;
%% %%%%%%%%%%%%%%%%%%%%%%%%  189 PU-2  %%%%%%%%%%%%%%%%%%%%%%%%%
% load('E:\研究生\代码整理及fig文件\new_data\rawdata\rawdata189.mat');
% load('E:\研究生\代码整理及fig文件\new_data\rawdata\label_189.mat');
% data = out_matrix_newnew;
% label = label3_new;
% data_struct = stratified_sample(data, label, 10);
% x_train = data_struct.train;
% y_train = data_struct.train_label;
% x_vali = data_struct.vali;
% y_vali = data_struct.vali_label;
% x_test = data_struct.test;
% y_test = data_struct.test_label;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 189+80
load('E:\研究生\代码整理及fig文件\new_data\rawdata\rawdata189.mat');
load('E:\研究生\代码整理及fig文件\new_data\rawdata\label_189.mat');
load('E:\研究生\代码整理及fig文件\new_data\rawdata\rawdata80.mat');
load('E:\研究生\代码整理及fig文件\new_data\rawdata\label_80.mat');
size_189 = size(out_matrix_newnew, 2);
new_matrix = [out_matrix,zeros(80, size_189-size(out_matrix,2))];
data = [out_matrix_newnew;new_matrix];
label = [label3_new;label_vector1];
data_struct = stratified_sample(data, label, 14);
x_train = data_struct.train;
y_train = data_struct.train_label;
x_vali = data_struct.vali;
y_vali = data_struct.vali_label;
x_test = data_struct.test;
y_test = data_struct.test_label;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
struct1 = new_model_2(x_train,y_train,x_vali,y_vali);
struct2 = validate_test(struct1,x_test,y_test);
