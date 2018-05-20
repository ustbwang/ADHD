clear all;
% load('breast_cancer.mat') 

%%%%%%%%%%%%%%%%%%%%%%%%%  �ܹ���90������ N ��ѵ�����ĸ��� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         71 ��������  19 ��������
%      ������ѵ�������� 71*0.7=50  ������ѵ�������� 19*0.7= 13
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ���ݷָ� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% x_train = X;
% y_train =  Y;
% x_test =  tx;
% y_test =  ty;

%%                               2ά��ͼ 
% [pc,score,latent,tsquare] = pca(x_train);
% cumsum(latent)./sum(latent)
% feature_after_PCA1 = score(:,1:2);
% figure();
% x_axis = feature_after_PCA1(:,1);
% y_axis = feature_after_PCA1(:,2);
% index1 = find(Y==1);
% index2 = find(Y==-1);
% s1 = scatter(x_axis(index1), y_axis(index1));
% s1.MarkerEdgeColor = 'r';     % ��������ɫ
% s1.MarkerFaceColor = [0 0.5 0.5];
% hold on 
% s2 = scatter(x_axis(index2), y_axis(index2));
% s2.MarkerEdgeColor = 'b';    % ��������ɫ
% s2.MarkerFaceColor = [0 0.5 0.5];

%%                            3ά��ͼ
% feature_after_PCA2=score(:,1:3);
% figure();
% x_axis3 = feature_after_PCA2(:,1);
% y_axis3 = feature_after_PCA2(:,2);
% z_axis3 = feature_after_PCA2(:,3);
% s1 = scatter3(x_axis3(index1), y_axis3(index1), z_axis3(index1));
% s1.MarkerEdgeColor = 'r';     % ��������ɫ
% s1.MarkerFaceColor = [0 0.5 0.5];
% hold on 
% s2 = scatter3(x_axis(index2), y_axis(index2), z_axis3(index2));
% s2.MarkerEdgeColor = 'b';    % ��������ɫ
% s2.MarkerFaceColor = [0 0.5 0.5];

%%                            �������㷨
% SVMModel = fitcsvm(x_train, y_train);
% [prob1,score] = predict(SVMModel, x_test);
% [C,order] = confusionmat(y_test, prob1)
% accuracy = length(find(prob1 == y_test))/length(y_test)
%%                      KKI ���ݼ�
load('E:\�о���\��������fig�ļ�\data\kki_data_train.mat');
load('E:\�о���\��������fig�ļ�\data\kki_data_test.mat');
load('E:\�о���\��������fig�ļ�\data\kki_label_train.mat');
load('E:\�о���\��������fig�ļ�\data\kki_label_test.mat');
load('E:\�о���\��������fig�ļ�\data\kki_data_vali.mat');
load('E:\�о���\��������fig�ļ�\data\kki_label_vali.mat');
x_train = kki_data_train;
y_train = kki_label_train';
x_test = kki_data_test;
y_test = kki_label_test';
x_vali = kki_data_vali;
y_vali = kki_label_vali;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  PU1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('E:\�о���\��������fig�ļ�\data\pu1_data_train.mat');
% load('E:\�о���\��������fig�ļ�\data\pu1_data_test.mat');
% load('E:\�о���\��������fig�ļ�\data\pu1_label_train.mat');
% load('E:\�о���\��������fig�ļ�\data\pu1_label_test.mat');
% load('E:\�о���\��������fig�ļ�\data\pu1_data_vali.mat');
% load('E:\�о���\��������fig�ļ�\data\pu1_label_vali.mat');
% x_train = pu1_data_train;
% y_train = pu1_label_train';
% x_test = pu1_data_test;
% y_test = pu1_label_test';
% x_vali = pu1_data_vali;
% y_vali = pu1_label_vali;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  PU2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('E:\�о���\��������fig�ļ�\data\pu2_data_train.mat');
% load('E:\�о���\��������fig�ļ�\data\pu2_data_test.mat');
% load('E:\�о���\��������fig�ļ�\data\pu2_label_train.mat');
% load('E:\�о���\��������fig�ļ�\data\pu2_label_test.mat');
% load('E:\�о���\��������fig�ļ�\data\pu2_data_vali.mat');
% load('E:\�о���\��������fig�ļ�\data\pu2_label_vali.mat');
% x_train = pu2_data_train;
% y_train = pu2_label_train';
% x_test = pu2_data_test;
% y_test = pu2_label_test';
% x_vali = pu2_data_vali;
% y_vali = pu2_label_vali;
%% %%%%%%%%%%%%%%%%%%%%%%%%%  yeast3  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = load('wisconsin.dat');        %  0 1321       1 163    
[M,N]=size(data);
indices = crossvalind('Kfold', data(1:M,N),5); %10Ϊ������֤����
label = data(:, N);
cp = classperf(label);
acc = 0;
gmeans = 0;
for i = 1:5   %ʵ��ǽ���10��(������֤����)����10�ε�ƽ��ֵ��Ϊʵ������
    test = (indices == i);       %  ѵ���� ����
    train = ~test;   
    % ��ѵ�����Ͳ��Լ�����һ��   �����Ƕ��У���Ҫת������
    data_train = data(train, 1:N-1)';
    data_test = data(test, 1:N-1)';
    [x_train, ps]=mapstd(data_train,0,1);
    [x_test, ps]=mapstd(data_test,0,1);
    
    % ģ��
    class = model_RNBI3(x_train', label(train), x_test', label(test));
%     class = svm_model(x_train', label(train), x_test', label(test));    % class��Ԥ��Ľ�� 
% %     acc = acc+class.acc;
% %     gmeans = gmeans+class.gmeans;
end

% fprintf('-----The test_acc is %f \n', acc/5);
% fprintf('-----The test_gmeans is %f \n', gmeans/5);

%%

% load fisheriris
% indices = crossvalind('Kfold',species,10);
% cp = classperf(species); % initializes the CP object
% for i = 1:10
%     test = (indices == i); train = ~test;
%     class = classify(meas(test,3),meas(train,3),species(train));
%     % updates the CP object with the current classification results
%     classperf(cp,class,test)  
% end
% cp.CorrectRate % queries for the correct classification rate
%%                         �Լ����㷨


% struct1 = model_RNBI3(x_train, y_train, x_vali, y_vali);
% % struct2 = validate_model_RNBI3(struct1,x_test,y_test);
% 
% index = find(struct1.vali_gmeans == max(struct1.vali_gmeans));
% [C,order] = confusionmat(y_test, struct2.y_test(index(1),:))
% 
% fprintf('-----The test_acc is %f \n', struct2.test_acc(index(1)));
% fprintf('-----The test_mcc is %f \n', struct2.test_mcc(index(1)));
% fprintf('-----The test_gemans is %f \n', struct2.test_gmeans(index(1)));
% svm_model(x_train, y_train, x_test, y_test)
% scatter_plot(struct1, struct2)











