load('E:\研究生\代码整理及fig文件\new_data\rawdata\rawdata189.mat');
data = out_matrix_newnew;
[pc,score,latent,tsquare] = pca(data);
information = cumsum(latent)./sum(latent);
figure()
h1x = plot(information, 'r');


load('E:\研究生\代码整理及fig文件\new_data\rawdata\rawdata80.mat');
data = out_matrix;
[pc,score,latent,tsquare] = pca(data);
information = cumsum(latent)./sum(latent);
hold on 
h2x = plot(information, 'g');


load('E:\研究生\代码整理及fig文件\new_data\rawdata\rawdata85.mat');
data = out_matrix_new;
[pc,score,latent,tsquare] = pca(data);
information = cumsum(latent)./sum(latent);
hold on 
h2x = plot(information, 'b');

size_189 = size(out_matrix_newnew, 2);
new_matrix = [out_matrix,zeros(80, size_189-size(out_matrix,2))];
data = [out_matrix_newnew;new_matrix];
[pc,score,latent,tsquare] = pca(data);
information = cumsum(latent)./sum(latent);

hold on
h3x = plot(information, 'k');

h = legend('189', '80','85', '189+80');
set(h,'Fontsize',15);


% [mappedA_pca, mapping_pca] = compute_mapping(data, 'PCA');
% [mappedA_pca, mapping_pca] = compute_mapping(data, 'Isomap');
% [mappedA_pca, mapping_pca] = compute_mapping(data, 'LLE');