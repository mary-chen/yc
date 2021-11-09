function [canshu1,canshu2,canshu3,canshu4,duishu,datapath]=get_canshu
fid=fopen('parameter.txt','r');
datapath=fgetl(fid);
for i=1:4
    tmp=fgetl(fid);
    canshu1(i)=str2num(tmp(1));
end
tmp=fgetl(fid);
canshu2(1)=str2num(tmp(1));
tmp=fgetl(fid);
duishu=str2num(tmp(1));
tmp=fgetl(fid);
canshu3(1)=str2num(tmp(1));
tmp=fgetl(fid);
canshu4(1)=str2num(tmp(1:2));
fclose(fid);
