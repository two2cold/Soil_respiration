% CLM model from Yuchen
% JLD 9/17/2015
%
% Parameter values
clear;
% Glucose
Alg = 0.35;
As1g = 0.21;
As2g = 1-Alg-As1g;
Klg = 1.19;
Ks1g = 0.07;
Ks2g = 0.0002;
Fs1g = As1g/(1-Alg);
% Cellulose
Alc = 0.42;
As1c = 0.3;
As2c = 1-Alc-As1c;
Klc = 0.077;
Ks1c = 0.0145;
Ks2c = 0.0003;
Fs1c = As1c/(1-Alc);
% Lignin
All = 0.2;
As1l = 0.39;
As2l = 1-All-As1l;
Kll = 0.0141;
Ks1l = 0.0014;
Ks2l = 0.0001;
Fs1l = As1l/(1-All);
% timestepping
t = [1:1:10];
%
% function for Glucose
for n = 1:length(t)
  g(n) = Alg*exp(-Klg*(n))+As1g*exp(-Ks1g*(n))+As2g*exp(-Ks2g*(n));
  flg(n) = Alg*exp(-Klg*(n-1))*(1-exp(-Klg))*Alg;
  fs1g(n) = As1g*exp(-Ks1g*(n-1))*(1-exp(-Ks1g))*Fs1g;
  fs2g(n) = As2g*exp(-Ks2g*(n-1))*(1-exp(-Ks2g))*Ks2g;
end
% function for Cellulose
for n = 1:length(t)
  c(n) = Alc*exp(-Klc*(n))+As1c*exp(-Ks1c*(n))+As2c*exp(-Ks2c*(n));
  flc(n) = Alc*exp(-Klc*(n-1))*(1-exp(-Klc))*Alc;
  fs1c(n) = As1c*exp(-Ks1c*(n-1))*(1-exp(-Ks1c))*Fs1c;
  fs2c(n) = As2c*exp(-Ks2c*(n-1))*(1-exp(-Ks2c))*Ks2c;
end
% function for Lignin
for n = 1:length(t)
  l(n) = All*exp(-Kll*(n))+As1l*exp(-Ks1l*(n))+As2l*exp(-Ks2l*(n));
  fll(n) = All*exp(-Kll*(n-1))*(1-exp(-Kll))*All;
  fs1l(n) = As1l*exp(-Ks1l*(n-1))*(1-exp(-Ks1l))*Fs1l;
  fs2l(n) = As2l*exp(-Ks2l*(n-1))*(1-exp(-Ks2l))*Ks2l;
end
%
% take a look
figure(1)
set(gcf,'color','white');
set(gca,'FontSize',18);
%plot(t,g,'b-','LineWidth',3); hold on;
%plot(t,c,'r-','LineWidth',3); 
%plot(t,l,'k-','LineWidth',3); 
plot(t,flg,'b--','LineWidth',3);hold on;
plot(t,flc,'r--','LineWidth',3);
plot(t,fll,'k--','LineWidth',3);
