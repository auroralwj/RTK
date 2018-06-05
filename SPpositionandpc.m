function[eq,validnum]=SPpositionandpc(obsdata,navdata,x0,gpsnav,m)
%�������������Լ�У�����α��

e1=0;
for a2=1:length(obsdata.obs(m).gps)
        for a3=1:gpsnav
         if(obsdata.obs(m).gps(a2).prn==navdata.gps(a3).prn)
            ak=obsdata.obs(m).gps(a2).gpst-navdata.gps(a3).gpst-obsdata.obs(m).gps(a2).CLC/(2.99792458e8);% ����ʱ���ȥα����Թ��٣�����ʱ�䣩���źŷ���ʱ�� ����ʱ���ȥ��׼ʱ�� 
            if(abs(ak)<7200),       
                toe=navdata.gps(a3).toe;
                as=(navdata.gps(a3).sqrtas)^2;
                es=navdata.gps(a3).es;
                io=navdata.gps(a3).io;
                OMGAo=navdata.gps(a3).OMGAo;
                w=navdata.gps(a3).w;
                Mo=navdata.gps(a3).Mo;
                deltn=navdata.gps(a3).deltn;
                dti=navdata.gps(a3).dti;
                dtOMGA=navdata.gps(a3).dtOMGA;
                Cuc=navdata.gps(a3).Cuc;
                Cus=navdata.gps(a3).Cus;
                Crc=navdata.gps(a3).Crc;
                Crs=navdata.gps(a3).Crs;
                Cic=navdata.gps(a3). Cic;
                Cis=navdata.gps(a3).Cis;
                dtOMGAe=7.2921151467*10^-5;
                GM=3.986005e+14;
               
             %%  1.����黯ʱ��tk
              t=obsdata.obs(m).gps(a2).gpst-obsdata.obs(m).gps(a2).CLC/(2.99792458e8);
%                 tk=ak;
                tk  = t - toe;
               while(tk > 302400||tk < -302400)
                   if(tk > 302400)
                      tk = tk - 604800;
                   else
                      tk = tk + 604800;
                   end
               end
             %%  2.�������ǵ�ƽ�����ٶ�
               no=sqrt(GM/(as^3));   
               n=no+deltn;   
            %%  3.�����źŷ���ʱ��ƽ����Mk
               Mk=Mo+n*tk; 
               while(Mk<0||Mk>2*pi)
                    if(Mk<0)
                       Mk=Mk+2*pi;
                    else
                       Mk=Mk-2*pi;
                    end
               end
            %%  4.�����źŷ���ʱ�̵�ƫ����E
               Eo=Mk+es*sin(Mk);
               E1=Mk+es*sin(Eo);
               E2=Mk+es*sin(E1);
               Ek=Mk+es*sin(E2);
            %%  5.�����źŷ���ʱ�̵�������vk
              cosvk=((cos(Ek)-es)/(1-es*cos(Ek)));
              sinvk=(sqrt(1-es^2))*sin(Ek)/(1-es*cos(Ek));
              vk=atan2(sinvk,cosvk);       
            %%  6.�����źŷ���ʱ�̵�������Ǿ�Faik
              Faik=vk+w;
            %%  7.�����źŷ���ʱ�̵��㶯У����Deltuk,Deltrk,Deltik
              Deltuk=Cus*sin(2*Faik)+Cuc*cos(2*Faik);
              Deltrk=Crs*sin(2*Faik)+Crc*cos(2*Faik);
              Deltik=Cis*sin(2*Faik)+Cic*cos(2*Faik);
            %%  8.�����㶯У�����������Ǿ�uk������ʸ������rk��ik
              uk=Faik+Deltuk;
              rk=as*(1-es*cos(Ek))+Deltrk;
              ik=io+dti*tk+Deltik;
            %%   9.�����źŷ���ʱ�������ڹ��ƽ���λ�ã�xk1,yk1��
              xk1=rk*cos(uk);
              yk1=rk*sin(uk);
            %%   10.�����źŷ���ʱ�̵�������ྭOMGAk
              OMGAk=OMGAo+(dtOMGA-dtOMGAe)*tk-dtOMGAe*toe;
            %%   11.����������WGS-84���ĵع�ֱ������ϵ��Xt,Yt,Zt���е����꣨xk,yk,zk��
              X=xk1*cos(OMGAk)-yk1*cos(ik)*sin(OMGAk);
              Y=xk1*sin(OMGAk)+yk1*cos(ik)*cos(OMGAk);
              Z=yk1*sin(ik);
               %% ���㸩���� thet 
               a=6378137;
               f=1/298.257223563;
               e=sqrt(f*(2-f));
               lambda=atan2(x0(2),x0(1));
               phi=0;
               for i=1:4
               N=a/sqrt(1-e^2*(sin(phi))^2);
               p=sqrt(x0(1)^2+x0(2)^2);
               h=p/cos(phi)-N; 
               phi=atan(x0(3)/(p*(1-(N/(N+h))*e^2)));
               end
               D=[X;Y;Z]-x0;
               S=[-sin(lambda) cos(lambda) 0;...
                  -sin(phi)*cos(lambda) -sin(phi)*sin(lambda) cos(phi);...
                  cos(phi)*cos(lambda) cos(phi)*sin(lambda) sin(phi)];
               E=S*D;
              thet=asin(E(3)/sqrt(E(1)^2+E(2)^2+E(3)^2));
    
             if thet>(pi/18)
              e1=e1+1;
            %   12.���������ڵ�����תtau֮��������WGS-84���ĵع�ֱ������ϵ�е����꣨x,y,z��
              tau=obsdata.obs(m).gps(a2).CLC/(2.99792458e8);
              eq.equ(e1).x=X*cos(dtOMGAe*tau)+Y*sin(dtOMGAe*tau);
              eq.equ(e1).y=Y*cos(dtOMGAe*tau)-X*sin(dtOMGAe*tau);
              eq.equ(e1).z=Z;
             
              % ����ʱ�����
               deltts=navdata.gps(a3).af0+navdata.gps(a3).af1*ak+navdata.gps(a3).af2*(ak^2);
               F=-4.442807633*10^-10;
               delttr=F*es*navdata.gps(a3).sqrtas*sin(Ek);
               deltt=deltts+delttr-navdata.gps(a3).TGD;
