clc
clear all
x = [0 1 2 3 4 5 6 7 8 9 10];
NUMx = [1 3 2 8 22 45 44 42 24 8 3];
trials=numel(x);
Px=NUMx/sum(NUMx);

minimum = inf;
pmin = 0;
KL=zeros(1,11);
KLD=zeros(1,999);

for p=1:999
%% Calculating Binomial PMF
    BP=binopdf(x,10,p/1000);

%% Calculating KL divergence per each Binomial PMF    
    for i=1:trials
        KL(i) = Px(i)*log2(Px(i)/BP(i));
    end
    KLD(p)=sum(KL);

%% Checking if the last KL is minimum or not, if yes save the KL and related P    
    if KLD(p) < minimum
        minimum = KLD(p);
        pmin = p/1000;
    end
end

BinomialPMF=binopdf(x,10,pmin);

figure
xvector = 0.001:0.001:0.999;
plot(xvector,KLD,'color','blue','LineWidth',1.4)
hold on
p1 = plot(pmin,minimum,'r*','MarkerSize',5);
xlim([-0.05 1.05])
ylim([-2 50])
xlabel('P_i','FontSize',12,'FontWeight','normal','FontName','Times New Roman')
ylabel('KL Value','FontSize',12,'FontWeight','normal','FontName','Times New Roman')

title('KL(NUM(x)||BinomialPMF) for 0<p<1 with p-step=0.001','FontSize',14,'FontWeight','normal','FontName','Times New Roman')
legend(p1,'Minimum KL value','FontSize',14,'FontWeight','bold','Interpreter','latex')


Y = [Px; BinomialPMF];
figure
bar(x,Y)
ax.LineWidth = 1.5;
ax.FontSize = 18;
ax.FontName = 'Times New Roman';
xlabel('X_i','FontSize',12,'FontWeight','normal','FontName','Times New Roman')
ylabel('P_i','FontSize',12,'FontWeight','normal','FontName','Times New Roman')

title(['p=',num2str(pmin),' and KL=',num2str(minimum)],'FontSize',14,'FontWeight','normal','FontName','Times New Roman')

label1 = 'NUM(x)';
label2 = 'Binomial PMF';
legend(label1,label2,'FontSize',14,'FontWeight','bold','Interpreter','latex')

