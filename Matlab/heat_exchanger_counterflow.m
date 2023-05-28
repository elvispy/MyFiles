close all;
%% Counterflow pipe

counterflow = true;
L = 60; % m, pip length
r_inner = 0.1; % in m, pipe radius
r_outer = 0.14; % m, outer pipe radius
n = 100; % Number of nodes used

m_inner = 3; % kg/s, mass flow rate
cp_inner = 4180; % J/(kg * K) heat capacity of water)
rho_inner = 1000; % kg/m^3, density of fluid (water)

m_outer = 5; % kg/s, mass flow rate
cp_outer = 4180; % J/(kg * K) heat capacity of water)
rho_outer = 1000; % kg/m^3, density of fluid (water)

area_inner = pi * r_inner^2;
area_outer = pi * r_outer^2;
perimeter_inner = 2 * pi * r_inner;
perimeter_outer = 2 * pi * r_outer;

T_inlet_inner  = 400; % Inlet temperature in Kelvin
T_inlet_outer   = 800; % Inlet temperature in Kelvin
T_guess = 400; % Initial temperature of fluid thourghout the pipe
T_ambient = 300; % Ambient temperature

h_air = 40; % Convective coefficient with air
h = 349; % W/(m^2*K) overall heat transfer coefficient

dx = L/n;
t_final = 1000; % in s, simulation time
dt = 1; % in s, time step

x = linspace(0, L-dx/2, n+1);

T_inner = T_inlet_inner * ones(n+1, 1); 
T_outer = T_inlet_outer * ones(n+1, 1); 

dTinnerdt = zeros(n+1, 1);
dTouterdt = zeros(n+1, 1);

t = 0:dt:t_final;

figure;
sign = -1; if counterflow == 1; sign = 1; end
for jj = 1:length(t)
    dTinnerdt((2-counterflow):(end-counterflow)) =  (sign * m_inner * cp_inner * diff(T_inner) + ...
        h * 2 * pi * r_inner * dx * (T_outer(2:end) - T_inner(2:end))) ...
        /(rho_inner * cp_inner * dx * area_inner);
    
    dTouterdt(2:end) =  (- m_outer * cp_outer * diff(T_outer) - ...
        2 * pi * dx * (h * r_inner * (T_outer(2:end) - T_inner(2:end)) +  ...
        h_air * r_outer * (T_outer(2:end) - T_ambient)))/(rho_outer * cp_outer * dx * area_outer);
    
    T_inner = T_inner + dTinnerdt * dt;
    T_outer = T_outer + dTouterdt * dt;
    
    plot(x, T_inner, 'b');
    hold on;
    xlim([0, L]);
    ylim([298, 820]);
    title(sprintf("Current iteration: %5g ", jj), "FontSize", 16);
    xlabel("Distance (m)", "FontSize", 16);
    ylabel("Temperature (K)", "FontSize", 16);
    plot(x, T_outer, 'r');
    pause(0.0001);
    hold off;
end

q = m_outer * cp_outer * (T_inlet_outer - T_outer(end));

fprintf("The final temperature of the outer fluid is %.3g Kelvin\n", T_outer(end));
fprintf("THe total enery transfer is approximately %.3g kW\n", q/1e+3);