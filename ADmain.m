
%% ��ȡcutbվWGS-84����
[S,xb,yb,zb,correct1]= rtkmain(12);
%% ��ȡ��׼�Ƕ�
x0 = [-2364337.4414;4870285.6211;-3360809.6724];   %cut0����
x1 = [-2364333.5346;4870287.3393;-3360809.5251];   %cutb����
x2 = [-2364335.4220;4870281.4604;-3360816.7056];   %cuta����
[a10,a20]=datum(x0,x1,S);
s1=[1,0,0;0,cos(a20),sin(a20);0,-sin(a20),cos(a20)];
s2=[cos(a10),sin(a10),0;-sin(a10),cos(a10),0;0,0,1];
x2_LLSLLS =s1*s2*S*(x2-x0);
a30 = -atan(x2_LLSLLS(3)/x2_LLSLLS(1));
%% ��ȡ�����a10��������a20���Ƕ�
for m1=1:correct1
    x1L=[xb(m1);yb(m1);zb(m1)];
    [a11,a21]=datum(x0,x1L,S);
    a1(m1)=a11; %��ȡ�ĺ����
    a2(m1)=a21; %��ȡ�ĸ�����
    da1(m1)=a1(m1)-a10;
    da2(m1)=a2(m1)-a20;
end

%% ��ȡcutaվWGS-84����
[S,xa,ya,za,correct2]= rtkmain(13);
%% ��ȡ�����a30���Ƕ�
for m2=1:correct2
    x2L=[xa(m2);ya(m2);za(m2)];
    s1=[1,0,0;0,cos(a2(m2)),sin(a2(m2));0,-sin(a2(m2)),cos(a2(m2))];
    s2=[cos(a10),sin(a1(m2)),0;-sin(a1(m2)),cos(a1(m2)),0;0,0,1];
    x2_LLSLLS =s1*s2*S*(x2L-x0);
    a3(m2) = -atan(x2_LLSLLS(3)/x2_LLSLLS(1));
    da3(m2)=a3(m2)-a30;
end

[DA1CEP95,DA2CEP95,DA3CEP95] = ADSATS(da1,da2,correct1,da3,correct2);


