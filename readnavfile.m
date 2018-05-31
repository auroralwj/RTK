function[navdata,navfilepath]=readnavfile
% ��ȡ����[navdata]=readnavfile�ļ�
navfilepath = '.\cut00280.16n';
fid      = fopen(navfilepath);
gpsnav = 0;    % GPS�����ļ��е������ܸ���
bdsnav = 0;   % BDS�����ļ��е������ܸ���
navdata = NaN; %�����ļ���ȡ������Ϊ��
% ����ͷ�ļ�
while ~feof(fid)                             %feof��δ��������0ֵ
    line = fgetl(fid);
    if strfind(line,'END OF HEADER'),break;end %% �����ļ�ͷ
end
% ���ж�ȡ��������
while ~feof(fid) %�ж��Ƿ�����ļ�βʱ
    line = fgetl(fid);
    [line]=DtoE(line);
    if line(1) == 'G' %�ж��Ƿ���GPS���ǵĳ�ʼ��
        flag = 1;
        gpsnav = gpsnav+1;
        % ��ȡ�������ݵ�һ��
        dataline = sscanf(line(2:end),'%e'); %����һ�а����ַ�����ȡ
        navdata.system(flag).gps(gpsnav).prn = dataline(1); %��ȡ�������
        utctime = dataline(2:7); %��ȡ����ʱ��
        gpst = cal2gps(utctime); %������GPSʱ��ת����GPS�ܺ����ڵ���
        navdata.system(flag).gps(gpsnav).utctime = utctime;
        navdata.system(flag).gps(gpsnav).gpst = gpst; %���Ƿ����ź�ʱ��ת����UTCʱ�� (����ʱ��)
        navdata.system(flag).gps(gpsnav).af0 = dataline(8); %ƫ��svClkBias=af0
        navdata.system(flag).gps(gpsnav).af1 = dataline(9); %Ư��svClkDrf=af1
        navdata.system(flag).gps(gpsnav).af2 = dataline(10); %Ư���ٶ�svDrfRate=af2
        % ��ȡ�������ݵڶ���
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
        navdata.system(flag).gps(gpsnav).idoe = dataline(1); %���ݡ���������ʱ��
        navdata.system(flag).gps(gpsnav).Crs = dataline(2); %Crs
        navdata.system(flag).gps(gpsnav).deltn =dataline(3); %deltn
        navdata.system(flag).gps(gpsnav).Mo = dataline(4);%Mo
        % ��ȡ�������ݵ�����
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
        navdata.system(flag).gps(gpsnav).Cuc = dataline(1); %Cuc
        navdata.system(flag).gps(gpsnav).es = dataline(2); %es
        navdata.system(flag).gps(gpsnav).Cus =dataline(3); %Cus
        navdata.system(flag).gps(gpsnav).sqrtas = dataline(4); %sqrtas
        % ��ȡ�������ݵ�����
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
        navdata.system(flag).gps(gpsnav).toe = dataline(1); %�����ο�ʱ��toe
        navdata.system(flag).gps(gpsnav).Cic = dataline(2); %Cic
        navdata.system(flag).gps(gpsnav).OMGAo =dataline(3); %OMGAo
        navdata.system(flag).gps(gpsnav).Cis = dataline(4); %Cis
        % ��ȡ�������ݵ�����
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
        navdata.system(flag).gps(gpsnav).io = dataline(1); %io
        navdata.system(flag).gps(gpsnav).Crc = dataline(2); %Crc
        navdata.system(flag).gps(gpsnav).w =dataline(3); %w
        navdata.system(flag).gps(gpsnav).dtOMGA = dataline(4); %dtOMGA
        % ��ȡ�������ݵ�����
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
        navdata.system(flag).gps(gpsnav).dti = dataline(1); %dti
        navdata.system(flag).gps(gpsnav).L2 = dataline(2); %L2�ϵ���
        navdata.system(flag).gps(gpsnav).GPSWeek =dataline(3); %GPS����
        navdata.system(flag).gps(gpsnav).L2P = dataline(4); %L2P���ݱ�־
        % ��ȡ�������ݵ�����
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e');
        navdata.system(flag).gps(gpsnav).SVaccuracy = dataline(1);%���Ǿ���
        navdata.system(flag).gps(gpsnav).SVhealth= dataline(2);%���ǽ���״̬
        navdata.system(flag).gps(gpsnav).TGD = dataline(3); %TGD
        navdata.system(flag).gps(gpsnav).IODC= dataline(4);%IODC�ӵ���������
        % ��ȡ�������ݵڰ���
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e');
        navdata.system(flag).gps(gpsnav).Ttime = dataline(1);%���ķ���ʱ��
        if(navdata.system(flag).gps(gpsnav).SVhealth == 1),gpsnav=gpsnav-1;end
    elseif line(1) == 'C' %�ж��Ƿ���BDS���ǵĳ�ʼ��
        flag = 2;
        bdsnav = bdsnav+1;
        % ��ȡ�������ݵ�һ��
        dataline = sscanf(line(2:end),'%e'); %����һ�а����ַ�����ȡ
        navdata.system(flag).gps(bdsnav).prn = dataline(1); %��ȡ�������
        utctime = dataline(2:7); %��ȡ����ʱ��
        gpst = cal2gps(utctime); %������GPSʱ��ת����GPS�ܺ����ڵ���
        gpst(2)=gpst(2)-14; %����ʱ
        navdata.system(flag).gps(bdsnav).utctime = utctime;
        navdata.system(flag).gps(bdsnav).gpst = gpst; %���Ƿ����ź�ʱ��ת����UTCʱ�� (����ʱ��)
        navdata.system(flag).gps(bdsnav).af0 = dataline(8); %ƫ��svClkBias=af0
        navdata.system(flag).gps(bdsnav).af1 = dataline(9); %Ư��svClkDrf=af1
        navdata.system(flag).gps(bdsnav).af2 = dataline(10); %Ư���ٶ�svDrfRate=af2
        % ��ȡ�������ݵڶ���
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
        navdata.system(flag).gps(bdsnav).idoe = dataline(1); %���ݡ���������ʱ��
        navdata.system(flag).gps(bdsnav).Crs = dataline(2); %Crs
        navdata.system(flag).gps(bdsnav).deltn =dataline(3); %deltn
        navdata.system(flag).gps(bdsnav).Mo = dataline(4);%Mo
        % ��ȡ�������ݵ�����
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
        navdata.system(flag).gps(bdsnav).Cuc = dataline(1); %Cuc
        navdata.system(flag).gps(bdsnav).es = dataline(2); %es
        navdata.system(flag).gps(bdsnav).Cus =dataline(3); %Cus
        navdata.system(flag).gps(bdsnav).sqrtas = dataline(4); %sqrtas
        % ��ȡ�������ݵ�����
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
        navdata.system(flag).gps(bdsnav).toe = dataline(1); %�����ο�ʱ��toe
        navdata.system(flag).gps(bdsnav).Cic = dataline(2); %Cic
        navdata.system(flag).gps(bdsnav).OMGAo =dataline(3); %OMGAo
        navdata.system(flag).gps(bdsnav).Cis = dataline(4); %Cis
        % ��ȡ�������ݵ�����
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
        navdata.system(flag).gps(bdsnav).io = dataline(1); %io
        navdata.system(flag).gps(bdsnav).Crc = dataline(2); %Crc
        navdata.system(flag).gps(bdsnav).w =dataline(3); %w
        navdata.system(flag).gps(bdsnav).dtOMGA = dataline(4); %dtOMGA
        % ��ȡ�������ݵ�����
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e'); %�����а����ַ�����ȡ
        navdata.system(flag).gps(bdsnav).dti = dataline(1); %dti
        navdata.system(flag).gps(bdsnav).L2 = dataline(2); %L2�ϵ���
        navdata.system(flag).gps(bdsnav).GPSWeek =dataline(3); %GPS����
        navdata.system(flag).gps(bdsnav).L2P = dataline(4); %L2P���ݱ�־
        % ��ȡ�������ݵ�����
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e');
        navdata.system(flag).gps(bdsnav).SVaccuracy = dataline(1);%���Ǿ���
        navdata.system(flag).gps(bdsnav).SVhealth= dataline(2);%���ǽ���״̬
        navdata.system(flag).gps(bdsnav).TGD = dataline(3); %TGD
        navdata.system(flag).gps(bdsnav).IODC= dataline(4);%IODC�ӵ���������
        % ��ȡ�������ݵڰ���
        line = fgetl(fid);
        [line]=DtoE(line);
        dataline = sscanf(line,'%e');
        navdata.system(flag).gps(bdsnav).Ttime = dataline(1);%���ķ���ʱ��
        if(navdata.system(flag).gps(bdsnav).SVhealth == 1),bdsnav=bdsnav-1;end
    end
end
fclose(fid);
end