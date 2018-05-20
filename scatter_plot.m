function scatter_plot(struct1, struct2)

x = struct1.x;
y = struct1.y;
z = struct1.z;
figure();
scatter3(x,y,struct1.vali_gmeans, 'filled');
title('valid-gmeans');
figure();
scatter3(x,y,struct1.vali_acc,'filled');
title('valid-acc');
figure();
scatter3(x,y,struct2.test_gmeans, 'filled');
title('test-gmeans');
figure();
scatter3(x,y,struct2.test_acc,'filled');
title('test-acc');

end