function [x_train,x_test,y_train,y_test]=prepare_data(index)
    
    cv_name= ['school_',int2str(index),'_indexes.mat'];
    load(['..\datasets\school_splits\',cv_name]);
    load('..\datasets\school_splits\school_b.mat');
    
    nb_tasks=length(task_indexes);
    

    
    all_x_trainings=x(:,tr);
    all_x_tests=x(:,tst);
    
    all_y_trainings=y(tr',:);
    all_y_tests=y(tst',:);
    
    
    tr_indexes(end+1)=size(all_x_trainings,2);
    tst_indexes(end+1)=size(all_x_tests,2);
    
    for i =1:nb_tasks
        x_train{i}=all_x_trainings(1:end-1,tr_indexes(i):tr_indexes(i+1)-1);
        y_train{i}=all_y_trainings(tr_indexes(i):tr_indexes(i+1)-1,:);
        x_test{i}=all_x_tests(1:end-1,tst_indexes(i):tst_indexes(i+1)-1);
        y_test{i}=all_y_tests(tst_indexes(i):tst_indexes(i+1)-1,:);
    end
    
    
end