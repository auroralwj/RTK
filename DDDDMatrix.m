function[MatrixDDD]=DDDDMatrix(singaldiff,satnum,maxnum)
% ˫Ƶ˫���

global   L1f L2f cs;

dnum=0;
lambda1 = cs/L1f;
lambda2 = cs/L2f;

H= zeros(2*(satnum-1),satnum-1+3) ;

Q = zeros(2*(satnum-1),2*(satnum-1)) ;
for id=1:(satnum-1)
    dnum=dnum+1;
    if(dnum==maxnum),dnum=dnum+1;end
    G(id,1)=-(singaldiff(dnum).Ix-singaldiff(maxnum).Ix);
    G(id,2)=-(singaldiff(dnum).Iy-singaldiff(maxnum).Iy);
    G(id,3)=-(singaldiff(dnum).Iz-singaldiff(maxnum).Iz);
    
    %%   ��ƵLAMBDA�㷨��˫�������������˫��۲�����
    P1(id,1)=singaldiff(dnum).PC1-singaldiff(maxnum).PC1;
    F1(id,1)=singaldiff(dnum).FC1-singaldiff(maxnum).FC1;
    P2(id,1)=singaldiff(dnum).PC2-singaldiff(maxnum).PC2;
    F2(id,1)=singaldiff(dnum).FC2-singaldiff(maxnum).FC2;
    
    for j=1:satnum-1
        if(id==j)
            Q(id,j) = 2*(singaldiff(dnum).pw+singaldiff(maxnum).pw);%α���Ȩ
            Q(satnum-1+id,satnum-1+j) = 2*(singaldiff(dnum).fw+singaldiff(maxnum).fw);%�ز���λ
        else
            Q(id,j) = 2*singaldiff(maxnum).pw;%α���Ȩ
            Q(satnum-1+id,satnum-1+j) = 2*singaldiff(maxnum).fw;%�ز���λ
        end
    end
end
     MatrixDDD.G  = G;
     MatrixDDD.P1 = P1;
     MatrixDDD.F1 = F1;
     MatrixDDD.P2 = P2;
     MatrixDDD.F2 = F2;
     MatrixDDD.Q  = Q;
     MatrixDDD.num = satnum-1;
     MatrixDDD.lambda1 = lambda1;
     MatrixDDD.lambda2 = lambda2;
     


end
