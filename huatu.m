function huatu(zuobiao,ys,z,duishu,tSj1,tSj2,ppp,finame,yuzhi,canshu2)
if ppp==-1
    tSj1=0.05; %坐标边界外延值
    tSj2=0.02; %横坐标间隔 
elseif ppp==-2
    tSj1=0.05; %坐标边界外延值
    tSj2=-0.02; %横坐标间隔 
end
hold on;
for i=1:1
       tmp=squeeze(ys(zuobiao(i,1),zuobiao(i,2),:));
       Z=z(1:31);
       if 31-sum(isnan(tmp))<=3
            D=nan;
            r=nan;
            sj=nan;
            xj=nan;
        else
            if 31-sum(isnan(tmp))>15 || 31-sum(isnan(tmp))<7
               [~,D,r,bj]= nijieti(tmp(~isnan(tmp)),-z(~isnan(tmp)),-1,0,yuzhi);
            else 
               [~,D,r,bj]= nijieti(tmp(~isnan(tmp)),-z(~isnan(tmp)),-1,1,yuzhi);
            end
       end
       
       Z(isnan(tmp))=nan;
       ZZ=Z(~isnan(Z));    
       tmp=tmp(~isnan(tmp));
%        if ppp>0
% %             [tmp1,~]=akima(tmp(~isnan(tmp)),Z(~isnan(Z)),[0:1:ZZ(end)]);
%        else
%             [~,tmp1]=akima(tmp(~isnan(tmp)),Z(~isnan(Z)),[0:1:ZZ(end)]);
%             tmp=tmp1;
%        end
%        
%        plot(tmp1,0:-1:-ZZ(end),'k','linewidth',2)
       
    
    if duishu>=0
        ddd=floor(min(tmp)*100)/100-tSj1:(ceil(max(tmp)*100)/100+tSj1-floor(min(tmp)*100)/100-tSj1)/length(r):ceil(max(tmp)*100)/100+tSj1;
        ccc=colormap(jet(length(r)));
        if duishu==1
            plot(tmp,-log(ZZ+1),'k','linewidth',2);
        else
            plot(tmp,-ZZ,'k','linewidth',2)
        end
        hold on
        grid
        if ~isnan(D)
            yyyy(1)={[finame]};
            if duishu~=1
                if ppp<0
                    plot([yuzhi yuzhi],[0,-1500],'-g','linewidth',2)
                    plot(-[yuzhi yuzhi],[0,-1500],'-g','linewidth',2)
                end
            else
                if ppp<0
                    plot([yuzhi yuzhi],-log(1-[0,-1500]),'-g','linewidth',2)
                    plot(-[yuzhi yuzhi],-log(1-[0,-1500]),'-g','linewidth',2)
                end
            end
            for j=1:length(bj)
                if abs(r(j))>yuzhi && D(j)>=3
                    if yuzhi==0.05
                        yyyy(end+1)={['(' num2str(-bj(j).s) ',' num2str(-bj(j).x+bj(j).s) ') m, '  num2str(round(1000*(-r(j)))/1000) ' ^oC/m']};
                    elseif yuzhi==0.01
                        yyyy(end+1)={['(' num2str(-bj(j).s) ',' num2str(-bj(j).x+bj(j).s) ') m, '  num2str(round(100*(-r(j)))/100) ' /m']};
                    elseif yuzhi==0.015
                        yyyy(end+1)={['(' num2str(-bj(j).s) ',' num2str(-bj(j).x+bj(j).s) ') m, '  num2str(round(1000*(-r(j)))/1000) ' kg/m^4']};
                    else
                        yyyy(end+1)={['(' num2str(-bj(j).s) ',' num2str(-bj(j).x+bj(j).s) ') m, '  num2str(round(100*(-r(j)))/100) ' /s']};
                    end
                    if duishu~=1
                        plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],[bj(j).s bj(j).s],'-.','linewidth',2,'color','r')
                        plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],[bj(j).x bj(j).x],'-.','linewidth',2,'color','b')
    %                     text(ddd(j),bj(j).s,{[num2str(-bj(j).s),' m']},'fontsize',12,'fontname',...
    %                         'Brush Script MT','VerticalAlignment','middle','color',1-ccc(j,:),'edge',ccc(j,:),'BackgroundColor',ccc(j,:))%,'none')
    %                     text(ddd(j+1),bj(j).x,{[num2str(-bj(j).x),' m']},'fontsize',12,'fontname',...
    %                         'Brush Script MT','VerticalAlignment','middle','color',1-ccc(j,:),'edge',ccc(j,:),'BackgroundColor',ccc(j,:))%,'none')
                    else
                        plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],-log(1-[bj(j).s bj(j).s]),'-.','linewidth',2,'color','r')
                        plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],-log(1-[bj(j).x bj(j).x]),'-.','linewidth',2,'color','b')
    %                     text(ddd(j),-log(1-bj(j).s),{[num2str(-bj(j).s),' m']},'fontsize',12,'fontname',...
    %                         'Brush Script MT','VerticalAlignment','middle','color',1-ccc(j,:),'edge',ccc(j,:),'BackgroundColor',ccc(j,:))%,'none')
    %                     text(ddd(j+1),-log(1-bj(j).x),{[num2str(-bj(j).x),' m']},'fontsize',12,'fontname',...
    %                         'Brush Script MT','VerticalAlignment','middle','color',1-ccc(j,:),'edge',ccc(j,:),'BackgroundColor',ccc(j,:))%,'none')
                    end
                end
            end
            xlabel(yyyy,'fontsize',10);
            if ppp>0
                xlim([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1])
            else
                xlim([floor(min(tmp*100))/100-tSj1 ceil(max(tmp*100))/100+tSj1])
            end
            if ppp>0
                if tSj2>0
                    if length([floor(min(tmp))-tSj1:tSj2:ceil(max(tmp))+tSj1])<=2
                        set(gca,'xtick',[floor(min(tmp))-tSj1:(ceil(max(tmp))+tSj1-floor(min(tmp))+tSj1)/2:ceil(max(tmp))+tSj1])
                    elseif length([floor(min(tmp))-tSj1:tSj2:ceil(max(tmp))+tSj1])<=5 && length([floor(min(tmp))-tSj1:tSj2:ceil(max(tmp))+tSj1])>2
                        set(gca,'xtick',[floor(min(tmp))-tSj1:tSj2:ceil(max(tmp))+tSj1])
                    else
                        set(gca,'xtick',[floor(min(tmp))-tSj1:(ceil(max(tmp))+tSj1-floor(min(tmp))+tSj1)/4:ceil(max(tmp))+tSj1])
                    end
                else
                    set(gca,'xtick',[floor(min(tmp))-tSj1:-tSj2:ceil(max(tmp))+tSj1])
                end
            else
                if tSj2>0
                    if length([floor(min(tmp*100))/100-tSj1:tSj2:ceil(max(tmp*100))/100+tSj1])<=2
                        set(gca,'xtick',[floor(min(tmp))-tSj1:(ceil(max(tmp))+tSj1-floor(min(tmp*100))/100+tSj1)/2:ceil(max(tmp*100))/100+tSj1])
                    elseif length([floor(min(tmp*100))/100-tSj1:tSj2:ceil(max(tmp*100))/100+tSj1])<=5 && length([floor(min(tmp*100))/100-tSj1:tSj2:ceil(max(tmp*100))/100+tSj1])>2
                        set(gca,'xtick',[floor(min(tmp*100))/100-tSj1:tSj2:ceil(max(tmp*100))/100+tSj1])
                    else
                        set(gca,'xtick',[floor(min(tmp*100))/100-tSj1:(ceil(max(tmp*100))/100+tSj1-floor(min(tmp*100))/100+tSj1)/4:ceil(max(tmp*100))/100+tSj1])
                    end
                else
                    set(gca,'xtick',[floor(min(tmp*100))/100-tSj1:-tSj2:ceil(max(tmp*100))/100+tSj1])
                end
            end
            if canshu2==1
                if duishu==1
                    ylim([-log(1-[-1500]) 0])
                    set(gca,'ytick',-log(1-[-1500:300:0]),'yticklabel',{'1500','1200','900','600','300','0(m)'});
                else
                    ylim([-500 0])
                    set(gca,'ytick',-500:50:0,'yticklabel',{'500','450','400','350','300','250','200','150','100','50','0(m)'});
                end
                if duishu==0
                    for k=1:49
                        plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],[-k*10 -k*10],':','linewidth',0.5,'color','k')    
                    end  
                    for k=1:9
                        plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],[-k*50 -k*50],'-','linewidth',1,'color','k')    
                    end  
                end
            else
                if duishu==1
                    ylim([-log(1-[-ZZ(end)]) 0])
                    if ZZ(end)>1000
                        yy=cell(floor(ZZ(end)/300)+1,1);
                        for i=1:length(yy)
                            yy(i)={num2str(ZZ(end)-300*i+300)};
                            yy1(i)=-ZZ(end)+300*i-300;
                        end
                        if yy1(end)>=0
                            yy(end)={'0(m)'};
                        else
                            yy(end+1)={'0(m)'};
                            yy1(end+1)=0;
                        end
                    elseif ZZ(end)>500 && ZZ(end)<=1000
                        yy=cell(floor(ZZ(end)/100)+1,1);
                        for i=1:length(yy)
                            yy(i)={num2str(ZZ(end)-100*i+100)};
                            yy1(i)=-ZZ(end)+100*i-100;
                        end
                        if yy1(end)>=0
                            yy(end)={'0(m)'};
                        else
                            yy(end+1)={'0(m)'};
                            yy1(end+1)=0;
                        end
                    else
                        yy=cell(floor(ZZ(end)/50)+1,1);
                        for i=1:length(yy)
                            yy(i)={num2str(ZZ(end)-50*i+50)};
                            yy1(i)=-ZZ(end)+50*i-50;
                        end
                        if yy1(end)>=0
                            yy(end)={'0(m)'};
                        else
                            yy(end+1)={'0(m)'};
                            yy1(end+1)=0;
                        end
                    end
                    set(gca,'ytick',-log(1-[yy1]),'yticklabel',yy);
                else
                    ylim([-ZZ(end) 0])
                    if ZZ(end)>1000
                        yy=cell(floor(ZZ(end)/300)+1,1);
                        for i=1:length(yy)
                            yy(i)={num2str(ZZ(end)-300*i+300)};
                            yy1(i)=-ZZ(end)+300*i-300;
                        end
                        if yy1(end)>=0
                            yy(end)={'0(m)'};
                        else
                            yy(end+1)={'0(m)'};
                            yy1(end+1)=0;
                        end
                    elseif ZZ(end)>500 && ZZ(end)<=1000
                        yy=cell(floor(ZZ(end)/100)+1,1);
                        for i=1:length(yy)
                            yy(i)={num2str(ZZ(end)-100*i+100)};
                            yy1(i)=-ZZ(end)+100*i-100;
                        end
                        if yy1(end)>=0
                            yy(end)={'0(m)'};
                        else
                            yy(end+1)={'0(m)'};
                            yy1(end+1)=0;
                        end
                    else
                        yy=cell(floor(ZZ(end)/50)+1,1);
                        for i=1:length(yy)
                            yy(i)={num2str(ZZ(end)-50*i+50)};
                            yy1(i)=-ZZ(end)+50*i-50;
                        end
                        if yy1(end)>=0
                            yy(end)={'0(m)'};
                        else
                            yy(end+1)={'0(m)'};
                            yy1(end+1)=0;
                        end
                    end
                    set(gca,'ytick',yy1,'yticklabel',yy);
                end
                if duishu==0
                    if ZZ(end)<501
                        for k=1:floor(ZZ(end)/10)
                            plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],[-k*10 -k*10],':','linewidth',0.5,'color','k')    
                        end  
                        for k=1:9
                            plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],[-k*50 -k*50],'-','linewidth',1,'color','k')    
                        end  
                    elseif ZZ(end)>500 && ZZ(end)<1001
                        for k=1:floor(ZZ(end)/20)
                            plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],[-k*20 -k*20],':','linewidth',0.5,'color','k')    
                        end  
                        for k=1:length(yy1)
                            plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],[yy1(k) yy1(k)],'-','linewidth',1,'color','k')    
                        end  
                    else
                        for k=1:floor(ZZ(end)/50)
                            plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],[-k*50 -k*50],':','linewidth',0.5,'color','k')    
                        end  
                        for k=1:length(yy1)
                            plot([floor(min(tmp))-tSj1 ceil(max(tmp))+tSj1],[yy1(k) yy1(k)],'-','linewidth',1,'color','k')    
                        end  
                    end
                end
            end 

            clear yy1 yy
        end
    end
end
% close(h)

