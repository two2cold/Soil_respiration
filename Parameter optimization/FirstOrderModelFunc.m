function output = FirstOrderModelFunc(k_l,k_s,s,t,fracSol,fracC)
    % k_l: decomposition rate constant of litter pool fast, 1/hour
    % k_s: solubilization rate constant of substrate fast, 1/hour
    % s: The effective saturation of the soil
    % t: the time of output (hour)
    % fracSol: the fraction of soluble carbon in the system (-)
    % fracC: Fraction of C in the soil [-]

    s_fc = 0.6; % soil moisture at field capacity for litter fast
    k_d = 4.17E-05; % microbial mortality rate, 1/hour
    r_r = 0.9; % fraction respirated
    r_g = 1-r_r; % fraction growth

    Se(1:t) = s;
    C_l = zeros(1,t); % initializing carbon concentration in litter pool fast
    C_s = zeros(1,t); % initializing carbon concentration in soluble carbon pool fast
    C_b = zeros(1,t); % initializing carbon concentration in biomass pool fast
    ADD = zeros(1,t); % initializing carbon concentration in external input
    BD = zeros(1,t); % initializing microbial mortality rate fast
    DEC_l = zeros(1,t); % initializing microbial respiration rate of fast microbes
    f_d = zeros(1,t); % initializing nondimensional factor fast

    dimentionless = 1;
    C_total = fracC*1518720; % total carbon concentration, converted from volume fraction to gC/m3H2O
    C_l(1) = 0.88*C_total; % carbon concentration in litter pool fast, gC/m3
    C_s(1) = dimentionless*fracSol*C_total; % carbon concentration in soluble pool fast, gC/m3
    C_b(1) = 0.1*C_total; % carbon concentration in biomass pool fast, gC/m3
    ADD(1:t) = 0; % carbon concentration in external input, gC/m3/day

    for i = 1:t
        BD(i) = k_d*C_b(i); % calculating microbial mortality
        if Se(i)<=s_fc % calculating nondimensional factors 1
            f_d(i) = Se(i)/s_fc;
        else
            f_d(i) = s_fc/Se(i);
        end
        DEC_l(i) = k_l*f_d(i)*C_s(i); % calculating microbial respiration rate fast    

        % Mass balance calculations
        C_s(i+1) = C_s(i)+k_s*f_d(i)*C_l(i)-DEC_l(i)+BD(i);
        C_l(i+1) = C_l(i)+ADD(i)-k_s*f_d(i)*C_l(i);
        C_b(i+1) = C_b(i)+r_g*DEC_l(i)-BD(i);
    end
    output = r_r*DEC_l(end);
end