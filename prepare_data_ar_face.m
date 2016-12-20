function [x_train,x_test,y_train,y_test]=prepare_data_ar_face()

path_im='../datasets/AR_warp_zip/M-';
nb_tasks=50;

for i=1:nb_tasks
    [x_task_i,y_task_i]=prepare_task_i(path_im,i,nb_tasks);
    shuffling_order=randperm(length(y_task_i));
    x_train{i}=double((x_task_i(shuffling_order,:))');
    y_train{i}=double(y_task_i(shuffling_order,:));
end
x_test=x_train;
y_test=y_train;
end

function [x_task_i,y_task_i]=prepare_task_i(path_im,i,nb_tasks)
    nb_image_per_person=26;
    x_task_i=[];
    y_task_i=[];
    list_tasks=randperm(nb_tasks);
    list_tasks(list_tasks==i)=[];
    for j=1:nb_image_per_person
       im_loc=[path_im,sprintf('%.3d', i),'-',sprintf('%.2d', j),'.bmp'];
       im_loc_bis=[path_im,sprintf('%.3d', list_tasks(randi(numel(list_tasks)))),'-',sprintf('%.2d', j),'.bmp'];
       im = im_flat(im_loc);
       im_bis = im_flat(im_loc_bis);
       x_task_i=[x_task_i;im;im_bis];
       y_task_i=[y_task_i;1;0];  
    end
end


function im = im_flat(im_loc)
       im=imread(im_loc);
       im = rgb2gray(im);
       im=imresize(im,[floor(size(im,1)/2),floor(size(im,2)/2)]);
       im=reshape(im,1,size(im,1)*size(im,2));
end