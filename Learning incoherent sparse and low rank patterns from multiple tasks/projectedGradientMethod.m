function [T,errors]=projectedGradientMethod(x_train,y_train,max_iter,lambda)
    nb_features=size(x_train{1},1);
    nb_tasks=size(x_train,2);
    size_s=[nb_features,nb_tasks];
    TP0=zeros(size_s);
    TQ0=zeros(size_s);
    L0=1;
    T0{1}=TP0;
    T0{2}=TQ0;
    slack=0.00001;
    rnk_cns=0.2;
    T1=T0;
    tmines1=0;
    t0=1;
    errors(1)=calculate_F(x_train,y_train,lambda,T0);
    for i=1:max_iter
        if mod(i,500)==0
            display([int2str(i),'/',int2str(maxiter)])
        end
        alpha_i=(tmines1-1)/t0;
        S{1}=(1+alpha_i)*T1{1}-alpha_i*T0{1};
        S{2}=(1+alpha_i)*T1{2}-alpha_i*T0{2};
        diff_in_S=calculate_diff_S(x_train,y_train,size_s,S);
        while true 
            [new_T,diff_in_S]=optimise_T(S,diff_in_S,L0,lambda,rnk_cns);
            FT=calculate_FT(x_train,y_train,new_T);
            GL=calculateGL(x_train,y_train,diff_in_S,new_T,S,L0);
            if FT<=GL
                break
            else
                L0=L0*2;
            end
        end
        T0=T1;
        T1=new_T;
        errors(i+1)=calculate_F(x_train,y_train,lambda,T1);
        error_change=abs(errors(end-1)-errors(end));
        if error_change<slack
            break
        end
        tmines1=t0;
        t0 = ( 1 + ( 1+4*t0^2 )^0.5 ) / 2;
    end
    T=new_T;
end

function diff_in_S=calculate_diff_S(x_train,y_train,size_s,S)
    diff_in_S=zeros(size_s);
    for i=1:size_s(2)
        diff_in_S(:,i)=2*x_train{i}*x_train{i}'*(S{1}(:,i)+S{2}(:,i)) - 2*x_train{i}*y_train{i};
    end
end


function FT=calculate_FT(x_train,y_train,T)
    FT=0;
    for i=1:length(x_train)
        FT= FT+norm((T{1}(:,i)+T{2}(:,i))'*x_train{i}-y_train{i}')^2;
    end
%    FT=lsq+lambda*sum(sum(abs(T{1})));
end



function loss_err=calculate_F(x_train,y_train,lambda,T)

    loss_err=calculate_FT(x_train,y_train,T)+lambda*sum(abs(T{1}(:)));

end

function GL=calculateGL(x_train,y_train,diff_in_S,T,S,L0)
    first_term=calculate_FT(x_train,y_train,S);
    second_term=(-0.5/L0)*norm(diff_in_S,'fro')^2;
    third_term_tmp{1}=norm(T{1}-(S{1}-diff_in_S/L0),'fro')^2;
    third_term_tmp{2}=norm(T{2}-(S{2}-diff_in_S/L0),'fro')^2;
    third_term=0.5*L0*(third_term_tmp{1}+third_term_tmp{2});
    GL=first_term+second_term+third_term;
end