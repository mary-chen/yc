function [err,D,r,bj]=nijieti(t,z,duishu,panduan,yuzhi)
err=[];
zz=0:-1:z(end);
%yyyyyyyyy为阿基玛插值
[tt,tz]=akima(t,z,zz);
[ttz,tzz]=akima(tz,z,zz);
[ind]=chazhao(ttz,yuzhi);
[m,~]=size(ind);
        
if m>1
      if panduan==1
            [D,r,bj]=bianjie(tt,ind,zz);
            for i=1:length(D)
                D(i)=bj(i).s-bj(i).x;
            end
      else
            for i=1:m-1
                D(i)=ind(i+1,1)-ind(i,2);
                r(i)=-tt(ind(i+1,1))/D(i)+tt(ind(i,2))/D(i);
                bj(i).s=zz(ind(i,2));
                bj(i).x=zz(ind(i+1,1));
            end
                D(abs(r)<yuzhi)=[];
                bj(abs(r)<yuzhi)=[];
                r(abs(r)<yuzhi)=[];
      end    
else
       D=[];
       r=[];
       bj=[];
end

% ppppppppppp(ttz,r,D,duishu,bj,zz,yuzhi);    

function [y1,t]=akima(y,x,x1)
[m,n]=size(x);
if m>n
else
    x=x';
end
[m,n]=size(y);
if m>n
    A=zeros(m);
    mn=m;
else
    y=y';
    A=zeros(n);
    mn=n;
end
for i=2:mn-1
    A(i,[i-1,i+1])=[-1,1];
end
A(1,1:3)=[-3,4,-1];
A(end,end-2:end)=[1,-4,3];
A=A/2;
t=A*y./(A*x);
p1(1:mn-1,1)=t(1:end-1);
p2(1:mn-1,1)=(3*(y(2:end)-y(1:end-1))./(x(2:end)-x(1:end-1))-2*t(1:end-1)-t(2:end))./(x(2:end)-x(1:end-1));
p3(1:mn-1,1)=(-2*(y(2:end)-y(1:end-1))./(x(2:end)-x(1:end-1))+t(1:end-1)+t(2:end))./((x(2:end)-x(1:end-1)).^2);
y1=zeros(size(x1));
if x(1)<x(2)
    for i=1:length(x)-1
        k=find(x1>=x(i) & x1<x(i+1));
        if ~isempty(k)
            y1(k)=y(i)+p1(i)*(x1(k)-x(i))+p2(i)*(x1(k)-x(i)).^2+p3(i)*(x1(k)-x(i)).^3;
        end
    end
    if x1(end)==x(end)
        y1(end)=y(end);
    end
else
    for i=1:length(x)-1
        k=find(x1<x(i) & x1>=x(i+1));
        if ~isempty(k)
            y1(k)=y(i)+p1(i)*(x1(k)-x(i))+p2(i)*(x1(k)-x(i)).^2+p3(i)*(x1(k)-x(i)).^3;
        end
    end
    if x1(1)==x(1)
        y1(1)=y(1);
    end
end

function [d,r,t_ind]=shendu(t_ind2,t_ind1,tt)

x=[t_ind2(1):t_ind2(2)]';
xx=[x,ones(size(x))];
y=tt(x)';
ab=(xx'*xx)\(xx'*y);
d=x(end)-x(1)+1;
A=mean(tt(t_ind1(1):t_ind2(1)));
B=mean(tt(t_ind2(2):t_ind1(2)));
t_ind(1)=max(t_ind1(1),round((A-ab(2))/ab(1)));
if t_ind(1)>t_ind2(2)
     t_ind(1)=t_ind2(2);
end 
t_ind(2)=min(t_ind1(2),round((B-ab(2))/ab(1)));
 if t_ind(2)<t_ind2(1) 
     t_ind(2)=t_ind2(1);
 end
r=-ab(1);

function [ind]=chazhao(ttz,yuzhi)
if length(ttz)<200
    yuzhi_q=5;
else
    yuzhi_q=25;
end
k=find(abs(ttz)<yuzhi);
if ~isempty(k) 
    k1=k(2:end)-k(1:end-1);
    k2=find(k1>1);
    ind_x(1).x=k(1);
    ind_x(1).y=k(1);
    if ~isempty(k2)
        for i=1:length(k2)
           ind_x(i+1).x=k(k2(i));
           ind_x(i+1).y=k(k2(i)+1);
        end
    end
    ind_x(end+1).x=k(end);
    ind_x(end).y=k(end);
    for i=1:length(ind_x)-1
        if i==1
            ind(i,1:2)=[ind_x(1).y ind_x(2).x];
        else
            ind(i,1:2)=[ind_x(i).y ind_x(i+1).x];
        end
    end
    ind3=ind(:,2)-ind(:,1);
    m=size(ind3);
    j=0;
    schh=[];
    for i=1:m
         if ind3(i)<yuzhi_q
            if ind(i,1)~=1 && ind(i,2)~=length(ttz)
               if sign(ttz(ind(i,1)-1))==sign(ttz(ind(i,2)+1))  
                   j=j+1;
                   schh(j)=i;
               end
            else
                j=j+1;
                schh(j)=i;
            end    
        end
    end
    if ~isempty(schh)
        ind(schh,:)=[];
    end
     if isempty(ind)
            ind=[];
            ind(1,:)=[1 1];
            ind(2,:)=[length(ttz) length(ttz)]; 
     else
           if ind(1,1)~=1 
               ind(2:end+1,:)=ind;
               ind(1,:)=[1 1];
           end
           if ind(end,2)~=length(ttz)
               ind(end+1,:)=[length(ttz) length(ttz)];
           end    
     end
