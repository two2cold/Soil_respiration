function listOut = RandExp(amountNum,factor)
% This function creat amountNum of numbers following exponential distribution ranges between 0 and 1
% amountNum represents the amount of numbers need to be generated
% factor represents the factor multiplied to the exponent. 
randNum = factor*rand(1,amountNum);
listOut = 2.^(randNum)./2.^(factor);