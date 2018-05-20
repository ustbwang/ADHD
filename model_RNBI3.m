function res = model_RNBI3(train, train_label, test, test_label)
%  % to solve the muti-objective problem
% %  u1=min sum(ksi(i)),i=1,..m
% %  u2=min sum(t(j)),t=1,..n
% % s.t.  y(i)*(w*x+b)>=1-ksi(i) <======>-y(i)*w*x-y(i)*b-ksi(i)<=-1
% %       w(j)-t(j)<=0,j=1,2,...n
% %     - w(j)-t(j)<=0,j=1,2,...n
% %       ksi(i)>=0,i=1,2,...,m
% %       x=[w;b;ksi;t]
% clear
% clc
% load('x_trainnew22.mat');
% load('label_vector2.mat');
% x_train=x_trainnew22(1:50,:);
% K=170;
% % 分类标签
% y_train=label_vector2(1:50,:);
% 
% P=[zeros(1,K),0,ones(1,50),zeros(1,K);
%    zeros(1,K),0,zeros(1,50),ones(1,K) ];
% B=sparse([[diag(y_train)*x_train,y_train,eye(50,50),zeros(50,K)];
%        [eye(K,K),zeros(K,51),eye(K,K)];
%       [-eye(K,K),zeros(K,51),eye(K,K)];
%       [zeros(50,K),zeros(50,1),eye(50,50),zeros(50,K)]]);
% b=[ones(50,1);zeros(2*K,1);zeros(50,1)];
% options=struct('info',2,'lp_solver',3,'eps',1e-2);
% [S,Sh]=bensolve(P,B,b,[],[],[],options);

% to solve the muti-objective problem
%  u1=min sum(ksi(i)),i=1,..m
%  u2=min sum(t(j)),t=1,..n
% s.t.  y(i)*(w*x+b)>=1-ksi(i) <======>-y(i)*w*x-y(i)*b-ksi(i)<=-1
%       w(j)-t(j)<=0,j=1,2,...n
%     - w(j)-t(j)<=0,j=1,2,...n
%       ksi(i)>=0,i=1,2,...,m
%       x=[w;b;ksi;t]

x_train = train;
[L, K] = size(x_train);

% 分类标签
y_train=train_label;
an1=find(y_train==0);

% 负样本是 0 还是 -1 要改过来
an2=find(y_train==1);
% 分类标签
% y_train1=ones(36,1);
% y_train2=-ones(14,1);
[m,n]=size(an1);
[p,q]=size(an2);
% for i=1:m
%     x_train1(i,:)=x_train(an1(i,1),:);
% end
% for i=1:p
%     x_train2(i,:)=x_train(an2(i,1),:);
% end

%%                  未分开写
positive = zeros(1, L);
negative = zeros(1, L);

positive(an2) = 1;
negative(an1) = 1;
%     W        B      ξ       t
P=[zeros(1,K), 0,  positive, zeros(1,K);   
   zeros(1,K), 0, negative, zeros(1,K);  
   zeros(1,K),0,zeros(1,L),ones(1,K)];

rep.B=sparse([[-diag(y_train)*x_train,-y_train,-eye(L,L),zeros(L,K)];
       [eye(K,K),zeros(K,L+1),-eye(K,K)];   
      [-eye(K,K),zeros(K,L+1),-eye(K,K)]]);   
 
rep.b=[-ones(L,1); zeros(2*K,1)];
rep.l=[-inf*ones(K+1,1);zeros(L,1);-inf*ones(K,1)];
rep.u=[inf*ones(K+1,1);inf*ones(L,1);inf*ones(K,1)];
S = polyh(rep, 'h');
[PP, DD, sol_p, sol_d]=molpsolve(P,S, 'min');
plot(PP)
% plot(DD)

[Allpoints2, Allpointsxvaule] = RNBI3D_copy(P, rep.B, rep.b, rep.l, rep.u);
%%
x = Allpoints2(:,1)';
y = Allpoints2(:,2)';
z = Allpoints2(:,3)';
% 
w=Allpointsxvaule(:,1:K);% NofSampleP*K矩阵

