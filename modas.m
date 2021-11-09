clc;
clear;
% fid1=fopen('parameter.txt','r');
%参数修改区，按需要对以下变量进行修改。
[canshu1,canshu2,canshu3,qqq,duishu,datapath]=get_canshu;
%****************************************************************
% datapath='X:\XXXX\20210412.dat';  %修改文件日期。 
% ysz=1;      %0为温度剖面，1为声速剖面。 
% duishu=0;  %duishu为0正常输出，为1非等间距输出。
[position,weizhi]=xlsread('hyzb.xlsx');  %修改坐标文件。
%*****************************************************************
% tmp=fgetl(fid1);
%pnumber=str2num(fgetl(fid1));
% b=[datapath,'\',tmp,'.dat']
riqi=[datapath(17:20),'\',datapath(21:22),'\',datapath(23:24)];
strTM=[datapath(17:24)];
if ~exist(strTM)
    mkdir([strTM]);
end
dire=['.\' strTM '\'];
% position=fscanf(fid1,'%f',[2 inf]);
% position=position';
[y,x]=meshgrid(-10:0.125:52,99:0.125:150);
z=[0,5,10,15,20,25,30,35,50,75,100,125,150,175,200,250,300,350,...
   400,450,500,600,700,800,900,1000,1100,1200,1300,1400,1500];
%,...   1600,1700,1750,1800,1900,2000,2500,300,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000]';
sizeA=size(position);
for i=1:sizeA(1)
  zuobiao(i,1)=find(abs(x(1:end,1)-position(i,1))<0.125/2);
  zuobiao(i,2)=find(abs(y(1,1:end)-position(i,3))<0.125/2);
end
fid=fopen(datapath,'r');

for i=1:51
    if i<32
        t(:,:,i)=fread(fid,size(x),'double','n');
    else
        fread(fid,size(x),'double','n');
    end
end
for i=1:51
    if i<32
        y(:,:,i)=fread(fid,size(x),'double','n');
    else
        fread(fid,size(x),'double','n');
    end
end
for i=1:51
    if i<32
        r(:,:,i)=fread(fid,size(x),'double','n');
    else
        fread(fid,size(x),'double','n');
    end
end
for i=1:51
    if i<32
        S(:,:,i)=fread(fid,size(x),'double','n');
    else
        fread(fid,size(x),'double','n');
    end
end
kkkkk=find(t>1000 | y>1000 | S>9999 | r>9999);
t(kkkkk)=nan;
S(kkkkk)=nan;
r(kkkkk)=nan;
y(kkkkk)=nan;
fclose(fid);
% qqq=-1;
%控制三要素图同时显示时的左边距和图宽。4*zbj+3*tk=1;zbj=tk/8。
zbj=0.0357;
tk=0.2857;
for j=1:sizeA(1)
    for i=1:length(canshu1)
        if canshu1(i)==1 && i==1
            yuzhi=0.05;
            tSj1=0.5; %坐标边界外延值
            tSj2=2.0; %横坐标间隔 
            finame='温跃层   ';
            finame2='w_';
            figure(1)
            huatu(zuobiao(j,:),t,z,duishu,tSj1,-tSj2,qqq,finame,yuzhi,canshu2)
            title(['日期：' strTM '              ' '位置：' weizhi{j,1}(1:end) ' (' num2str(position(j,3)) weizhi{j,5}(1:end) ',' num2str(position(j,1)) weizhi{j,3}(1:end) ')'],'fontsize',12,'fontweight','bold');
            saveas(1,[dire,finame2 weizhi{j,1}(1:end)],'png')
            close(1)
            if canshu3==1
                figure(2)
                k1=subplot(1,3,1);
                huatu(zuobiao(j,:),t,z,duishu,tSj1,tSj2,qqq,finame,yuzhi,canshu2)
%                 title(['日期：'strTM '         ' ],'fontsize',12,'fontweight','bold');
                kk1=get(k1,'position');
                set(k1,'position',[zbj kk1(2) tk kk1(4)])
            end
        elseif canshu1(i)==1 && i==2
            yuzhi=0.01;
            tSj1=0.2;
            tSj2=0.5;
            finame='盐跃层   ';
            finame2='y_';
            figure(1)
            huatu(zuobiao(j,:),y,z,duishu,tSj1,-tSj2,qqq,finame,yuzhi,canshu2)
            title(['日期：' strTM '              ' '位置：' weizhi{j,1}(1:end) ' (' num2str(position(j,3)) weizhi{j,5}(1:end) ',' num2str(position(j,1)) weizhi{j,3}(1:end) ')'],'fontsize',12,'fontweight','bold');
            saveas(1,[dire,finame2 weizhi{j,1}(1:end)],'png')
            close(1)
        elseif canshu1(i)==1 && i==3
            yuzhi=0.015;
            tSj1=2;
            tSj2=5;
            finame='密跃层   ';
            finame2='m_';
            figure(1)
            huatu(zuobiao(j,:),r,z,duishu,tSj1,-tSj2,qqq,finame,yuzhi,canshu2)
            title(['日期：' strTM '              ' '位置：' weizhi{j,1}(1:end) ' (' num2str(position(j,3)) weizhi{j,5}(1:end) ',' num2str(position(j,1)) weizhi{j,3}(1:end) ')'],'fontsize',12,'fontweight','bold');
            saveas(1,[dire,finame2 weizhi{j,1}(1:end)],'png')
            close(1)
            if canshu3==1
                figure(2)
                k2=subplot(1,3,2);
                huatu(zuobiao(j,:),r,z,duishu,tSj1,tSj2,qqq,finame,yuzhi,canshu2)
                title(['日期：' strTM '                 ' '位置：' weizhi{j,1}(1:end) ' (' num2str(position(j,3)) weizhi{j,5}(1:end) ',' num2str(position(j,1)) weizhi{j,3}(1:end) ')'],'fontsize',12,'fontweight','bold');
%                 title(['经度：' num2str(position(j,1)) '    '],'fontsize',12,'fontweight','bold');
                set(k2,'position',[2*zbj+tk kk1(2) tk kk1(4)])
            elseif canshu3==2
                figure(2)
                k1=subplot(1,2,1);
                huatu(zuobiao(j,:),r,z,duishu,tSj1,tSj2,qqq,finame,yuzhi,canshu2)
                title(['                                          日期：' strTM ],'fontsize',12,'fontweight','bold');
                kk1=get(k1,'position');
                set(k1,'position',[kk1(1)*1/4 kk1(2) kk1(3)+kk1(1)*3/4 kk1(4)])
            end
        elseif canshu1(i)==1 && i==4
            yuzhi=0.2;
            tSj1=2;
            tSj2=5;
            finame='声跃层   ';
            finame2='s_';
            figure(1)
            huatu(zuobiao(j,:),S,z,duishu,tSj1,-tSj2,qqq,finame,yuzhi,canshu2)
            title(['日期：' strTM '              ' '位置：' weizhi{j,1}(1:end) ' (' num2str(position(j,3)) weizhi{j,5}(1:end) ',' num2str(position(j,1)) weizhi{j,3}(1:end) ')'],'fontsize',12,'fontweight','bold');
            saveas(1,[dire,finame2 weizhi{j,1}(1:end)],'png')
            close(1)
            if canshu3==1
                figure(2)
                k3=subplot(1,3,3);
                huatu(zuobiao(j,:),S,z,duishu,tSj1,tSj2,qqq,finame,yuzhi,canshu2)
%                 title([ '纬度：' num2str(position(j,2))],'fontsize',12,'fontweight','bold');
                set(k3,'position',[3*zbj+2*tk kk1(2) tk kk1(4)])
                k=get(2,'PaperPosition');
%                 set(2,'PaperPosition',[k(1)/4,k(2)/10,k(3)+k(1)/2,k(4)+k(2)/5*4])
%                 k=get(2,'PaperPosition');
%                 set(2,'PaperPosition',[k(1),k(2),k(3)*3,k(4)])
%                 k=get(2,'PaperPosition');
%                 set(2,'papersize',[k(1)*2+k(3),k(2)*2+k(4)])
                set(2,'PaperPosition',[k(1),k(2),k(3)*3,k(4)*1.5])
                saveas(2,[dire,finame2 weizhi{j,1}(1:end) '_h_'],'png')
                close(2)
            elseif canshu3==2
                figure(2)
                k2=subplot(1,2,2);
                huatu(zuobiao(j,:),S,z,duishu,tSj1,tSj2,qqq,finame,yuzhi,canshu2)
                title(['位置：' weizhi{j,1}(1:end) ' (' num2str(position(j,3)) weizhi{j,5}(1:end) ',' num2str(position(j,1)) weizhi{j,3}(1:end) ')' '                                  '],'fontsize',12,'fontweight','bold');
                kk2=get(k2,'position');
                set(k2,'position',[kk2(1)-kk1(1)/4 kk2(2) kk2(3)+kk1(1)*3/4 kk2(4)])
                k=get(2,'PaperPosition');
                set(2,'PaperPosition',[k(1),k(2),k(3)*1.5,k(4)*1.5])
                saveas(2,[dire,finame2 weizhi{j,1}(1:end) '_h_'],'png')
                close(2)
            end
            
        end    
    end
end
