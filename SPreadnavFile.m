function[navdata,gpsnav]=SPreadnavFile(navfilepath)
% ���㶨λ��ȡ�����ļ�

fid      = fopen(navfilepath);%�򿪵����ļ���1680.14p'
gpsnav = 0; %�����ļ��е������ܸ���
navdata = NaN; %�����ļ���ȡ������Ϊ��
%% ����ͷ�ļ�
while ~feof(fid)                                                           %feof��δ��������0ֵ
    line = fgetl(fid);
    if strcmp(line(61:73),'END OF HEADER'),break;end %% �����ļ�ͷ
end
%%���ж�ȡ��������
while ~feof(fid) %�ж��Ƿ�����ļ�βʱ
    line = fgetl(fid);
    if line(1) == 'G' %�ж��Ƿ������ǵĳ�ʼ��
         gpsnav = gpsnav+1;
         %% ��ȡ�������ݵ�һ��
         dataline = sscanf(line(2:end),'%e'); %����һ�а����ַ�����ȡ
         navdata.gps(gpsnav).prn = dataline(1); %��ȡ�������
         utctime = dataline(2:7); %��ȡ����ʱ��
         gpst = cal2gps(utctime); %������GPSʱ��ת����GPS�ܺ����ڵ���
         navdata.gps(gpsnav).gpst = (gpst(1)*604800+gpst(2)); %���Ƿ����ź�ʱ��ת����UTCʱ�� (����ʱ��)
         navdata.gps(gpsnav).af0 = dataline(8); %ƫ��svClkBias=af0
         navdata.gps(gpsnav).af1 = dataline(9); %Ư��svClkDrf=af1
         navdata.gps(gpsnav).af2 = dataline(10); %Ư���ٶ�svDrfRate=af2
         %% ��ȡ�������ݵڶ���
         line = fgetl(fid);
         dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
         navdata.gps(gpsnav).idoe = dataline(1); %���ݡ���������ʱ��
         navdata.gps(gpsnav).Crs = dataline(2); %Crs
         navdata.gps(gpsnav).deltn =dataline(3); %deltn
         navdata.gps(gpsnav).Mo = dataline(4);%Mo
         %% ��ȡ�������ݵ�����
         line = fgetl(fid);
         dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
         navdata.gps(gpsnav).Cuc = dataline(1); %Cuc
         navdata.gps(gpsnav).es = dataline(2); %es
         navdata.gps(gpsnav).Cus =dataline(3); %Cus
         navdata.gps(gpsnav).sqrtas = dataline(4); %sqrtas
         %% ��ȡ�������ݵ�����
         line = fgetl(fid);
         dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
         navdata.gps(gpsnav).toe = dataline(1); %�����ο�ʱ��toe
         navdata.gps(gpsnav).Cic = dataline(2); %Cic
         navdata.gps(gpsnav).OMGAo =dataline(3); %OMGAo
         navdata.gps(gpsnav).Cis = dataline(4); %Cis
         %% ��ȡ�������ݵ�����
         line = fgetl(fid);
         dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
         navdata.gps(gpsnav).io = dataline(1); %io
         navdata.gps(gpsnav).Crc = dataline(2); %Crc
         navdata.gps(gpsnav).w =dataline(3); %w
         navdata.gps(gpsnav).dtOMGA = dataline(4); %dtOMGA
         %% ��ȡ�������ݵ�����
         line = fgetl(fid);
         dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
         navdata.gps(gpsnav).dti = dataline(1); %dti
         navdata.gps(gpsnav).L2 = dataline(2); %L2�ϵ���
         navdata.gps(gpsnav).GPSWeek =dataline(3); %GPS����
         navdata.gps(gpsnav).L2P = dataline(4); %L2P���ݱ�־
        %% ��ȡ�������ݵ����� 
         line = fgetl(fid);
         dataline = sscanf(line,'%e');
         navdata.gps(gpsnav).SVaccuracy = dataline(1);%���Ǿ���
         navdata.gps(gpsnav).SVhealth= dataline(2);%���ǽ���״̬
         navdata.gps(gpsnav).TGD = dataline(3); %TGD
         navdata.gps(gpsnav).IODC= dataline(4);%IODC�ӵ���������
        %% ��ȡ�������ݵڰ���
         line = fgetl(fid);
         dataline = sscanf(line,'%e');
         navdata.gps(gpsnav).Ttime = dataline(1);%���ķ���ʱ��
         
         if(navdata.gps(gpsnav).SVhealth==1),gpsnav=gpsnav-1;end
         
    end
end
fclose(fid); 



end