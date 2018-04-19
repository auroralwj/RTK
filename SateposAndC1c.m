    function[satdata,satnum]=SateposAndC1c(navdata,initdata,x0,S,m)
% �������ǵ����꼰���ջ�α��
OMEGAdote = 7.2921151467e-5;%������ת���ٶ�
a1=m;
satnum=0;
for a2=1:initdata.epoch(a1).gpsobs
     P = initdata.epoch(a1).gps(a2).CLC;
     F = initdata.epoch(a1).gps(a2).L1C;
     if (isnan(P)||isnan(F)||(F==0)||(P==0)),continue;end      %�ж����ݵ�α����ز��Ƿ����� 
        for a3=1:length(navdata.gps)           
         if(initdata.epoch(a1).gps(a2).prn==navdata.gps(a3).prn)
            tk = (initdata.epoch(a1).gps(a2).gpst(1)-navdata.gps(a3).gpst(1))*604800 + ...
                  initdata.epoch(a1).gps(a2).gpst(2)-navdata.gps(a3).toe - P/299792458;
              if (tk > 302400)
                  tk = tk - 604800;
              elseif (tk<-302400)
                  tk = tk + 604800;
              end
              if (abs(tk)<7200),break;end  
         end
        end
        toe=navdata.gps(a3).toe;
%         t=basedata.epoch(a1).gps(a2).gpst-basedata.epoch(a1).gps(a2).CLC/299792458;
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
%      %  1.����黯ʱ��tk
%         tk  = t - toe;
%           while(tk > 302400||tk < -302400)
%               if(tk > 302400)
%                   tk = tk - 604800;
%                else
%                   tk = tk + 604800;
%                end
%            end
       %  2.�������ǵ�ƽ�����ٶ�
          no=sqrt(GM/(as^3));   
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
           Eo=Mk+es*sin(Mk);
           E1=Mk+es*sin(Eo);
           E2=Mk+es*sin(E1);
           Ek=Mk+es*sin(E2);
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
            OMGAk=OMGAo+(dtOMGA-dtOMGAe)*tk-dtOMGAe*toe;
        %   11.����������WGS-84���ĵع�ֱ������ϵ��Xt,Yt,Zt���е����꣨X,Y,Z��
            X=xk1*cos(OMGAk)-yk1*cos(ik)*sin(OMGAk);
            Y=xk1*sin(OMGAk)+yk1*cos(ik)*cos(OMGAk);
            Z=yk1*sin(ik);
       % �ӷ���ʱ��ת��������ʱ������ϵ
        dw = OMEGAdote*(initdata.epoch(a1).gps(a2).CLC/299792458);%����ʱ��ת���ĽǶ�
        cw = cos(dw);sw = sin(dw);
        anglepos=[cw sw 0;-sw cw 0;0 0 1]*[X;Y;Z];
       % ����߶Ƚ� thet
       
       %�ҵĸı�
            D=anglepos-x0;
            E=S*D;
            theta=asin(E(3)/sqrt(E(1)^2+E(2)^2+E(3)^2));
    
           if theta>(pi/18)
             satnum = satnum+1; 
             lamda = 0.1903;       %������
            % ���㼴�ڸ��Ե㴦�����ǵľ������վ�����Ǿ���Ru�����ǽǶ�theta
             satdata(satnum).theta =theta;
             satdata(satnum).xs=X;        %�����û����ջ�����õ�����������(xus,yus,zus)
             satdata(satnum).ys=Y;
             satdata(satnum).zs=Z;
             satdata(satnum).prn = initdata.epoch(a1).gps(a2).prn;
             sbr=sqrt((X-x0(1))^2+(Y-x0(2))^2+(Z-x0(3))^2); 
             satdata(satnum).FC=initdata.epoch(a1).gps(a2).L1C*lamda-sbr;   
             satdata(satnum).pc = initdata.epoch(a1).gps(a2).CLC-sbr;
           end
                
            
      
end    



