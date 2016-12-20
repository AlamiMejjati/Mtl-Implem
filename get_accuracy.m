function accuracy=get_accuracy(y_pred_train,y_train)
    
    total=0;
    nb_errors=0;
    for i = 1:length(y_pred_train)
        total=total+length(y_pred_train{i});
        nb_errors=nb_errors+sum(abs(y_train{i}-y_pred_train{i}));
    end

    accuracy=nb_errors/total;
end