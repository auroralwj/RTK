function[eq,validnum]=SPpositionandpc(initdata,navdata,x0,S,m)
% �������ǵ����꼰���ջ�α��
global flag  u OMEGAdote cs f a; %������ת���ٶ�
a1=m;
satnum=0;
match = 0;%�ж������Ƿ�ƥ��
gpsnav = length(navdata.system(flag).gps) ;%�����ĸ���
for a2=1:initdata.system(flag).epoch(a1).satnum
    P1 = initdata.system(flag).epoch(a1).gps(a2).C1C;
    F1 = initdata.system(flag).epoch(a1).gps(a2).L1C;
    P2 = initdata.system(flag).epoch(a1).gps(a2).C2C;
    F2 = initdata.system(flag).epoch(a1).gps(a2).L2C;
    
    
    if (isnan(P1)||isnan(F1)||(F1==0)||(P1==0)),continue;end      %�ж����ݵ�α����ز��Ƿ�����
    for a3=1:gpsnav
        %   ����滮ʱ��tk
        if(initdata.system(flag).epoch(a1).gps(a2).prn==navdata.system(flag).gps(a3).prn)
            
            tk = (initdata.system(flag).epoch(a1).gpst(1)-navdata.system(flag).gps(a3).gpst(1))*604800 + ...
                initdata.system(flag).epoch(a1).gpst(2)-navdata.system(flag).gps(a3).toe - P1/299792458;
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
    % ����߶Ƚ� theta
 
    e=sqrt(f*(2-f));
    lambda=atan2(x0(2),x0(1));
    phi=0;
    for i=1:4
        N=a/sqrt(1-e^2*(sin(phi))^2);
        p=sqrt(x0(1)^2+x0(2)^2);
        h=p/cos(phi)-N;
        phi=atan(x0(3)/(p*(1-(N/(N+h))*e^2)));
    end
    %�ҵĸı�
    D=anglepos-x0;
    E=S*D;
    theta=asin(E(3)/sqrt(E(1)^2+E(2)^2+E(3)^2));
    
    if theta>(pi/18)
        satnum=satnum+1;
        
        %   12.���������ڵ�����תtau֮��������WGS-84���ĵع�ֱ������ϵ�е����꣨x,y,z��
        tau=initdata.system(flag).epoch(m).gps(a2).C1C/(2.99792458e8);
        eq.equ(satnum).x=X*cos(OMEGAdote*tau)+Y*sin(OMEGAdote*tau);
        eq.equ(satnum).y=Y*cos(OMEGAdote*tau)-X*sin(OMEGAdote*tau);
        eq.equ(satnum).z=Z;
        
        % ����ʱ�����
        deltts=navdata.system(flag).gps(a3).af0+navdata.system(flag).gps(a3).af1*tk+navdata.system(flag).gps(a3).af2*(tk^2);
        F=-4.442807633*10^-10;
        delttr=F*es*navdata.system(flag).gps(a3).sqrtas*sin(Ek);
        deltt=deltts+delttr-navdata.system(flag).gps(a3).TGD;
        %              % �������ʱA
%         Ia0=0.1118e-7;Ia1=-0.7451e-8;Ia2=-0.5961e-7;Ia3=0.1192e-10;
%         b0=0.1167e6;b1=-0.2294e6;b2=-0.1311e6;b3=0.1049e7;
%         phid  = phi / pi * 180;
%         lamdad  = lambda / pi * 180;
%         Ea  = (445 / (20 + theta)) - 4;
%         f   = atan2(D(1),D(2));
%         phikd = phid + Ea * cos(f);
%         lamdakd = lamdad + Ea * sin(f) / sind(phikd);
%         tp = (t + lamdakd / 15) * 3600;
%         Qmd = phikd + 111.6 * cosd(lamdakd - 291);
%         Qm = Qmd / 180 * pi;
%         A = Ia0 + Ia1 * Qm + Ia2 * (Qm)^2 + Ia3 * (Qm)^3;
%         P = b0 + b1 * Qm + b2 * (Qm)^2 + b3 * (Qm)^3;
%         X = 2 * pi / P * (tp - 50400);
%         if abs(X) >= pi / 2
%             Iz  = 5e-9;
%         else
%             Iz  = 5e-9 + A * (1 -X^2 / 2 + X^4 / 24);
%         end
%         Izp = (1 + 2 * ((96 - theta) / 90)^3) * Iz;
%         I   = Izp * 2.99792458e8;
        
        
        % ��������ʱ
        T=2.47/(sin(theta)+0.0121);
        % ����У�����α��
        p=initdata.system(flag).epoch(m).gps(a2).C1C;
        eq.equ(satnum).pc = p+deltt*(2.99792458e8)-T;
        a=0.005;
        b=0.005;
        fp=100^2;
        sigma2=fp*(a^2+b^2/(sin((theta)^2)));
        eq.equ(satnum).sigma2=1/sigma2;
    end
   

end
validnum=satnum;
end







