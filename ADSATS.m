function[DA1CEP95,DA2CEP95,DA3CEP95] =ADSATS(da1,da2,correct1,da3,correct2)
% ��̬���ͼ�Լ�����CEP95ֵ

cep1 = sort(da1);
cep2 = sort(da2);
cep3 = sort(da3);

%% ���da1��da2��da3��CEP95ֵ
DA1CEP95 = cep1(floor(correct1*0.95));
DA2CEP95 = cep2(floor(correct1*0.95));
DA3CEP95 = cep3(floor(correct2*0.95));

fprintf('���da1��CEP95ֵΪ%.8f\n',DA1CEP95);
fprintf('���da2��CEP95ֵΪ%.8f\n',DA2CEP95);
fprintf('���da3��CEP95ֵΪ%.8f\n',DA3CEP95);


%% ���̶�����������
figure(1)
subplot 311
plot(da1,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('��Ԫ','Fontname','����','Fontsize',12);
ylabel('��������/��','Fontname','����','Fontsize',12)

subplot 312 
plot(da2,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('��Ԫ','Fontname','����','Fontsize',14);
ylabel('���������/��','Fontname','����','Fontsize',14);

subplot  313
plot(da3,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('��Ԫ','Fontname','����','Fontsize',14);
ylabel('��������/��','Fontname','����','Fontsize',14);

figure(2)

plot(da1,'.r');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',12);
xlabel('��Ԫ','Fontname','����','Fontsize',12);
ylabel('��������/��','Fontname','����','Fontsize',12)

figure(3)
plot(da2,'.b');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('��Ԫ','Fontname','����','Fontsize',14);
ylabel('���������/��','Fontname','����','Fontsize',14);

figure(4)
plot(da3,'.y');
set(0,'defaultfigurecolor','w')
set(gca,'color','w','Fontname','Times New Roman','Fontsize',14);
xlabel('��Ԫ','Fontname','����','Fontsize',14);
ylabel('��������/��','Fontname','����','Fontsize',14);



end