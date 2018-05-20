function [struct] = stratified_sample(data, label, seed)
%%   按照训练 验证 测试 6:2:2来分
train_rate = 0.6;
vali_rate = 0.2 / (1-train_rate);
test_vali = 0.2 / (1-train_rate);

an1=find(label==-1);                   
an2=find(label==1);

[m1, n1]=size(data(an1));             % 这个data不包括Label
[m2, n2]=size(data(an2));

train_p = randchoose(an1, ceil(m1*train_rate), seed);
train_n = randchoose(an2, ceil(m2*train_rate), seed);
struct.train = data([train_p;train_n],:);
struct.train_label = label([train_p;train_n]);

data([train_p;train_n],:)=[];
label([train_p;train_n])=[];

an1=find(label==-1);                   
an2=find(label==1);

[m1, n1]=size(data(an1));             % 这个data不包括Label
[m2, n2]=size(data(an2));
vali_p = randchoose(an1, ceil(m1*vali_rate), seed);
vali_n = randchoose(an2, ceil(m2*vali_rate), seed);
struct.vali = data([vali_p;vali_n],:);
struct.vali_label = label([vali_p;vali_n]);

data([vali_p;vali_n],:)=[];
label([vali_p;vali_n])=[];
struct.test = data;
struct.test_label = label;







end