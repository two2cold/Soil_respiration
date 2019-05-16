function output = CarbonRespirationFunc(k_subC1,k_subC2,k_CB1,k_CB2,t,Se,fracFast,fracSlow,fracC)
    % k_subC1: Empirical factor of solubilization rate, labile [1/hour]
    % k_subC2: Empirical factor of solubilization rate, recalcitrant [1/hour]
    % k_CB1: Carbon usage at 50% of the maximum rate U, fast [gC/m3 water diluted]
    % k_CB2: Carbon usage at 50% of the maximum rate U, slow [gC/m3 water diluted]
    % t: Time [hour]
    % Se: Soil moisture content [-]
    % fracFast: Fraction of soluble carbon fast [gC/m3 water diluted]
    % fracSlow: Fraction of soluble carbon slow [gC/m3 water diluted]
    % fracC: Fraction of C in the soil [-]
    
    % Parameters
    f_s = 0.1; % Portion for microbe growth                                   unitless
    f_e = 1-f_s; % Portion for microbe respiration                            unitless
    M_B = 0.001/24; % Mortality rate of active biomass                        1/hour
    M_BD = M_B/10; % Mortality rate of dormant biomass                        1/hour
    b = 4.9; % Exponent of the water retention curve                          unitless
    k_tran1 = 1; % Transform between active and dormant, fast                 1/hour
    k_tran2 = 1/60; % slow                                                       1/hour
    n = 1; % Empirical facor                                                 unitless
    Psi_AD1 = (0.25)^(-b); % Water potential at 50% of the maximum rate k_AD, fast
    Psi_AD2 = (0.55)^(-b); % slow
    Psi_DA1 = Psi_AD1; % Water potential at 50% of the maximum rate k_DA, fast
    Psi_DA2 = Psi_AD2; % slow
    k_RsolC = 0.0/24; % Empirical factor of respiration rate of soluble organic carbon
    
    % Inputs
    s(1:t) = Se; % Set up the moisture 
    litterFall = 0;%litter fall input                                    gC/m3
    totC(1:length(s)+1)=fracC*1518720/s(1);%total carbon                    gC/m3 water diluted
    %0.02 for upper, 0.014 for middle, and 0.009 for lower
    
    % Initial condition
    subC1=1/4*totC*0.9; % substrate carbon fast              gC/m3 water diluted
    subC2=3/4*totC*0.9; % substrate carbon slow              gC/m3 water diluted
    solC1=1/4*totC*fracFast; % soluble carbon fast           gC/m3 water diluted
    solC2=3/4*totC*fracSlow; % soluble carbon slow            gC/m3 water diluted
    C_B1=totC*0; % starting active biomass, fast                    gC/m3 water diluted
    C_B2=totC*0; % starting active biomass, slow                    gC/m3 water diluted
    C_BD1=1/4*totC*0.1*s(1); % starting dormant biomass, fast       gC/m3 water
    C_BD2=3/4*totC*0.1*s(1); % starting dormant biomass, slow                gC/m3 water
    
    % Inhibition factor
    a=3;%Order of inhibition factor
    k_U1(1:length(s))=1*(1-(nthroot(s(1)*2-1,a)+1)/2);%Number of soluble carbon needed for each microbes per hour, fast
    k_U2(1:length(s))=4*(nthroot(s(1)*2-1,a)+1)/2;%slow
    
    % Initialization of parameters
    D1=zeros(1,length(s));
    D2=zeros(1,length(s));
    U11=zeros(1,length(s));
    U12=zeros(1,length(s));
    U21=zeros(1,length(s));
    U22=zeros(1,length(s));
    R_solC=zeros(1,length(s));
    T_resp=zeros(1,length(s));
    Psi=zeros(1,length(s));
    f_AD1=zeros(1,length(s));
    f_DA1=zeros(1,length(s));
    f_AD2=zeros(1,length(s));
    f_DA2=zeros(1,length(s));
    P_AD1=zeros(1,length(s));
    P_DA1=zeros(1,length(s));
    P_AD2=zeros(1,length(s));
    P_DA2=zeros(1,length(s));
    
    % Calculation
    for i=1:length(s)
        Psi(i)=s(i)^(-b);

        f_AD1(i)=-Psi(i)/((-Psi(i))+(-Psi_AD1));
        f_DA1(i)=-Psi_DA1/(20*(-Psi(i))+(-Psi_DA1));
        f_AD2(i)=-Psi(i)/((-Psi(i))+(-Psi_AD2));
        f_DA2(i)=-Psi_DA2/(20*(-Psi(i))+(-Psi_DA2));

        P_AD1(i)=k_tran1*f_AD1(i)*C_B1(i);
        P_DA1(i)=k_tran1*f_DA1(i)*C_BD1(i);
        P_AD2(i)=k_tran2*f_AD2(i)*C_B2(i);
        P_DA2(i)=k_tran2*f_DA2(i)*C_BD2(i);

        D1(i)=k_subC1*subC1(i);
        D2(i)=k_subC2*subC2(i);
        U11(i)=k_U1(i)*C_B1(i)*solC1(i)^n/(solC1(i)^n+k_CB1^n);
        U12(i)=k_U2(i)*C_B2(i)*solC1(i)^n/(solC1(i)^n+k_CB1^n);
        U21(i)=0*k_U1(i)*C_B1(i)*solC2(i)^n/(solC2(i)^n+k_CB2^n);
        U22(i)=k_U2(i)*C_B2(i)*solC2(i)^n/(solC2(i)^n+k_CB2^n);

        R_solC(i)=k_RsolC*solC1(i);
        subC1(i+1)=subC1(i)+litterFall-D1(i);
        subC2(i+1)=subC2(i)+litterFall-D2(i);
        solC1(i+1)=solC1(i)+D1(i)-U11(i)-U12(i)-R_solC(i)+M_BD*C_BD1(i)+M_B*C_B1(i);
        solC2(i+1)=solC2(i)+D2(i)-U21(i)-U22(i)-R_solC(i)+M_BD*C_BD2(i)+M_B*C_B2(i);
        C_B1(i+1)=C_B1(i)+f_s*(U11(i)+U21(i))+P_DA1(i)-P_AD1(i)-M_B*C_B1(i);
        C_B2(i+1)=C_B2(i)+f_s*(U22(i)+U12(i))+P_DA2(i)-P_AD2(i)-M_B*C_B2(i);
        C_BD1(i+1)=C_BD1(i)+P_AD1(i)-P_DA1(i)-M_BD*C_BD1(i);
        C_BD2(i+1)=C_BD2(i)+P_AD2(i)-P_DA2(i)-M_BD*C_BD2(i);
        T_resp(i)=f_e*(U11(i)+U12(i)+U21(i)+U22(i))+R_solC(i);
    end
    output = f_e*T_resp(length(s))*2.7/1.51872*s(1);
    
    