function struct = validate_test(struct1, test, test_label)
w = struct1.w;
NofSampleP = size(w,1);
b = struct1.b;
X1 = struct1.skyline(1,:);
Y1 = struct1.skyline(2,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%  测试集  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %导入测试数据
x_test = test;
Y = test_label;
[shape0,shape1] = size(x_test);   %#ok<*ASGLU> % 30是测试集数的行数
for j=1:NofSampleP
% index = train_mcc == min(train_mcc);
y_test(j,:)=x_test*w(j,:)'+b(j);
for i=1:shape0
    if y_test(j,i)>=0  
        y_test(j,i)=1;
    else 
        y_test(j,i)=-1;
    end
end

% 统计错误率,灵敏度和特异度
tp=0;
fp=0;
tn=0;
fn=0;

for i=1:shape0
    if Y(i)==1&&y_test(j,i)==1 %真阳性(病人正分个数)
        tp=tp+1;
    end
    if Y(i)==-1&&y_test(j,i)==1 %假阳性
        fp=fp+1;
    end
    if Y(i)==-1&&y_test(j,i)==-1 %真阴性（正常人正分个数）
        tn=tn+1;
    end
    if Y(i)==1&&y_test(j,i)==-1 %假阴性
        fn=fn+1;
    end   
%     if Y(i)==1&&y_test(j,i)==-1 %假阴性
%         tn = tn+1;
%     end 
%     if Y(i)==-1&&y_test(j,i)==-1 %真阴性（正常人正分个数）
%         fn = fn+1;
%     end
end

Test_error(j)=(fp+fn)/shape0*100;
test_sen(j)= tp/( tp+fn)*100;
test_spe(j)=tn/(tn+ fp)*100;
test_acc(j)=(tp+tn)/(tp+fp+tn+fn)*100;
test_mcc(j)= (tp*tn-fp*fn)/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
test_gmeans(j)= sqrt(tp/(tp+fn)*tn/(tn+fp));
end

Test_errornew = zeros(1,NofSampleP);
for i=NofSampleP:-1:1
    Test_errornew(1,NofSampleP+1-i) =Test_error(i);
end

%%%%%%%%%%%%%%%%%%%%%%  测试集画图  %%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on
hx = plot(X1,Test_error, 'k-.^');

% legend('test\_error');
h = legend('validation\_error', 'train\_error', 'test\_error','$$\sum {{\xi_i}}$$');
set(h,'Interpreter','latex')
set(gca,'linewidth', 2);
set(h,'Fontsize',15);
% hold on 
% plot(X1, test_mcc*100, 'y-v')
struct.train_error = struct1.train_error;
struct.train_sen = struct1.train_sen;
struct.train_spe = struct1.train_spe;
struct.train_acc = struct1.train_acc;
struct.train_mcc = struct1.train_mcc;
% struct.train_gmeans = struct1.train_gmeans;
struct.test_error = Test_error;
struct.test_sen = test_sen;
struct.test_spe = test_spe;
struct.test_acc = test_acc;
struct.test_mcc = test_mcc;
struct.train_gmeans = test_gmeans;
struct.y_test = y_test;
struct.skyline = [X1;Y1];
end