else
    ind(1,:)=[1 1];
    ind(2,:)=[length(ttz) length(ttz)];
end



function ppppppppppp(ttz,r,D,duishu,bj,zz,yuzhi)
if duishu>=0
    ddd=floor(min(ttz)*100)/100-0.05:(ceil(max(ttz)*100)/100+0.05-floor(min(ttz)*100)/100-0.05)/length(r):ceil(max(ttz)*100)/100+0.05;
    ccc=colormap(jet(length(r)));
    if duishu==1
        plot(ttz,-log(1-zz),'k','linewidth',2)
    else
        plot(ttz,zz,'k','linewidth',2)
    end
    hold on
    grid
    if duishu==1
        plot([yuzhi yuzhi],-log([1500 0]+1),'--g',-[0.05 0.05],-log([1500 0]+1),'--g','linewidth',2)
    else
        plot([yuzhi yuzhi],[-1500 0],'--g',-[0.05 0.05],[-1500 0],'--g','linewidth',2)
    end
    for i=1:length(bj)
        if abs(r(i))>yuzhi
            if duishu~=1
                plot([floor(min(ttz)*100)/100-0.05 ceil(max(ttz)*100)/100+0.05],[bj(i).s bj(i).s],'-.','linewidth',2,'color','r')
                plot([floor(min(ttz)*100)/100-0.05 ceil(max(ttz)*100)/100+0.05],[bj(i).x bj(i).x],'-.','linewidth',2,'color','b')
                text(r(i),mean([bj(i).s bj(i).x]),{[num2str(r(i)),tit];[num2str(D(i)) ' m']},'fontsize',12,'fontname',...
                    'Brush Script MT','VerticalAlignment','middle','color',1-ccc(i,:),'edge',ccc(i,:),'BackgroundColor',ccc(i,:))%,'none')
                text(ddd(i),bj(i).s,{[num2str(-bj(i).s),' m']},'fontsize',12,'fontname',...
                    'Brush Script MT','VerticalAlignment','middle','color',1-ccc(i,:),'edge',ccc(i,:),'BackgroundColor',ccc(i,:))%,'none')
                text(ddd(i+1),bj(i).x,{[num2str(-bj(i).x),' m']},'fontsize',12,'fontname',...
                    'Brush Script MT','VerticalAlignment','middle','color',1-ccc(i,:),'edge',ccc(i,:),'BackgroundColor',ccc(i,:))%,'none')
            else
                plot([floor(min(ttz)*100)/100-0.05 ceil(max(ttz)*100)/100+0.05],-log(1-[bj(i).s bj(i).s]),'-.','linewidth',2,'color','r')
                plot([floor(min(ttz)*100)/100-0.05 ceil(max(ttz)*100)/100+0.05],-log(1-[bj(i).x bj(i).x]),'-.','linewidth',2,'color','b')
                text(r(i),-log(1-mean([bj(i).s bj(i).x])),{[num2str(r(i)),tit];[num2str(D(i)) ' m']},'fontsize',12,'fontname',...
                    'Brush Script MT','VerticalAlignment','middle','color',1-ccc(i,:),'edge',ccc(i,:),'BackgroundColor',ccc(i,:))%,'none')
                text(ddd(i),-log(1-bj(i).s),{[num2str(-bj(i).s),' m']},'fontsize',12,'fontname',...
                    'Brush Script MT','VerticalAlignment','middle','color',1-ccc(i,:),'edge',ccc(i,:),'BackgroundColor',ccc(i,:))%,'none')
                text(ddd(i+1),-log(1-bj(i).x),{[num2str(-bj(i).x),' m']},'fontsize',12,'fontname',...
                    'Brush Script MT','VerticalAlignment','middle','color',1-ccc(i,:),'edge',ccc(i,:),'BackgroundColor',ccc(i,:))%,'none')
            end
        end
    end
    xlim([floor(min(ttz)*100)/100-0.05 ceil(max(ttz)*100)/100+0.05])
    set(gca,'xtick',[floor(min(ttz)*100)/100-0.05:0.05:ceil(max(ttz)*100)/100+0.05])
    if duishu==1
        ylim([-log(1-[-1500]) 0])
        set(gca,'ytick',-log(1-[-1500:300:0]),'yticklabel',{'1500','1200','900','600','300','0(m)'});
    else
        set(gca,'ytick',-1500:300:0,'yticklabel',{'1500','1200','900','600','300','0(m)'});
    end
    hold off
end

 
%m为跃层数,ind包含头尾。
function [d,r,bj]=bianjie(tt,ind,zz)
[m,~]=size(ind);    
for i=1:m-1
        t_ind1=[ind(i,1),ind(i+1,2)];
        t_ind2=[ind(i,2),ind(i+1,1)];
        [d(i),r(i),t_ind]=shendu(t_ind2,t_ind1,tt);
        ind(i+1,1)=t_ind(2);
        bj(i).s=zz(t_ind(1));
        bj(i).x=zz(t_ind(2));
end
