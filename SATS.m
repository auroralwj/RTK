function[CEPL95,CEPH95] =SATS(m,CEPL,CEPH,st)
% ����CEP95ֵ����ͼ��������Ч��������DOOPֵ���������

cepl = sort(CEPL);
ceph = sort(CEPH);
CEPL95 = cepl(floor(m*0.95));
CEPH95 = ceph(floor(m*0.95));
figure(1)
plot(st,'black')

figure(2)
plot(dx,'.blue')
hold on;
plot(dy,'.green')
hold on;
plot(dz,'.red')

figure (3)
subplot 311     % ����ͼ����ֳ�3��1�У�dx����t�ĺ���ͼ���ڵ����е�һ��
plot(dx,'.r');
subplot 312     % ����ͼ����ֳ�3��1�У�dy����t�ĺ���ͼ���ڵ����еڶ���
plot(dy,'.b');
subplot  313    % ����ͼ����ֳ�3��1�У�dz����t�ĺ���ͼ���ڵ����е�����
plot(dz,'.y');

figure (4)
subplot 211     % ����ͼ����ֳ�3��1�У�dx����t�ĺ���ͼ���ڵ����е�һ��
plot(da1,'.r');
subplot 212     % ����ͼ����ֳ�3��1�У�dy����t�ĺ���ͼ���ڵ����еڶ���
plot(da2,'.r');


end