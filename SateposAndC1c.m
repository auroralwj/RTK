function[satdata,satnum]=SateposAndC1c(navdata,initdata,x0,S,m)
% �������ǵ����꼰���ջ�α��
global flag lamda u OMEGAdote cs ; %������ת���ٶ�
a1=m;
satnum=0;
match = 0;%�ж������Ƿ�ƥ��
gpsnav = length(navdata.system(flag).gps) ;%�����ĸ���
for a2=1:initdata.system(flag).epoch(a1).satnum
    P = initdata.system(flag).epoch(a1).gps(a2).C1C;
    F = initdata.system(flag).epoch(a1).gps(a2).L1C;
    if (isnan(P)||isnan(F)||(F==0)||(P==0)),continue;end      %�ж����ݵ�α����ز��Ƿ����� 
    for a3=1:gpsnav
        %   ����滮ʱ��tk
        if(initdata.system(flag).epoch(a1).gps(a2).prn==navdata.system(flag).gps(a3).prn)
            
            tk = (initdata.system(flag).epoch(a1).gpst(1)-navdata.system(flag).gps(a3).gpst(1))*604800 + ...
                initdata.system(flag).epoch(a1).gpst(2)-navdata.system(flag).gps(a3).toe - P/299792458;
            if (tk > 302400)
                tk = tk - 604800;
            elseif (tk<-302400)
                tk = tk + 604800;
            end
            if (abs(tk)<7200),break;end
        end
        
        %% ��ƥ�䵼���ļ�
         if(a3 == gpsnav),match = 1;end
    end
     if(match==1)
        match=0;
        continue;
    end

    num = navdata.system(flag).gps(a3).prn;
    toe=navdata.system(flag).gps(a3).toe;
    %         t=basedata.epoch(a1).gps(a2).gpst-basedata.epoch(a1).gps(a2).CLC/299792458;
    as=(navdata.system(flag).gps(a3).sqrtas)^2;
    es=navdata.system(flag).gps(a3).es;
    io=navdata.system(flag).gps(a3).io;
    OMGAo=navdata.system(flag).gps(a3).OMGAo;
    w=navdata.system(flag).gps(a3).w;
    Mo=navdata.system(flag).gps(a3).Mo;
    deltn=navdata.system(flag).gps(a3).deltn;
    dti=navdata.system(flag).gps(a3).dti;
    dtOMGA=navdata.system(flag).gps(a3).dtOMGA;
    Cuc=navdata.system(flag).gps(a3).Cuc;
    Cus=navdata.system(flag).gps(a3).Cus;
    Crc=navdata.system(flag).gps(a3).Crc;
    Crs=navdata.system(flag).gps(a3).Crs;
    Cic=navdata.system(flag).gps(a3). Cic;
    Cis=navdata.system(flag).gps(a3).Cis;
    
    %  2.�������ǵ�ƽ�����ٶ�
    no=sqrt(u/(as^3));
    n=no+deltn;
    %  3.�����źŷ���ʱ��ƽ����Mk
    Mk=Mo+n*tk;
    while(Mk<0||Mk>2*pi)
        if(Mk<0)
            Mk=Mk+2*pi;
        else
            Mk=Mk-2*pi;
        end
    end
    %  4.�����źŷ���ʱ�̵�ƫ����E
    Ek = Mk;
    while(1)
        E0 = Ek;
        Ek = Mk+es*sin(E0);
        if(abs(Ek-E0)<1e-12),break;end
    end
    
    %  5.�����źŷ���ʱ�̵�������vk
    cosvk=((cos(Ek)-es)/(1-es*cos(Ek)));
    sinvk=(sqrt(1-es^2))*sin(Ek)/(1-es*cos(Ek));
    vk=atan2(sinvk,cosvk);
    %  6.�����źŷ���ʱ�̵�������Ǿ�Faik
    Faik=vk+w;
    %  7.�����źŷ���ʱ�̵��㶯У����Deltuk,Deltrk,Deltik
    Deltuk=Cus*sin(2*Faik)+Cuc*cos(2*Faik);
    Deltrk=Crs*sin(2*Faik)+Crc*cos(2*Faik);
    Deltik=Cis*sin(2*Faik)+Cic*cos(2*Faik);
    %  8.�����㶯У�����������Ǿ�uk������ʸ������rk��ik
    uk=Faik+Deltuk;
    rk=as*(1-es*cos(Ek))+Deltrk;
    ik=io+dti*tk+Deltik;
    %   9.�����źŷ���ʱ�������ڹ��ƽ���λ�ã�xk1,yk1��
    xk1=rk*cos(uk);
    yk1=rk*sin(uk);
        %   10.�����źŷ���ʱ�̵�������ྭOMGAk
        OMGAk=OMGAo+(dtOMGA-OMEGAdote)*tk-OMEGAdote*toe;
        %   11.����������WGS-84���ĵع�ֱ������ϵ��Xt,Yt,Zt���е����꣨X,Y,Z��
        X=xk1*cos(OMGAk)-yk1*cos(ik)*sin(OMGAk);
        Y=xk1*sin(OMGAk)+yk1*cos(ik)*cos(OMGAk);
        Z=yk1*sin(ik);
%% BDS����GEO/MEO��IGSO���жϣ��Ӷ���ȡλ��
    if  (flag == 2)
        %% �ж�������GEO���ǻ���MEO/IGSO����
        if num<6
         n1 = 5/180*pi;  %geo��ת�ǶȻ���
         pos = [cos(OMEGAdote*tk)  sin(OMEGAdote*tk)  0;....
                -sin(OMEGAdote*tk) cos(OMEGAdote*tk)  0;
                0   0  1 ]*[1 0 0;0 cos(-n1)  sin(-n1);0 -sin(-n1) cos(-n1)] ...
                *[cos(-OMEGAdote*tk)  sin(-OMEGAdote*tk)  0;....
                -sin(-OMEGAdote*tk) cos(-OMEGAdote*tk)  0;0   0  1 ]*[X;Y;Z];
            X=pos(1);
            Y=pos(2);
            Z=pos(3);
            
        end
    end
    
    % �ӷ���ʱ��ת��������ʱ������ϵ
    dw = OMEGAdote*(initdata.system(flag).epoch(a1).gps(a2).C1C/cs);%����ʱ��ת���ĽǶ�
    cw = cos(dw);sw = sin(dw);
    anglepos=[cw sw 0;-sw cw 0;0 0 1]*[X;Y;Z];
    % ����߶Ƚ� thet
    
    %�ҵĸı�
    D=anglepos-x0;
    E=S*D;
    theta=asin(E(3)/sqrt(E(1)^2+E(2)^2+E(3)^2));
    
    if theta>(5*pi/180)
        satnum = satnum+1;
        % ���㼴�ڸ��Ե㴦�����ǵľ������վ�����Ǿ���Ru�����ǽǶ�theta
       
        satdata(satnum).xs=X;        %�����û����ջ�����õ�����������(xus,yus,zus)
        satdata(satnum).ys=Y;
        satdata(satnum).zs=Z;
        satdata(satnum).prn = initdata.system(flag).epoch(a1).gps(a2).prn;
        satdata(satnum).theta =theta;
        sbr=sqrt((X-x0(1))^2+(Y-x0(2))^2+(Z-x0(3))^2);
        satdata(satnum).pc = P-sbr;
        satdata(satnum).FC = F*lamda-sbr;
        
    end
    
    
    
end



