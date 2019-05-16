function output = Q10Cal(temp,R)
    for i=2:length(R)
        tem(i-1) = (R(i)/R(i-1))^(10/(temp(i)-temp(i-1)));
    end
    output = tem;