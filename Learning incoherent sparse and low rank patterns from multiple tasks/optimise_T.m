function [new_T,diff_in_S]=optimise_T(S,diff_in_S,L0,lambda,rnk_cns)

    T_P=calculate_TP(S,diff_in_S,lambda,L0);
    
    SQ_hat=S{2} - diff_in_S / L0;
    T_Q=calculate_TQ(SQ_hat,rnk_cns);  
    new_T{1}=T_P;
    new_T{2}=T_Q;
end

function T_Q=calculate_TQ(SQ_hat,rnk_cns)
    [U,SigmaS,V] = svd(SQ_hat,'econ');
    T_Q=optimize_Tq(U,V,SigmaS,rnk_cns);
end


function T_q=optimize_Tq(U,V,SigmaS,rnk_cns)

    H= 2*diag(ones([1,length(SigmaS)]));
    f= -2*diag(SigmaS);
    A=ones(1,length(SigmaS));
    to=rnk_cns;
    lb = zeros(length(SigmaS),1);
    options = optimoptions('quadprog',...
        'Algorithm','interior-point-convex','Display','off');

    [sol,fval,exitflag,output,lagrange] = quadprog(H,f,A,to,[],[],lb,[],[],options);
    sol_d=diag(sol);
    T_q=U*sol_d*V';
end

function T_P=calculate_TP(S,diff_in_S,lambda,L0)
    cst=lambda/L0;
    Sp=S{1}-diff_in_S/L0;
    
    Tp1 = Sp - cst; 
    Tp1( Tp1 <=cst) = 0;

    Tp2 = Sp + cst;
    Tp2(Tp2 >= cst) = 0;

T_P = Tp1 + Tp2;
end




    