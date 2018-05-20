function [] = bar_plot(struct, style)
    %%%%%%%%%%%%%%%%%    错误率,灵敏度和特异度   %%%%%%%%%%%%
    if style == 'pu1'
        location = {'(1.21,9.06)', '(1.46,6.46)','(1.61,5.16)', '(1.78,3.87)'};
        index = [3,4,5,7];
    end
    if style == 'pu2'
        location = { '(1.95, 22.45)', '(2.20,17.95)', '(2.45,13.45)','(2.73,8.96)'};
        index = [2,3,4,5];
    end
    if style == 'kki'
        location = {'(2.89, 21.57)', '(3.61,19.97)', '(6.65, 13.64)', '(7.57, 12.18)'};
        index = [10,11,15,16];
%         axis([0 100 0 1000])
    end
    
    figure;
    struct.train_sen
    struct.train_spe
    struct.train_acc
    %%%%%%%%%%%%%%%%%    敏感度   %%%%%%%%%%%%%%%%%%%%%%%%
    subplot(1,3,1);
    x = struct.skyline(1,:);
    p1=plot(x,struct.train_sen,'r-o');      % 敏感度蓝色 蓝色 
    hold on
    p2 = plot(x,struct.test_sen,'b-o');
    legend('train\_sen','test\_sen','location', 'northeast');
    %%%%%%%%%%%%%%%%%%    特异度   %%%%%%%%%%%%%%%%%%%%%%%%
    subplot(1,3,2);
    x = struct.skyline(1,:);
    p3=plot(x,struct.train_spe,'r-o');      % 敏感度蓝色 蓝色 
    hold on
    p4 = plot(x,struct.test_spe,'b-o');
    legend('train\_spe','test\_spe','location', 'northeast');
    %%%%%%%%%%%%%%%%%%    准确度   %%%%%%%%%%%%%%%%%%%%%%%%
    subplot(1,3,3);
    x = struct.skyline(1,:);
    p5=plot(x,struct.train_acc,'r-o');      % 敏感度蓝色 蓝色 
    hold on
    p6 = plot(x,struct.test_acc,'b-o');
    legend('train\_acc','test\_acc','location', 'northeast');
    %%%%%%%%%%%%%%%%%%%%%%%%  柱状图  %%%%%%%%%%%%%%%%%%%%%%%%
    figure;
%     subplot(1,3,1);
    x = struct.skyline(1,:);

    x1 = x(:,index)';
    y1 = struct.train_sen(:,index)';
    y2 = struct.test_sen(:,index)';
    y = [y1, y2];
    z = x1';
    bar([10 20 30 40], y)
    set(gca,'XTickLabel', location)
    legend('train\_sen','test\_sen','location', 'northeast');
    set(gca, 'FontSize', 15)

    figure;
%     subplot(1,3,2);
    y1 = struct.train_spe(:,index)';
    y2 = struct.test_spe(:,index)';
    y = [y1, y2];
    z = x1';
    bar([10 20 30 40], y)
    set(gca,'XTickLabel', location)
    legend('train\_spe','test\_spe','location', 'northeast');
    set(gca, 'FontSize', 15)

     figure;
%     subplot(1,3,3);
    y1 = struct.train_acc(:,index)';
    y2 = struct.test_acc(:,index)';
    y = [y1, y2];
    z = x1';
    bar([10 20 30 40], y)
    set(gca,'XTickLabel', location)
    legend('train\_acc','test\_acc','location', 'northeast');
    set(gca, 'FontSize', 15)

    
    
    
end