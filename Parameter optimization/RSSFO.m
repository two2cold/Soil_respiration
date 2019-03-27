function RSS = RSSFO(inputX,inputY,params,Se,fracC)
% Too lazy

RSS = 0;
for i=1:length(inputX)
    RSS = RSS + (FirstOrderModelFunc(params(1),params(2),Se,inputX(i),params(3),fracC) - inputY(i))^2;
end