function[CEPL95,CEPH95] =SATS(DOUBLESYS,sys,totalpos,Corrpos,x1,S,sat)
% ����CEP95ֵ����ͼ��������Ч��������DOOPֵ���������

%--- ��ȡ���--%
dx = totalpos.x-x1(1);
dy = totalpos.y-x1(2);
dz = totalpos.z-x1(3);

rtker.dxc = Corrpos.xc-x1(1);
rtker.dyc = Corrpos.yc-x1(2);
rtker.dzc = Corrpos.zc-x1(3);
%-----��ȡCEP95(�̶����)----%
for m =1:length(rtker.dxc)
    env=S*[rtker.dxc(m);rtker.dyc(m);rtker.dzc(m)];
    CEPL(m) = sqrt(env(1)^2+env(2)^2) ;
    CEPH(m) = env(3);
end
cepl = sort(CEPL);
ceph = sort(CEPH);
CEPL95 = cepl(floor(m*0.95));
CEPH95 = ceph(floor(m*0.95));
fprintf('CEPH95Ϊ%.8fm\n',CEPL95);
fprintf('CEPH95Ϊ%.8fm\n',CEPH95);

%% �������������
figure(1)
subplot 311 %ע������ͼ����ֳ�2��1�У�y1����t�ĺ���ͼ���ڵ�һ�е�һ��
plot(dx,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('��Ԫ','Fontname','����','Fontsize',14);
ylabel('x�����/m','Fontname','����','Fontsize',14)

subplot 312 %ע������ͼ����ֳ�2��1�У�y2����t�ĺ���ͼ���ڵڶ��е�һ��
plot(dy,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('��Ԫ','Fontname','����','Fontsize',14);
ylabel('y�����/m','Fontname','����','Fontsize',14);

subplot  313
plot(dz,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('��Ԫ','Fontname','����','Fontsize',14);
ylabel('z�����/m','Fontname','����','Fontsize',14);

%% ���̶�����������
figure(2)
subplot 311 %ע������ͼ����ֳ�2��1�У�y1����t�ĺ���ͼ���ڵ�һ�е�һ��
plot(rtker.dxc,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('��Ԫ','Fontname','����','Fontsize',14);
ylabel('x�����/m','Fontname','����','Fontsize',14)

subplot 312 %ע������ͼ����ֳ�2��1�У�y2����t�ĺ���ͼ���ڵڶ��е�һ��
plot(rtker.dyc,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('��Ԫ','Fontname','����','Fontsize',14);
ylabel('y�����/m','Fontname','����','Fontsize',14);

subplot  313
plot(rtker.dzc,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('��Ԫ','Fontname','����','Fontsize',14);
ylabel('z�����/m','Fontname','����','Fontsize',14);

if (DOUBLESYS==1)
    %% ����ϵͳ�ɼ�������
    if (sys==1)
        figure(3)
        plot(sat,'.black');
        set(0,'defaultfigurecolor','w')
        set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
        xlabel('��Ԫ','Fontname','����','Fontsize',14);
        ylabel('GPS�ɼ�������','Fontname','����','Fontsize',14);
    else
        figure(3)
        plot(sat,'.black');
        set(0,'defaultfigurecolor','w')
        set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
        xlabel('��Ԫ','Fontname','����','Fontsize',14);
        ylabel('�����ɼ�������','Fontname','����','Fontsize',14);
    end
else
    %% ��˫ϵͳ�ɼ�������
    figure(3)
    plot(sat.stG,'.black');
    set(0,'defaultfigurecolor','w')
    set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
    xlabel('��Ԫ','Fontname','����','Fontsize',14);
    ylabel('GPS�ɼ�������','Fontname','����','Fontsize',14);
    figure(4)
    plot(sat.stC,'.black');
    set(0,'defaultfigurecolor','w')
    set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
    xlabel('��Ԫ','Fontname','����','Fontsize',14);
    ylabel('�����ɼ�������','Fontname','����','Fontsize',14);
end
end