function [hObject,handles] = corrplot(time,handles,hObject);
%This script plots the important values in the GPS Bistatic processing 
%for the direct and reflected channels
textsize = 10;
%close all; clear; clc

%reflected spacings  (same as those used in processing)
spacing=-28.1:0.05:1.1; %recognize these spacings are reversed
[a,b]=size(spacing);
spacing2=spacing(find(spacing==(-spacing(end))):end);
[aa,bb]=size(spacing2);

%set filenames
fid1=fopen('OutDI.bin','rb');
% fid2=fopen('OutDQ.bin','rb');
% fid3=fopen('OutRI.bin','rb');
% fid4=fopen('OutRQ.bin','rb');

%set avging - typical value is 200msec
disp('BiStatic Radar Processing')
avgnum = time;

%get the first set of data to initiate loop
contloop=1;
[corri,cnt]=fread(fid1,avgnum*bb,'float');
if (cnt ~= avgnum*bb)
    fclose all
    disp('got all the data possible corr_dir_in')
    contloop=0;
end
fid2=fopen('OutDQ.bin','rb');
[corrq,cnt]=fread(fid2,avgnum*bb,'float');
if (cnt ~= avgnum*bb)
    fclose all
    disp('got all the data possible corr_dir_qd')
    contloop=0;
end
fid3=fopen('OutRI.bin','rb');
[corrii,cnt]=fread(fid3,avgnum*b,'float');
if (cnt ~= avgnum*b)
    fclose all
    disp('got all the data possible corr_rfct_in')
    contloop=0;
end
fid4=fopen('OutRQ.bin','rb');
[corrqq,cnt]=fread(fid4,avgnum*b,'float');
if (cnt ~= avgnum*b)
    fclose all
    disp('got all the data possible corr_rfct_in')
    contloop=0;
end

