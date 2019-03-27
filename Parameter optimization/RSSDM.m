function RSS = RSSDM(inputX,inputY,params,Se,fracC)
% Too lazy to write these

RSS = 0;
for i=1:length(inputX)
    RSS = RSS + (CarbonRespirationFunc(params(1),params(2),params(3),params(4),inputX(i),Se,params(5),params(6),fracC) - inputY(i))^2;
end