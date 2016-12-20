function [X_train,X_test,Y_train,Y_test]=prepare_data_scene()

%%Scene dataset contains 6 labels 'beach, sunset ,fall foliage, field, mountain, urban'
%%Some of these training data may contain two labels 

    [y_train, x_train, map_train] = read_multilabel('../datasets/scene/scene_train');
    [y_test, x_test, map_test] = read_multilabel('../datasets/scene/scene_test');
    
    nb_labels=length(map_train);
    
    x_train=full(x_train);
    y_train=full(y_train);
    x_test=full(x_test);
    y_test=full(y_test);
    
    for i=1:nb_labels
        [X_train{i},Y_train{i}]=create_task_i(x_train,y_train,i);
        [X_test{i},Y_test{i}]=create_task_i(x_test,y_test,i);
    end
    
    
end

function [train_i,labels_i]=create_task_i(x_train,y_train,i)

    positif_datapoints=x_train(y_train(:,i)==1,:);
    nb_positifs=size(positif_datapoints,1);
    
    negatif_datapoints=x_train(y_train(:,i)~=1,:);
    tmp=randperm(length(negatif_datapoints));
    negatif_datapoints=negatif_datapoints(tmp(1:nb_positifs),:);
    
    train_i=[positif_datapoints;negatif_datapoints];
    labels_i=[ones(nb_positifs,1);zeros(nb_positifs,1)];
    
    tmp=randperm(2*nb_positifs);
    
    train_i=train_i(tmp,:)';
    labels_i=labels_i(tmp,:);  
    
end