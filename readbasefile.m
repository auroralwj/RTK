function[basedata]=readbasefile
% ��ȡ��վ�Ĺ۲��ļ�
NAVfilepath = '.\cut20390.15o';
fid      = fopen(NAVfilepath);
while ~feof(fid)   %feof��δ��������0ֵ
    line = fgetl(fid);
%     if strfind(line,'APPROX POSITION XYZ')
%         xbase=sscanf(line(2:end),'%e'); %% ��ʼ����վ����x1                             
%     end
    if strfind(line,'END OF HEADER'),break;end %% �����ļ�ͷ
end
%end
basedata = NaN; %�����ļ���ȡ������Ϊ��
epochnum = 0;
% ��ȡһ�ι۲��ļ�(��վ�۲��ļ�)
while ~feof(fid)    
line = fgetl(fid);
epochnum = epochnum +1;
dataline = sscanf(line(2:end),'%f');
timeutc = dataline(1:6);
gpst = cal2gps(timeutc);
shu = dataline(8);%��ʱ��������Ŀ
gpsobs = 0; %�����ļ���ÿ����Ԫ�е������ܸ���
    % ����������Ŀ��ȡ��Ϣ
for a=1:shu
    % �����������
    line = fgetl(fid);
    linechang=length(line);
    if linechang<193
        line(linechang+1:193)=0;
    end
    % ��ȡ�۲�����
    if line(1)=='G'
        gpsobs=gpsobs+1;
        basedata.epoch(epochnum).timeutc=timeutc(4:6);
        basedata.epoch(epochnum).gps(gpsobs).gpst =gpst;% ��վ���ջ����ջ��źŽ���ʱ��tu
        basedata.epoch(epochnum).gps(gpsobs).prn = str2double(line(2:3));   % ��վ���յ�����prn��
        basedata.epoch(epochnum).gps(gpsobs).CLC = str2double(line(5:17));  % ��վ���յ�����α����C1L
        basedata.epoch(epochnum).gps(gpsobs).L1C = str2double(line(20:33)); % ��վ���ܵ������ز���λL1C
        %basedata.gps(obsnum).C2W = str2double(line(53:65));
        %basedata.gps(obsnum).L2W = str2double(line(68:81));
        %basedata.gps(obsnum).S2W = str2double(line(91:97));
        %basedata.gps(obsnum).C2X = str2double(line(101:113));
        %basedata.gps(obsnum).L2X = str2double(line(117:129));
        %basedata.gps(obsnum).S2X = str2double(line(139:145));
        %basedata.gps(obsnum).C5Q = str2double(line(149:161));
        %basedata.gps(obsnum).L5Q = str2double(line(165:177));
        %basedata.gps(obsnum).S5Q = str2double(line(187:193));
        
    elseif line(1)=='R'
        
    elseif line(1)=='C'
        
    elseif line(1)=='E'
        
    elseif line(1)=='L'
        
    end
basedata.epoch(epochnum).gpsobs= gpsobs;
end
end
fclose(fid); 
end