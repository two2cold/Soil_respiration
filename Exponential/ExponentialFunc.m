function output = ExponentialFunc(time,lagTime,peakValue,lambda,beta)
    % This is the function that simulate an exponential decrease
    % time represents the time of the output (input)
    % lagTime represents the time before reaches peakValue
    % peakValue represents the peak value of the exponential decrease
    % lambda represents the half-life of the exponential decrease
    % beta represents the equilibrium respiration rate
    
    if time<lagTime
        output = peakValue/lagTime*time;
    else
        output = (peakValue - beta) * exp(-lambda*(time-lagTime)) + beta;
    end