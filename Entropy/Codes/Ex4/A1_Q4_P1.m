clc
clear all
x = [0 1 2 3 4 5 6 7 8 9 10];
NUMx = [1 3 2 8 22 45 44 42 24 8 3];
trials=numel(x);
Px=NUMx/sum(NUMx);

Uni_PMF = ones(1,trials)*(1/trials);

KL=zeros(1,trials);
for i=1:11
    KL(i) = Px(i)*log2(Px(i)/Uni_PMF(i));
end
KLD = sum(KL);
Y = [Px; Uni_PMF];

figure
bar(x,Y);
ax.LineWidth = 1.5;
ax.FontSize = 18;
ax.FontName = 'Times New Roman';
xlabel('X_i','FontSize',12,'FontWeight','normal','FontName','Times New Roman')
ylabel('P_i','FontSize',12,'FontWeight','normal','FontName','Times New Roman')
title(['KL=',num2str(KLD)],'FontSize',14,'FontWeight','normal','FontName','Times New Roman')
label1 = 'NUM(x)';
label2 = 'Uniform PMF';
legend(label1,label2,'FontSize',14,'FontWeight','bold','Interpreter','latex')