loopcnt=1;
while contloop==1 %infinite loop to continue while data in the files
    
    corri=reshape(corri,bb,avgnum);
    corrq=reshape(corrq,bb,avgnum);
    corrii=reshape(corrii,b,avgnum);
    corrqq=reshape(corrqq,b,avgnum);
    
    %----------------------------------------------------------------------
    
    coherent=0;  %set equal to 1 for coherent, or 0 for noncoherent
    if (coherent)
        for inda = 1:avgnum
            [signmax,signind]=max(abs(corri(:,inda)));
            if (corri(signind,inda) >= 0)
                %no need to do anything as already post
            else
                %flip sign to make it pos
                corri(:,inda) = -1 .* corri(:,inda);
                corrq(:,inda) = -1 .* corrq(:,inda);
                corrii(:,inda) = -1 .* corrii(:,inda);
                corrqq(:,inda) = -1 .* corrqq(:,inda);
            end
        end
        di2=sum((corri'));
        dq2=sum((corrq'));
        ri2=sum((corrii'));
        rq2=sum((corrqq'));
    else
        di2=sum(abs(corri'));
        dq2=sum(abs(corrq'));
        ri2=sum(abs(corrii'));
        rq2=sum(abs(corrqq'));
    end
    %----------------------------------------------------------------------
    
    %do the averaging
    %reorder
    di2=di2(bb:-1:1);
    dq2=dq2(bb:-1:1);
    d3=sqrt(di2 .* di2 + dq2 .* dq2);
    d3save(loopcnt,:)=d3;
    
    %find max and normalize
    ddmax=max(d3);
    di2=di2 ./ ddmax;
    dq2 = dq2 ./ ddmax;
    d3 = d3 ./ ddmax;
    
    %do avg
    %reorder
    ri2=ri2(b:-1:1);
    rq2=rq2(b:-1:1);
    r3=sqrt(ri2 .* ri2 + rq2 .* rq2);
    r3save(loopcnt,:)=r3;
    
    %find max and normalize
    rrmax=max(r3); %use for normalization
    [rrmaxrat,jj]=max(r3(66:b)); %use for max ratio
    ii=jj+55;
    ri2=ri2 ./ rrmax;
    rq2 = rq2 ./ rrmax;
    r3 = r3 ./ rrmax;
    
    %plot correlation results
    
    %direct signal
    dmin=min([di2 dq2]);
    d3min=min([d3]);
    axes(handles.directi);
    plot(spacing2,di2,'r.');hold on
    plot(spacing2,di2,'c');hold off
    axis([(spacing2(1)-0.1) (spacing2(end)+0.1) (dmin-0.05) 1.05])
    title('direct (I)','Fontsize',textsize)
    set(gca,'FontSize',textsize)
    
    axes(handles.directq);
    plot(spacing2,dq2,'g.');hold on
    plot(spacing2,dq2,'c');hold off
    axis([(spacing2(1)-0.1) (spacing2(end)+0.1) (dmin-0.05) 1.05])
    title('direct (Q)','Fontsize',textsize)
    set(gca,'FontSize',textsize)
    
    axes(handles.antop);
    plot(spacing2,d3,'b.');hold on
    plot(spacing2,d3,'m');hold off
    axis([(spacing2(1)-0.1) (spacing2(end)+0.1) (d3min-0.05) 1.05])
    powerrat(loopcnt) = rrmaxrat / ddmax;
    title(['reflected/direct ratio: ',num2str(powerrat(loopcnt))],'Fontsize',textsize)
    set(gca,'FontSize',textsize)
    %reflected signal
    
    
    rmin=min([ri2 rq2]);
    r3min=min([r3]);
    axes(handles.reflecti);
    plot(-spacing(end:-1:1),ri2,'r.');hold on
    plot(-spacing(end:-1:1),ri2,'c');hold off
    axis([(-spacing(end)-0.1) (-spacing(1)+0.1) (rmin-0.05) 1.05])
    title('reflect (I)','Fontsize',textsize)
    set(gca,'FontSize',textsize)
    
    axes(handles.reflectq);
    plot(-spacing(end:-1:1),rq2,'g.');hold on
    plot(-spacing(end:-1:1),rq2,'c');hold off
    axis([(-spacing(end)-0.1) (-spacing(1)+0.1)  (rmin-0.05) 1.05])
    title('reflect (Q)','Fontsize',textsize)
    set(gca,'FontSize',textsize)
    
    axes(handles.anbottom);
    plot(-spacing(end:-1:1),r3,'b.');hold on
    plot(-spacing(end:-1:1),r3,'m');hold off
    axis([(-spacing(end)-0.1) (-spacing(1)+0.1)  (r3min-0.05) 1.05])
    set(gca,'FontSize',textsize)
    
    %set lower bound on where max can be, in case of direct creeping in
    spthresh=find(spacing > 0.75);
    lwbnd=spthresh(1);
    upbnd=b;
    pathdelay(loopcnt)=293*ii*0.05;
    title(['reflected composite; path delay of ',num2str(pathdelay(loopcnt),6),'m '],'Fontsize',textsize)
    xlabel(['time elapsed : ',num2str(loopcnt*avgnum/(60*1000),4),' min; Int#:',int2str(loopcnt)],'Fontsize',textsize)
    
    [corri,cnt]=fread(fid1,avgnum*bb,'float');
    if (cnt ~= avgnum*bb)
        disp('  got all the data possible corr_dir_in')
        contloop=0;
    end
    [corrq,cnt]=fread(fid2,avgnum*bb,'float');
    if (cnt ~= avgnum*bb)
        disp('  got all the data possible corr_dir_qd')
        contloop=0;
    end
    [corrii,cnt]=fread(fid3,avgnum*b,'float');
    if (cnt ~= avgnum*b)
        disp('  got all the data possible corr_rfct_in')
        contloop=0;
    end
    [corrqq,cnt]=fread(fid4,avgnum*b,'float');
    if (cnt ~= avgnum*b)
        disp('  got all the data possible corr_rfct_in')
        contloop=0;
    end
    loopcnt = loopcnt +1 ;
    
    pause(0.001)
end
loopcnt=loopcnt-1;  %adjust for not doing one last iteration

%draw fig of path delay as function of time
figure(200)
subplot(2,1,1),plot((1:loopcnt)*(avgnum/1000),pathdelay,'c');hold on
subplot(2,1,1),plot((1:loopcnt)*(avgnum/1000),pathdelay,'c.');
title(['Estimated Path Delay for Reflected Signal (',int2str(avgnum),' msec avg)'],'Fontsize',textsize)
ylabel('meters','Fontsize',textsize)
xlabel('seconds','Fontsize',textsize)
grid
set(gca,'FontSize',textsize)
subplot(2,1,2),plot((1:loopcnt)*(avgnum/1000),powerrat,'b.');hold on
subplot(2,1,2),plot((1:loopcnt)*(avgnum/1000),powerrat,'g');hold off
title(['Amplitude Ratio ((reflected max)/(direct max))'],'Fontsize',textsize)
ylabel('ratio','Fontsize',textsize)
xlabel('seconds','Fontsize',textsize)
set(gca,'FontSize',textsize)
grid
fclose all;
end