%              % �������ʱA
             Ia0=0.1118e-7;Ia1=-0.7451e-8;Ia2=-0.5961e-7;Ia3=0.1192e-10;
             b0=0.1167e6;b1=-0.2294e6;b2=-0.1311e6;b3=0.1049e7;
             phid  = phi / pi * 180;
             lamdad  = lambda / pi * 180;
             Ea  = (445 / (20 + thet)) - 4;
             f   = atan2(D(1),D(2));
             phikd = phid + Ea * cos(f);
             lamdakd = lamdad + Ea * sin(f) / sind(phikd);
             tp = (t + lamdakd / 15) * 3600;
             Qmd = phikd + 111.6 * cosd(lamdakd - 291);
             Qm = Qmd / 180 * pi;
             A = Ia0 + Ia1 * Qm + Ia2 * (Qm)^2 + Ia3 * (Qm)^3;
             P = b0 + b1 * Qm + b2 * (Qm)^2 + b3 * (Qm)^3;
             X = 2 * pi / P * (tp - 50400);
        if abs(X) >= pi / 2
            Iz  = 5e-9;
        else
            Iz  = 5e-9 + A * (1 -X^2 / 2 + X^4 / 24);
        end
        Izp = (1 + 2 * ((96 - thet) / 90)^3) * Iz;
        I   = Izp * 2.99792458e8;
             
             
             % ��������ʱ
              T=2.47/(sin(thet)+0.0121);
            % ����У�����α��
               p=obsdata.obs(m).gps(a2).CLC;
               eq.equ(e1).pc = p+deltt*(2.99792458e8)-T-I;
               a=0.005;
               b=0.005;
               fp=100^2;
               sigma2=fp*(a^2+b^2/(sin((thet)^2)));
               eq.equ(e1).sigma2=1/sigma2; 
             end

                break;end
            
         end
        end
        
end  
validnum=e1;
end





