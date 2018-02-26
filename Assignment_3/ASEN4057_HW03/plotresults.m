function [hObject,handles] = plotresults(e_i,e_q,p_i,p_q,l_i,l_q,carrierfq,codefq,hObject, handles)
%Simple script to plot the results of the bistatic processing of the
%direct channel;  create two figures and plot important aspects
textsize = 8;
axes(handles.correlationresults);
plot(p_i .^2 + p_q .^ 2, 'g.-');
hold on
grid
plot(e_i .^2 + e_q .^ 2, 'bx-');
plot(l_i .^2 + l_q .^ 2, 'r+-');
xlabel('milliseconds','Fontsize',textsize)
ylabel('amplitude')
title('Correlation Results','Fontsize',textsize)
legend('prompt','early','late')
set(gca,'FontSize',textsize)
hold off

axes(handles.prompti);
plot(p_i);
grid
xlabel('milliseconds','Fontsize',textsize)
ylabel('amplitude','Fontsize',textsize)
title('Prompt I Channel','Fontsize',textsize)

axes(handles.promptq);
plot(p_q);
grid
xlabel('milliseconds','Fontsize',textsize)
ylabel('amplitude','Fontsize',textsize)
title('Prompt Q Channel','Fontsize',textsize)


axes(handles.topfreq);
plot(1.023e6 - codefq);
grid
xlabel('milliseconds','Fontsize',textsize)
ylabel('Hz','Fontsize',textsize)
title('Tracked Code Frequency (Deviation from 1.023MHz)','Fontsize',textsize)

axes(handles.bottomfreq);
plot(carrierfq);
grid
xlabel('milliseconds','Fontsize',textsize)
ylabel('Hz','Fontsize',textsize)
title('Tracked Intermediate Frequency','Fontsize',textsize)
end
