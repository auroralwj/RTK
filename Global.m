function Global(systype)
global flag f a cs lamda u OMEGAdote ;
flag = systype;              %�ж�ϵͳΪGPS(1)���Ǳ���(2)
cs = 2.99792458e8;           %����

if(flag == 1)
    
   f = 1/1/298.257223563;
   a = 6378137;%������Բ������
   L1f=1575.42e6;
   lamda = cs/L1f; 
   u = 3.986005e14;           %GM
   OMEGAdote = 7.2921151467e-5;%������ת���ٶ�
elseif(flag == 2)
    a = 6378137.0;%������Բ������
    f = 1/298.257222101;
    L1f = 1561.098e6;
    lamda = cs/L1f; 
    u = 3.986004418e+14;     %GM
    OMEGAdote = 7.2921150e-5;%������ת���ٶ�

end



end