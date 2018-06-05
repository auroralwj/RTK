function[CEPL95,CEPH95] =SATS(dx,dy,dz,rtker,m,CEPL,CEPH,sat)
% ����CEP95ֵ����ͼ��������Ч��������DOOPֵ���������

cepl = sort(CEPL);
ceph = sort(CEPH);
CEPL95 = cepl(floor(m*0.95));
CEPH95 = ceph(floor(m*0.95));

%% ���ɼ�������
figure(1)
plot(sat,'.black');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('��Ԫ','Fontname','����','Fontsize',12);
ylabel('�ɼ�������','Fontname','����','Fontsize',12);

%% �������������
figure(2)
subplot 311 %ע������ͼ����ֳ�2��1�У�y1����t�ĺ���ͼ���ڵ�һ�е�һ��
plot(dx,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('��Ԫ','Fontname','����','Fontsize',12);
ylabel('x�����/m','Fontname','����','Fontsize',12)

subplot 312 %ע������ͼ����ֳ�2��1�У�y2����t�ĺ���ͼ���ڵڶ��е�һ��
plot(dy,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('��Ԫ','Fontname','����','Fontsize',12);
ylabel('y�����/m','Fontname','����','Fontsize',12);

subplot  313
plot(dz,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('��Ԫ','Fontname','����','Fontsize',12);
ylabel('z�����/m','Fontname','����','Fontsize',12);

%% ���̶�����������
figure(3)
subplot 311 %ע������ͼ����ֳ�2��1�У�y1����t�ĺ���ͼ���ڵ�һ�е�һ��
plot(rtker.dxc,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('��Ԫ','Fontname','����','Fontsize',12);
ylabel('x�����/m','Fontname','����','Fontsize',12)

subplot 312 %ע������ͼ����ֳ�2��1�У�y2����t�ĺ���ͼ���ڵڶ��е�һ��
plot(rtker.dyc,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('��Ԫ','Fontname','����','Fontsize',12);
ylabel('y�����/m','Fontname','����','Fontsize',12);

subplot  313
plot(rtker.dzc,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('��Ԫ','Fontname','����','Fontsize',12);
ylabel('z�����/m','Fontname','����','Fontsize',12);



%% ���CEP95ֵ

fprintf('CEPH95Ϊ%.8f\n',CEPL95);
fprintf('CEPH95Ϊ%.8f\n',CEPH95);

end