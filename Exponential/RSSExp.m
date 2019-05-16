function RSS = RSSExp(inputTime,inputRate,lagTime,peakValue,lambda,beta)
    % Calculate the residual sum of squares of the simulated exponential decrease and data
    % Both inputTime and inputRate should be lists
    
    if length(inputTime)~=length(inputRate)
        error('Error, the lengths of Time and Rate lists are not consistent');
    end
    
    RSS = 0;
    for i=1:length(inputTime)
        RSS = RSS + (ExponentialFunc(inputTime(i),lagTime,peakValue,lambda,beta)-inputRate(i))^2;
    end
    