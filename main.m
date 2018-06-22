% function[S,x,y,z]= rtkmain(data)
clear,clc
format long;

%% ��ʼ��
%{
--------------��ʼ��-----------------
DOUBLESYS = 1 -- ѡ��˫ϵͳ            |
DOUBLESYS = 2 -- ѡ��ϵͳ            |
data = 1  ------ ѡ������              |
Global(1) -----  ����ϵͳGPS           |
Global(2) -----  ����ϵͳBDS           |
mode = 1  -----  ��˼Ϊ��Ƶ            |
mode = 2  -----  ��˼��˫Ƶ            |
--------------��ʼ��------------------
%}
prompt = '˫ϵͳѡ��    1=N   2=Y    : ';
DOUBLESYS = input(prompt);
if DOUBLESYS ==1
    %% ��˫ϵͳ��λ
    prompt = 'ϵͳѡ��     GPS=1  ����=2 : ';
    sys = input(prompt);
    prompt = 'ģʽѡ��     ��Ƶ=1 ˫Ƶ=2 : ';
    mode = input(prompt);
    prompt = '����ѡ��                   : ';
    data = input(prompt);
    
    
    [x0,x1,dataname] = dataswitch(data);
    load(dataname);
    clear prompt ;
    
    %-----��Ƶ��������õ��㶨λ��ȡδ�̶�λ��----%
    if (mode == 1)
        [SPx,SPy,SPz]=SP(x0,obsdata,navdata);
    end
    
    %-----RTK----%
    wrong=0;
    correct=0;
    h=waitbar(0,'��ȴ�...');
    group=2880;
    
    %-----��ȡ�����ڲ�ͬϵͳ���ת������S----%
    Global(sys);
    [S] = GetS(x0);
    
    for m=1:group
        [basesat,basenum]= SateposAndC1c(navdata,basedata,x0,S,m);
        [movesat,obsnum] = SateposAndC1c(navdata,obsdata,x0,S,m);
        [singaldiff,satnum,maxnum] = SD(basesat,basenum,movesat,obsnum,x0);
        if     (mode ==1)
            [N,d,Qxn,Qn,DDsatnum] = DDS(singaldiff,satnum,maxnum);
        elseif (mode ==2)
            [N,d,Qxn,Qn,DDsatnum] = DDD(singaldiff,satnum,maxnum);
        end
        %-----ģ���ȹ̶�----%
        clear afixed sqnorm Ps Qzhat Z nfixed mu;
        [afixed,sqnorm,Ps,Qzhat,Z,nfixed,mu]= LAMBDA (N,Qn,6,'MU',1/3);
        proba(m)=(nfixed==DDsatnum);
        clear Nf;
        Nf =afixed(:,1);
        %------��������-----%
        df=d-Qxn/Qn*(N-Nf);
        pos=x0+df;
        if(proba(m)==0)
            wrong=wrong+1;
            if(mode == 1)
                totalpos.x(m) = SPx(m);
                totalpos.y(m) = SPy(m);
                totalpos.z(m) = SPz(m);
            else
                posDD = x0 + d ;
                totalpos.x(m) = posDD(1);
                totalpos. y(m) = posDD(2);
                totalpos.z(m) = posDD(3);
            end
        else
            correct=correct+1;
            P(correct)=Ps;
            Dp(:,correct)=df;
            %----�����������ֵ----%
            totalpos.x(m) = pos(1);
            totalpos.y(m) = pos(2);
            totalpos.z(m) = pos(3);
            Corrpos.xc(correct) = pos(1);
            Corrpos.yc(correct) = pos(2);
            Corrpos.zc(correct) = pos(3);
        end
        %-----������Ŀ----%
        st(m) = satnum;
        
        string = ['����������',num2str(floor(m/group*100)),'%'];
        waitbar(m/group,h,string);
    end
    close(h);
    
else
    prompt = 'ģʽѡ��     ��Ƶ=1 ˫Ƶ=2 : ';
    mode = input(prompt);
    prompt = '����ѡ��                   : ';
    data = input(prompt);
    % ˫ϵͳ��ѡ�񵼺�ϵͳΪ3���Ȳ���GPS,Ҳ���Ǳ���
    sys = 3 ;
    
    [x0,x1,dataname] = dataswitch(data);
    load(dataname);
    clear prompt ;
    
    %-----RTK----%
    wrong=0;
    correct=0;
    h=waitbar(0,'��ȴ�...');
    group=2880;
    for m=1:group
        %% ˫ϵͳ��λ
        %-----��ȡ�����ڲ�ͬϵͳ���ת������S----%
        Global(1);
        [S1] = GetS(x0);
        [basesatG,basenumG]= SateposAndC1c(navdata,basedata,x0,S1,m);
        [movesatG,obsnumG] = SateposAndC1c(navdata,obsdata,x0,S1,m);
        [singaldiffG,satnumG,maxnumG] = SD(basesatG,basenumG,movesatG,obsnumG,x0);
        [GMatrixDDD]=DDDDMatrix(singaldiffG,satnumG,maxnumG);
        %-----������Ŀ----%
        st.stG(m) = GMatrixDDD.num;
        
        Global(2);
        [S2] = GetS(x0);
        [basesatC,basenumC]= SateposAndC1c(navdata,basedata,x0,S2,m);
        [movesatC,obsnumC] = SateposAndC1c(navdata,obsdata,x0,S2,m);
        [singaldiffC,satnumC,maxnumC] = SD(basesatC,basenumC,movesatC,obsnumC,x0);
        [CMatrixDDD]=DDDDMatrix(singaldiffC,satnumC,maxnumC);
        %-----������Ŀ----%
        st.stC(m) = CMatrixDDD.num;
        
        if     (mode ==1)
            [N,d,Qxn,Qn,DDsatnum] = SILS(GMatrixDDD,CMatrixDDD);
        elseif (mode ==2)
            [N,d,Qxn,Qn,DDsatnum] = DILS(GMatrixDDD,CMatrixDDD);
        end
        clear afixed sqnorm Ps Qzhat Z nfixed mu;
        [afixed,sqnorm,Ps,Qzhat,Z,nfixed,mu]= LAMBDA (N,Qn,6,'MU',1/3);
        proba(m)=(nfixed==DDsatnum);
        clear Nf;
        Nf =afixed(:,1);
        %------��������-----%
        df=d-Qxn/Qn*(N-Nf);
        pos=x0+df;
        if(proba(m)==0)
            wrong=wrong+1;
            posDD = x0 + d ;
            totalpos.x(m) = posDD(1);
            totalpos.y(m) = posDD(2);
            totalpos.z(m) = posDD(3);
        else
            correct=correct+1;
            P(correct)=Ps;
            Dp(:,correct)=df;
            %----�����������ֵ----%
            totalpos.x(m) = pos(1);
            totalpos.y(m) = pos(2);
            totalpos.z(m) = pos(3);
            Corrpos.xc(correct) = pos(1);
            Corrpos.yc(correct) = pos(2);
            Corrpos.zc(correct) = pos(3);
        end
        S = S1;
        string = ['����������',num2str(floor(m/group*100)),'%'];
        waitbar(m/group,h,string);
    end
    close(h);
end
[CEPL95,CEPH95] =SATS(DOUBLESYS,sys,totalpos,Corrpos,x1,S,st);