b=Allpointsxvaule(:,K+1);% 列向量
op=Allpointsxvaule(:,K+2:K+L+1);
OP=sum(op');        % OP是所有误差的和
W=sum(abs(w'));
TAR=Allpoints2;
% 求测试集分类标签

% 中间点个数
NofSampleP = size(w,1);

for j=1:NofSampleP
    Y_train(j,:)=x_train*w(j,:)'+b(j);
for i=1:L
    if Y_train(j,i)>0  
        Y_train(j,i)=1;
    else 
        Y_train(j,i)=-1;
    end
end
% Y_train是预测值，y_train是真实值
%统计错误率,灵敏度和特异度
fp_train=0;
tp_train=0;
fn_train=0;
tn_train=0;
%错误率
for i=1:L
    
    if y_train(i)==-1&&Y_train(j,i)==1 %假阳性
        fp_train=fp_train+1;
    end
    if Y_train(j,i)==1&&y_train(i)==1 %真阳性(病人正分个数)
        tp_train=tp_train+1;
    end
  
    if y_train(i)==1&&Y_train(j,i)==-1 %假阴性
        fn_train=fn_train+1;
    end 
    if Y_train(j,i)==-1&&y_train(i)==-1 %真阴性（正常人正分个数）
        tn_train=tn_train+1;
    end

end

train_error(j)=(fp_train+fn_train)/L*100;
train_sen(j)= tp_train/( tp_train+fn_train)*100;
 train_spe(j)=tn_train/(tn_train+ fp_train)*100;
 train_acc(j)=(tp_train+tn_train)/(tp_train+fp_train+tn_train+fn_train)*100;
 train_mcc(j)= (tp_train*tn_train-fp_train*fn_train)/sqrt((tp_train+fp_train)*(tp_train+fn_train)*(tn_train+fp_train)*(tn_train+fn_train));
 train_gmeans(j)= sqrt(tp_train/(tp_train+fn_train)*tn_train/(tn_train+fp_train));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%  测试集  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %导入测试数据
x_test = test;
Y = test_label;
[shape0,shape1] = size(x_test);   %#ok<*ASGLU> % 30是测试集数的行数
for j=1:NofSampleP
% index = train_mcc == min(train_mcc);
%  此处 y_test 的是我们的结果 
y_test(j,:)=x_test*w(j,:)'+b(j);
for i=1:shape0
    if y_test(j,i)>0  
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
end

Test_error(j)=(fp+fn)/shape0;
test_sen(j)= tp/( tp+fn);
test_spe(j)=tn/(tn+ fp);
test_acc(j)=(tp+tn)/(tp+fp+tn+fn);
test_mcc(j)= (tp*tn-fp*fn)/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
test_gmeans(j)= sqrt(tp/(tp+fn)*tn/(tn+fp));
end

Test_errornew = zeros(1,NofSampleP);
for i=NofSampleP:-1:1
    Test_errornew(1,NofSampleP+1-i) =Test_error(i);
end

%%%%%%%%%%%%%%%%%%%%%%  误差画图  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
X1=W;
Y1=OP;       % 非劣点集

% hold on
% hx1 = plot(X1,train_gmeans, 'b:p');       % 验证集


% grid on;
% hold on 
% [hAx,hLine1,hLine2] = plotyy(X1,test_gmeans,X1,train_gmeans);   % skyline  训练误差
% hLine1.LineStyle = '-';
% hLine1.Marker = 's';
% hLine1.Color = 'k';
% 
% hLine2.LineStyle = '--';
% hLine2.Marker = '*';
% hLine1.Color = 'b';
% 
% set(hAx,'GridLineStyle',':','GridColor','m','GridAlpha',0.6);
% set(get(hAx(1),'ylabel'),'string', 'train_gmeans', 'FontSize', 15);
% set(get(hAx(2),'ylabel'),'string', 'test_gmeans',' FontSize', 15);
% xlabel('${\sum {|{w_i}|}} $ ','interpreter','latex', 'FontSize', 15);
% set(gca,'FontSize',15);
% h = legend('validation\_error', '$$\sum {{\xi _i}}$$','train\_error');
% set(h,'Interpreter','latex')
% set(h,'Fontsize',15);
% %%%%%%%%%%%%%%%%%%%%%%%%%% MCC画图  %%%%%%%%%%%%%%%%%%%%%%%%%%
% hold on 
% plot(X1, train_mcc*100, 'c-v')
% hold on 
% plot(X1, test_mcc*100, 'g-v')
%%%%%%%%%%%%%%%%%%%%%%%%%% 找出训练集最好的非劣点 %%%%%%%%%%%%%%%%%%%%%%%
struct.train_error = train_error;
struct.train_sen = train_sen;
struct.train_spe = train_spe;
struct.train_acc = train_acc;
struct.train_mcc = train_mcc;
struct.train_gmeans = train_gmeans;
struct.vali_error = Test_error;
struct.vali_sen = test_sen;
struct.vali_spe = test_spe;
struct.vali_acc = test_acc;
struct.vali_mcc = test_mcc;
struct.vali_gmeans = test_gmeans;
struct.y_train = Y_train;
struct.y_test = y_test;
struct.skyline = [X1;Y1];
struct.w = w;
struct.b = b;
struct.x = x;
struct.y = y;
struct.z = z;

res_index = (train_gmeans == max(train_gmeans));
nnn = size(res_index, 2);

res.gmeans =  test_gmeans(res_index(nnn));
res.acc =  test_acc(res_index(nnn));
end















