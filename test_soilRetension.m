clear;
n=[1.09 2.68 1.37];
a=[0.008 0.145 0.016];
psi=0:250;
water_s=[0.38 0.43 0.46];
water_r=[0.068 0.045 0.034];
ks=[4.8 7.13 6];
m=1-1./n;
Se=zeros(3,length(psi));
water=zeros(3,length(psi));
kr=zeros(3,length(psi));
for i=1:3
    for j=1:251
        Se(i,j)=(1+abs(a(i)*psi(j))^n(i))^-m(i);
        water(i,j)=(water_s(i)-water_r(i))*Se(i,j)+water_r(i);
        kr(i,j)=Se(i,j)^2*(1-(1-Se(i,j)^(1/m(i)))^m(i));
    end
end

%plot(water,psi,'LineWidth',3);
semilogx(kr(1,:)*ks(1),psi,'LineWidth',3);hold on;
semilogx(kr(2,:)*ks(2),psi,'LineWidth',3);
semilogx(kr(3,:)*ks(3),psi,'LineWidth',3);
set(gca,'fontsize',18);
xlabel('hydraulic conductivity','FontSize',20,'FontWeight','bold');
ylabel('elevation','FontSize',20,'FontWeight','bold');
legend('clay','sand','silt','Location','NorthEast');
%title({'Reactive model fitting';'for upper soil 66% soil moisture'},'FontSize',22,'FontWeight','bold');