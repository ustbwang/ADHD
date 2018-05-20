function [train_X, train_Y, test_X, test_Y] = data_split(data_X, data_Y, train_portion, seed)
rand('state',seed)
data_merge = [data_X data_Y];


data_posive = data_merge(data_merge(:,end)==1, :);
data_negetive = data_merge(data_merge(:,end)==-1, :);

data_posive_num = size(data_posive, 1);

shuffle_positive = randperm(data_posive_num);
shuffle_positive_train = data_posive(shuffle_positive(1: floor(data_posive_num*train_portion)), :);
shuffle_positive_test = data_posive(shuffle_positive(floor(data_posive_num*train_portion)+1:end), :);


data_negetive_num = size(data_negetive, 1);
shuffle_negetive = randperm(data_negetive_num);
shuffle_negetive_train = data_negetive(shuffle_negetive(1: floor(data_negetive_num*train_portion)), :);
shuffle_negetive_test = data_negetive(shuffle_negetive(floor(data_negetive_num*train_portion)+1:end), :);


data_train = [shuffle_positive_train; shuffle_negetive_train];
train_X = data_train(:, 1:end-1);
train_Y = data_train(:, end);

data_test = [shuffle_positive_test; shuffle_negetive_test];
test_X = data_test(:, 1:end-1);
test_Y = data_test(:, end);

end