function[obsdata,movefilepath]=readobsfile
% ��ȡ�۲��ļ����û����ջ���
movefilepath = '.\cutb1680.16o';
fid      = fopen(movefilepath);
while ~feof(fid)   %feof��δ��������0ֵ
    line = fgetl(fid);
    %     if strfind(line,'APPROX POSITION XYZ')
    %         xfloat0=sscanf(line(2:end),'%e'); %% ��ʼ������x0
    %     end
    if strfind(line,'END OF HEADER'),break;end %% �����ļ�ͷ
end
%end
obsdata = NaN; %�����ļ���ȡ������Ϊ��
epochnum = 0;
% ��ȡ����ʱ��
while ~feof(fid)
    line = fgetl(fid);
    epochnum = epochnum +1;
    dataline = sscanf(line(2:end),'%f');
    timeutc = dataline(1:6);
    gpst = cal2gps(timeutc);
    obsdata.system(1).epoch(epochnum).gpst =gpst; % GPS�û����ջ����ջ��źŽ���ʱ��tu
    gpst(2)=gpst(2)-14;                               %����ʱ
    obsdata.system(2).epoch(epochnum).gpst =gpst; % BDS�û����ջ����ջ��źŽ���ʱ��tu
    shu = dataline(8);%��ʱ��������Ŀ
    gpsobs = 0; %�۲��ļ���GPSÿ����Ԫ�е������ܸ���
    bdsobs = 0; %�۲��ļ���BDSÿ����Ԫ�е������ܸ���
    
    % ����������Ŀ��ȡ��Ϣ
    for a=1:shu
        % �����������
        line = fgetl(fid);
        linechang=length(line);
        if linechang<193
            line(linechang+1:193)=0;
        end
        %%      �жϲ�ͬ����ϵͳ��ͬƵ�����Ƿ������Ӧ���ز���α��
% %         cada = line(1);
% %         C1C = str2double(line(5:17));
% %         L1C = str2double(line(21:34));
% %         C2C = str2double(line(54:66));
% %         L2C = str2double(line(69:82));
% %         %         C3I = str2double(line(102:114));
% %         %         L3I = str2double(line(117:130));
% %         if ((cada=='C')||(cada=='G'))
% %             if(isnan(C1C)||isnan(L1C)||isnan(C2C)||isnan(L2C))%||isnan(C3I)||isnan(L3I))
% %                 continue;
% %             end
% %         end
        
        %% ��ȡ�۲�����       
        if line(1)=='G'
            flag = 1 ;
            C1C = str2double(line(5:17));
            L1C = str2double(line(21:34));
            C2C = str2double(line(54:66));
            L2C = str2double(line(69:82));
            if(isnan(C1C)||isnan(L1C)||isnan(C2C)||isnan(L2C))%||isnan(C3I)||isnan(L3I))
                continue;
            end
            gpsobs=gpsobs+1;
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).timeutc=timeutc;
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).gpst =gpst;                    % �û����ջ����ջ��źŽ���ʱ��tu
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).prn = str2double(line(2:3));   % �û����յ�����prn��
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).C1C = C1C;  % �û����յ�����α����C1L
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).L1C = L1C; % �û����ܵ������ز���λL1C
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).C2C = C2C;  % �û����յ�����α����C2L
            obsdata.system(flag).epoch(epochnum).gps(gpsobs).L2C = L2C; % �û����ܵ������ز���λL2C
            
        elseif line(1)=='R'
            
        elseif line(1)=='C'
            flag = 2 ;
            C1C = str2double(line(5:17));
            L1C = str2double(line(21:34));
            C2C = str2double(line(54:66));
            L2C = str2double(line(69:82));
             if(isnan(C1C)||isnan(L1C)||isnan(C2C)||isnan(L2C))%||isnan(C3I)||isnan(L3I))
                continue;
            end
            bdsobs=bdsobs+1;
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).timeutc=timeutc;
            gpst(2)=gpst(2)-14; %����ʱ
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).gpst =gpst;                    % �û����ջ����ջ��źŽ���ʱ��tu
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).prn = str2double(line(2:3));   % �û����յ�����prn��
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).C1C = C1C;  % �û����յ�����α����C1L
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).L1C = L1C; % �û����ܵ������ز���λL1C
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).C2C = C2C;  % �û����յ�����α����C2L
            obsdata.system(flag).epoch(epochnum).gps(bdsobs).L2C = L2C; % �û����ܵ������ز���λL2C
        elseif line(1)=='E'
            
        elseif line(1)=='L'
            
        end
        obsdata.system(1).epoch(epochnum).satnum = gpsobs;
        obsdata.system(2).epoch(epochnum).satnum = bdsobs;
    end
end
fclose(fid);
end