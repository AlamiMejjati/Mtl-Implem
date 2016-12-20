clear all 
close all
clc


dataname='face';

if strcmp(dataname,'school')
    index=1;
    [x_train,x_test,y_train,y_test]=prepare_data(index);
elseif strcmp(dataname,'face')
    %%else data face 
    [x_train,x_test,y_train,y_test]=prepare_data_ar_face();
elseif strcmp(dataname,'scene')
    [x_train,x_test,y_train,y_test]=prepare_data_scene();
end

max_iter=1000;
lambda=11;

[T,errors]=projectedGradientMethod(x_train,y_train,max_iter,lambda);



if ~strcmp(dataname,'school')
    
    y_pred_train_all=[];
    y_train_all=[];
    y_pred_test_all=[];
    y_test_all=[];
    
    for i=1:length(x_train)
        y_pred_train{i}=round(x_train{i}'*(T{1}(:,i)+T{2}(:,i)));
        y_pred_train_all=[y_pred_train_all;y_pred_train{i}];
        y_train_all=[y_train_all;y_train{i}];
    end
    for i=1:length(x_test)
        y_pred_test{i}=round(x_test{i}'*(T{1}(:,i)+T{2}(:,i)));
        y_pred_test_all=[y_pred_test_all;y_pred_test{i}];
        y_test_all=[y_test_all;y_test{i}];
    end
    
    [ micro_train, macro_train ] = micro_macro_PR( y_pred_train_all , y_train_all);
    [ micro_test, macro_test ] = micro_macro_PR( y_pred_test_all , y_test_all);

else
    for i=1:length(x_train)
        y_pred_train{i}=x_train{i}'*(T{1}(:,i)+T{2}(:,i));
    end
    for i=1:length(x_test)
        y_pred_test{i}=x_test{i}'*(T{1}(:,i)+T{2}(:,i));
    end
end


if ~strcmp(dataname,'school')
    train_error=get_accuracy(y_pred_train,y_train);
    test_error=get_accuracy(y_pred_test,y_test);

    fprintf('Final training error: %9.4f\n',train_error)
    fprintf('Final test error: %9.4f\n',test_error)
    
    fprintf('Final MacroF1 Test: %9.4f\n',macro_test.fscore*100)
    fprintf('Final MicroF1 Test: %9.4f\n',micro_test.fscore*100)
end


%% To see the feature extraction ability of the algorithm
if strcmp(dataname,'face')
    subplot(1,2,1)
    colormap(flipud(gray));
    imagesc(reshape(T{1}(:,1),82,60));
    subplot(1,2,2)
    colormap(flipud(gray));
    imagesc(reshape(T{2}(:,1),82,60));
end

