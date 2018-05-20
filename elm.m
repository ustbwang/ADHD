%% 极限学习机在分类问题中的应用研究
clear all
clc
%%
load('E:\研究生\代码整理及fig文件\new_data\rawdata\rawdata189.mat');
load('E:\研究生\代码整理及fig文件\new_data\rawdata\label_189.mat');
data189 = out_matrix_newnew;
data189_label = label3_new;
load('E:\研究生\代码整理及fig文件\new_data\rawdata\rawdata80.mat');
load('E:\研究生\代码整理及fig文件\new_data\rawdata\label_80.mat');
data80 = out_matrix;
data80_label = label_vector1;
load('E:\研究生\代码整理及fig文件\new_data\rawdata\rawdata85.mat');
load('E:\研究生\代码整理及fig文件\new_data\rawdata\label_85.mat');
data85 = out_matrix_new;
data85_label = label_vector2;

size_189 = size(out_matrix_newnew, 2);
new_matrix = [out_matrix,zeros(80, size_189-size(out_matrix,2))];
data189_80 = [out_matrix_newnew;new_matrix];
data189_80_label = [label3_new;label_vector1];

%% 随机产生训练集/测试集
data_struct = stratified_sample(data189_80, data189_80_label, 10);
x_train = data_struct.train';
y_train = data_struct.train_label';
x_vali = data_struct.vali';
y_vali = data_struct.vali_label';
x_test = data_struct.test';
y_test = data_struct.test_label';

x_train = (x_train+ones(size(x_train)))./2;
y_train = (y_train+ones(size(y_train)))./2+1;

x_vali = (x_vali+ones(size(x_vali)))./2;
y_vali = (y_vali+ones(size(y_vali)))./2+1;

x_test = (x_test+ones(size(x_test)))./2;
y_test = (y_test+ones(size(y_test)))./2+1;

tic
%% ELM创建/训练
[IW,B,LW,TF,TYPE] = elmtrain(x_train,y_train,180,'sig',1);

%% ELM仿真测试
vali = elmpredict(x_vali,IW,B,LW,TF,TYPE);
test = elmpredict(x_test,IW,B,LW,TF,TYPE);
%%
[C,order] = confusionmat(y_test, test)
if order==[1;2]
    tp = C(1);
    tn = C(4);
    fp = C(2);
    fn = C(3);
end
% if order==[1;2]
%     tn = C(1);
%     tp = C(4);
%     fn = C(2);
%     fp = C(3);
% end

test_acc = (tp+tn)/(tp+fp+tn+fn);
test_mcc = (tp*tn-fp*fn)/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
test_gmeans = sqrt(tp/(tp+fn)*tn/(tn+fp));

test_sen= tp/( tp+fn);
test_spe=tn/(tn+ fp);

toc


