function  cc = svm_model(x_train, y_train, x_test, y_test)
SVMModel = fitcsvm(x_train, y_train);
[prob1,score] = predict(SVMModel, x_test);


[C,order] = confusionmat(y_test, prob1)
if order==[0;1]
    tp = C(1);
    tn = C(4);
    fp = C(2);
    fn = C(3);
end
if order==[0;-1]
    tn = C(1);
    tp = C(4);
    fn = C(2);
    fp = C(3);
end

cc.test_acc = (tp+tn)/(tp+fp+tn+fn);
cc.test_mcc = (tp*tn-fp*fn)/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
cc.test_gmeans = sqrt(tp/(tp+fn)*tn/(tn+fp));

cc.test_sen= tp/( tp+fn);
cc.test_spe=tn/(tn+ fp);

end